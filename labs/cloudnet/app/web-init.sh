#!/bin/bash
# User data for CloudNet's web server (Amazon Linux 2023), read with OpenTofu's templatefile():
#
#   user_data = templatefile("../app/web-init.sh", { site = ..., upstream = ... })
#
#   site      the address Caddy serves: ":80" at first, later your DuckDNS name
#   upstream  where Caddy passes requests: one app server's private IP and port 8080 at first,
#             later the load balancer's DNS name
#
# templatefile() fills in the two values where they appear in dollar-and-braces form below.
# A bash variable must not look like a template value, so it is written with two dollar signs
# and braces, for example $${i}: templatefile() turns that into the bash variable i.
# Keep this file with LF line endings.
#
# It installs Docker from Amazon Linux's own repositories and runs Caddy 2 in a container
# named "caddy", on the host's network, with its certificates in the volume caddy-data (/data).
set -euo pipefail

# The Elastic IP is attached a few seconds after the server starts, so the first tries
# to reach the internet can fail. Keep trying for up to 10 minutes.
for i in $(seq 1 60); do
  if dnf install -y docker; then break; fi
  echo "dnf failed (try $${i}), waiting 10 seconds"
  sleep 10
done
systemctl enable --now docker

mkdir -p /etc/caddy
cat > /etc/caddy/Caddyfile <<'CADDYFILE'
${site} {
	reverse_proxy ${upstream}
}
CADDYFILE

for i in $(seq 1 30); do
  if docker pull caddy:2; then break; fi
  echo "docker pull failed (try $${i}), waiting 10 seconds"
  sleep 10
done

docker rm -f caddy 2>/dev/null || true
docker run -d --name caddy --restart unless-stopped --network host \
  -v caddy-data:/data \
  -v /etc/caddy/Caddyfile:/etc/caddy/Caddyfile:ro \
  caddy:2

echo "web-init done: Caddy serves ${site} and passes requests to ${upstream}"
