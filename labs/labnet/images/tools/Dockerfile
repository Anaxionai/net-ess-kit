# labnet-tools: a plain Debian machine with the network tools, for the firewall lab
# (labnet-fw, labnet-office and labnet-guest). socat plays the services on labnet-fw.
FROM debian:trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      iproute2 iputils-ping bind9-dnsutils curl netcat-openbsd tcpdump nftables openssl procps socat \
 && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
