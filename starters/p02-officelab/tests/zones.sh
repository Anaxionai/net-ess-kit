#!/usr/bin/env bash
# Office A's zone tests: one line per access-matrix cell, printed as a Markdown table row.
# Run it in the Containerlab terminal, in officelab/, with the two-office lab deployed:
#   bash tests/zones.sh
# Keep this file with LF line endings.

echo "| From | To | Expected | Result | Verdict |"
echo "|---|---|---|---|---|"

# TODO(task 17): a way to run one test (ping -c 1 -W 2 or curl -s -m 3, inside the source node with
#                docker exec) that prints one row: from, to, expected, result, PASS or FAIL.

# pc1 and guest1 get their addresses by DHCP since task 10, so read them here, for example:
#   pc1_ip=$(docker exec clab-two-offices-pc1 ip -4 -o addr show eth1 | awk '{print $4}' | cut -d/ -f1)

# TODO(task 17): at least 10 tests, allowed and blocked, one per matrix cell.
