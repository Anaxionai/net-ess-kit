# labnet-api: a tiny API written with Python's standard library only, plus the network tools.
FROM python:3.12.16-slim-trixie

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      iproute2 iputils-ping bind9-dnsutils curl netcat-openbsd tcpdump nftables openssl procps \
 && rm -rf /var/lib/apt/lists/*

COPY server.py /app/server.py
EXPOSE 8000
CMD ["python", "-u", "/app/server.py"]
