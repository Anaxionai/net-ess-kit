#!/usr/bin/env bash
# LabNet reach tests: each test runs inside its source container and says PASS or FAIL.
# Run it from the folder that holds labnet/, with LabNet up:   bash labnet/tests/reach.sh
# Keep this file with LF line endings.

failures=0

# check FROM TO PORT EXPECT
#   FROM    the source container's short name: web, api or db (the container is labnet-FROM)
#   TO      a name or an address, as the source container sees it
#   PORT    a TCP port
#   EXPECT  open or blocked
# Prints one line: from, to, port, expected, result, then PASS or FAIL.
check() {
  local from="$1" to="$2" port="$3" expect="$4"
  local result
  # TODO(task 20): run nc inside labnet-$from (3-second timeout) and set result to "open" or "blocked"
  #                from its exit code.
  result="TODO"

  local verdict="FAIL"
  if [ "$result" = "$expect" ]; then
    verdict="PASS"
  else
    failures=$((failures + 1))
  fi
  printf '%-4s -> %-22s %-5s expect %-8s got %-8s %s\n' "$from" "$to" "$port" "$expect" "$result" "$verdict"
}

# TODO(task 20): the four tests by name (web to api, api to db, web to db, db to web).

# TODO(task 20): web to db by address (read the address inside this script).

# TODO(task 20): web to host.docker.internal on 5432.

echo "failures: $failures"
exit "$failures"
