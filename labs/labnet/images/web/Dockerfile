# labnet-web: Caddy 2 (a web server and reverse proxy) plus the course's network tools.
# The Caddy image is Alpine Linux, so the package names differ a little from Debian's.
FROM caddy:2.11.9-alpine

RUN apk add --no-cache iproute2 iputils bind-tools curl netcat-openbsd tcpdump nftables openssl procps
