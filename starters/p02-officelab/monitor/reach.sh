#!/usr/bin/env bash
# Reachability check for the two offices: every 10 seconds, from pc1, ping each target,
# log the result to monitor/reach.csv, and alert on a change of state.
# Run it in the Containerlab terminal, in officelab/, with the two-office lab deployed:
#   export NTFY_TOPIC=...      (only in the terminal: never in a file)
#   bash monitor/reach.sh
# Keep this file with LF line endings.

if [ -z "${NTFY_TOPIC:-}" ]; then
  echo "Set NTFY_TOPIC first: export NTFY_TOPIC=<your topic>" >&2
  exit 1
fi

targets=(10.1.30.10 10.2.10.10 1.1.1.1)

# TODO(task 19): one check of one target, appending time, target, up or down, and round-trip ms to monitor/reach.csv.

# TODO(task 19): the state per target: down after 3 failures in a row, up again after 1 success.

# TODO(task 19): on each change of state, send the alert to ntfy and append it to monitor/alerts.txt.

# TODO(task 19): the loop: every 10 seconds, every target.
