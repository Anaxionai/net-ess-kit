#!/bin/sh
# Test one machine from inside a lab container: ping, then each TCP port.
#
#   docker exec labnet-office sh /lab/test-ports.sh 172.28.30.10
#   docker exec labnet-guest  sh /lab/test-ports.sh 172.28.30.10 80 8080
#
# For each port it prints one result:
#   OPEN     the connection was made: something listens and no rule blocked it
#   REFUSED  a reset came back at once: nothing listens, or a rule says "reject"
#   TIMEOUT  no answer within 3 seconds: a rule dropped the packet silently
#
# Safety: test only your own lab. Never point this at an address outside it.
target="$1"
if [ -z "$target" ]; then
  echo "usage: sh /lab/test-ports.sh <ip> [port ...]" >&2
  exit 2
fi
shift
ports="${*:-22 80 8080 5432}"

echo "from $(hostname) to $target at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
if ping -c 1 -W 2 "$target" >/dev/null 2>&1; then
  echo "ping OK"
else
  echo "ping FAIL"
fi
for port in $ports; do
  out=$(nc -vz -w 3 "$target" "$port" 2>&1)
  rc=$?
  if [ "$rc" -eq 0 ]; then
    result="OPEN"
  elif echo "$out" | grep -qi "refused"; then
    result="REFUSED"
  elif echo "$out" | grep -qiE "timed out|in progress"; then
    result="TIMEOUT"
  else
    result="ERROR ($out)"
  fi
  echo "$port/tcp $result"
done
