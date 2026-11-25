# Starter: LabNet (P1, Guided)

This folder becomes your `labnet/` folder in P1 task 8. It holds the frames of the notes, the test script and the firewall files P1 asks for: the headings, table columns and diagram frames are done, so your time goes on the networking. Every answer is still yours.

## Copy it in

In the **Ubuntu terminal**, in P1 task 8's folder:

```bash
cp -r ~/net-ess-kit/starters/p01-labnet labnet
ls labnet
```

From task 9 on, copy your own `labnet/` forward from the task before, as each brief says.

## What is included

| File | Frame for | What you still write |
|---|---|---|
| `address-plan.md` | Task 8 | Every number in the table, the Spare row, `## Growth`, `## Why these sizes` |
| `routing.md` | Task 9 | api's table line by line, the lookups, what removing the default changed |
| `ports.md` | Task 10 | Every listening port, its address and program; the two explanations |
| `dns.md` | Task 11 | The arrows of the sequence diagram, `## Caching`, `## Docker DNS`, `## A site moved` |
| `NETWORKS.md` | Tasks 19 and 20 | The two mistakes, the diagram's subnets and addresses, why web cannot reach db |
| `tests/reach.sh` | Task 20 | The `check` function's body and all six tests |
| `firewall/access-matrix.md` | Task 21 | Every cell |
| `firewall/nftables.conf` | Task 21 | Every rule |
| `tls.md` | Task 22 | The handshake steps, what is encrypted, why `curl` failed |
| `failures.md` | Task 23 | The AI's claims checked against your captures, the two cases, how to tell them apart |

Not included, on purpose: `compose.yml`, `images/` and `web/` (you copy them from the kit in task 19), and the kit's firewall lab files (task 21 copies them into `firewall/`; none of them overwrites a starter file).

## Every TODO

| Task | File | What it asks for |
|---|---|---|
| 8 | `address-plan.md` | The plan for 10.20.0.0/22, growth and sizes |
| 9 | `routing.md` | The routing table explained |
| 10 | `ports.md` | The port table and the two sections |
| 11 | `dns.md` | The diagram's arrows and three sections |
| 19 | `NETWORKS.md` | `## What was wrong` and `## Diagram` |
| 20 | `tests/reach.sh`, `NETWORKS.md` | The tests, and `## Why web cannot reach db` |
| 21 | `firewall/access-matrix.md`, `firewall/nftables.conf` | The matrix and the rules |
| 22 | `tls.md` | The handshake write-up |
| 23 | `failures.md` | The failure write-up |

Tasks 9, 10, 11 and 23 need no file of their own beyond these notes: their commands run in the kit's lab, as the briefs show.

## Run it

Nothing here runs on its own until you fill it in. `tests/reach.sh` runs once you write its tests, with LabNet up: `bash labnet/tests/reach.sh`. Keep LF line endings in every file.
