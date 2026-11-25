"""LabNet's API: Python's standard library only, on port 8000.

GET /api/health  ->  {"status": "ok", "db": "open", ...}
    "db" says whether a TCP connection to db:5432 works from this container.
GET /api/whoami  ->  this container's name and addresses
"""

import json
import socket
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

DB_HOST = "db"
DB_PORT = 5432


def check_db() -> str:
    """Try one TCP connection to the database and say what happened."""
    try:
        with socket.create_connection((DB_HOST, DB_PORT), timeout=2):
            return "open"
    except socket.gaierror:
        return "no such name"
    except TimeoutError:
        return "timeout"
    except ConnectionRefusedError:
        return "refused"
    except OSError as err:
        return f"error: {err.strerror or err}"


def addresses() -> list[str]:
    try:
        return sorted({info[4][0] for info in socket.getaddrinfo(socket.gethostname(), None, socket.AF_INET)})
    except OSError:
        return []


class Handler(BaseHTTPRequestHandler):
    def _send(self, status: int, body: dict) -> None:
        data = json.dumps(body).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self) -> None:  # noqa: N802 (the name http.server expects)
        if self.path == "/api/health":
            self._send(200, {"status": "ok", "service": "api", "db": check_db(), "db_target": f"{DB_HOST}:{DB_PORT}"})
        elif self.path == "/api/whoami":
            self._send(200, {"hostname": socket.gethostname(), "addresses": addresses()})
        else:
            self._send(404, {"error": "not found", "try": ["/api/health", "/api/whoami"]})


if __name__ == "__main__":
    server = ThreadingHTTPServer(("0.0.0.0", 8000), Handler)
    print("labnet-api listening on 0.0.0.0:8000", flush=True)
    server.serve_forever()
