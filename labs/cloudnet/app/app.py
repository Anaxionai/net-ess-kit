"""CloudNet's app: Python 3 standard library only, on port 8080.

GET /         -> a short page: this server's hostname, private IP address and Availability Zone
GET /healthz  -> 200 "ok", for the load balancer's health check

On an EC2 instance it reads its private IP and zone from the instance metadata service,
using IMDSv2 (a session token first, then the values). Anywhere else, such as your laptop,
those two lines say "unknown".

Run it on your laptop:   python app.py    then open http://localhost:8080
It works with Python 3.9 (Amazon Linux 2023's python3) and newer.
"""

import json
import socket
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = 8080
IMDS = "http://169.254.169.254/latest"


def imds(path, token):
    """Read one value from the instance metadata service, or None."""
    req = urllib.request.Request(f"{IMDS}/meta-data/{path}", headers={"X-aws-ec2-metadata-token": token})
    with urllib.request.urlopen(req, timeout=1) as resp:
        return resp.read().decode()


def instance_facts():
    """Return (private IP, Availability Zone), or ("unknown", "unknown") off EC2."""
    try:
        req = urllib.request.Request(
            f"{IMDS}/api/token",
            method="PUT",
            headers={"X-aws-ec2-metadata-token-ttl-seconds": "300"},
        )
        with urllib.request.urlopen(req, timeout=1) as resp:
            token = resp.read().decode()
        return imds("local-ipv4", token), imds("placement/availability-zone", token)
    except OSError:
        return "unknown", "unknown"


HOSTNAME = socket.gethostname()
PRIVATE_IP, ZONE = instance_facts()


class Handler(BaseHTTPRequestHandler):
    def _send(self, status, body, content_type="text/plain; charset=utf-8"):
        data = body.encode()
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):  # noqa: N802 (the name http.server expects)
        if self.path == "/healthz":
            self._send(200, "ok\n")
        elif self.path == "/":
            self._send(200, f"CloudNet app\nhostname: {HOSTNAME}\nprivate ip: {PRIVATE_IP}\nzone: {ZONE}\n")
        elif self.path == "/json":
            body = json.dumps({"hostname": HOSTNAME, "private_ip": PRIVATE_IP, "zone": ZONE})
            self._send(200, body + "\n", "application/json")
        else:
            self._send(404, "not found\n")

    def log_message(self, fmt, *args):
        # One line per request on standard output, so journalctl shows it.
        print(f"{self.client_address[0]} {fmt % args}", flush=True)


if __name__ == "__main__":
    print(f"CloudNet app on 0.0.0.0:{PORT} ({HOSTNAME}, {PRIVATE_IP}, {ZONE})", flush=True)
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
