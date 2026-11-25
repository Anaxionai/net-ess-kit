# The capstone: design a network, build it, break it, defend it

The last two weeks (CP1 in week 8, CP2 in week 9) are one project: a network for a real need, designed on paper first, built as code, tested path by path, broken by your mentor and defended at the final gate.
You choose one of the three briefs in [`briefs/`](briefs/), or pitch your own network.

| Brief | The network | Suggested route |
|---|---|---|
| [`clinic-branches.md`](briefs/clinic-branches.md) | A clinic with a main site and a branch, joined by a VPN | Lab |
| [`shop-cloud.md`](briefs/shop-cloud.md) | A small online shop on AWS: a public web tier and a private app tier | AWS |
| [`centre-guest.md`](briefs/centre-guest.md) | A training centre with staff, guest and server zones | Lab |

An own pitch needs at least three zones or tiers, at most five zones and two sites, and only tools the course taught. Your mentor decides on day 1.

## The plan is the specification

Copy [`PLAN-template.md`](PLAN-template.md) into your task folder as `capstone/PLAN.md` and keep its headings. From that day on, AxReview and your mentor check every capstone task against **your** plan: each build task says which requirement IDs (R01 …) it delivers, and `capstone/PROGRESS.md` records them.

**The course's hard rule, for every capstone:** only the paths in your access matrix are open, and every path, allowed and blocked, is tested. Each firewall or security-group rule carries the ID of the matrix row it enforces (`comment "A04"` in nftables, `description = "A04 ..."` in OpenTofu). Your brief adds one rule of its own.

## The two weeks

| Day | Task | What happens |
|---|---|---|
| Week 8, day 1 | CP1 learn cards and check, then task 4 | Read the briefs, choose, write `## Need`, `## Requirements`, `## Hard rule`, `## Diagram`, `## Build route` and `## Build plan`. **Your mentor approves the need, the hard rule and the diagram today**, and you write `Approved by <name> on <date>` under `## Need` |
| Week 8, day 2 | Task 5 | The address plan, the access matrix, the test plan and the cost estimate |
| Week 8, days 3–4 | Task 6 | Build the network as code from the plan |
| Week 8, day 4 | Task 7 | `tests/test-matrix.sh` tests every row; one row broken on purpose to prove the tests are real |
| Week 8, day 5 | Tasks 8 and 9 | The runbook, then the milestone review: show your mentor the working network. **Book the fault drill** for early week 9 |
| Week 9, days 1–2 | Task 4 of CP2 | **The fault drill** (one hour, booked with your mentor), then the incident report |
| Week 9, days 2–3 | Tasks 5 and 6 | Harden it (least access, logging, one alert), then tear down what bills and record the cost |
| Week 9, days 4–5 | Tasks 7–9 | The five-minute design talk, your GitHub portfolio, the final wrap-up, **Demo Day** and **gate G3** |

## Two build routes

| | Lab | AWS |
|---|---|---|
| Tools | containerlab, FRR, nftables, WireGuard, dnsmasq, as in P2 OfficeLab | OpenTofu, VPC, security groups, network ACLs, as in P3 CloudNet |
| Where the code lives | `capstone/lab/<name>.clab.yml` and `capstone/lab/configs/<node>/` | `capstone/infra/*.tf` |
| Cost | ₹0. Laptop memory: about 80–95 MB per FRR router and 3 MB per host (see [`setup/containerlab.md`](../setup/containerlab.md)) | Hourly: every instance, every public IPv4 address and a load balancer bill by the hour. No NAT gateway |
| Images | `officelab-router` and `wbitt/network-multitool:extra` | Amazon Linux 2023 and the CloudNet app |

**AWS: destroy every working day.** Run `tofu destroy` at the end of every day you build, paste `Destroy complete!` into `evidence.md`, and `tofu apply` again the next morning. Your budget alarm from P3 (`cloudnet-5usd`) stays on: it is not in OpenTofu's state. If your budget alarm is not set, set it before your first `apply` ([`setup/aws.md`](../setup/aws.md)).

**Lab: one lab at a time.** Destroy your P2 labs first. On an 8 GB laptop, quit Docker Desktop while the capstone lab runs.

## Folder layout

Each capstone task folder holds a copy of `capstone/`, carried forward from the task before:

```text
capstone/
  PLAN.md            from the kit template; the specification
  PROGRESS.md        one section per task: the requirement IDs it delivers
  AI_LOG.md          every use of chat AI: what you asked, what you kept
  lab/  or  infra/   the network as code
  tests/test-matrix.sh
  RUNBOOK.md         how to check it, change it and restore it (CP1 task 8)
  README.md          (CP2 wrap-up)
  INCIDENT.md, HARDENING.md, cost.md, TALK.md   (CP2)
```

No private key, password, token or `.tfstate` file in any committed file. WireGuard keys stay in a `secrets/` folder that `.gitignore` lists; committed configs say `<removed>`.

## The fault drill (CP2)

At the end of week 8, book a one-hour slot with your mentor for early week 9. Before it:

- bring your network up (AWS: `tofu apply`) and run `tests/test-matrix.sh`: every row must pass;
- commit and push.

In the drill, you leave the room for five minutes. Your mentor makes **one** hidden change to the running network (never to your files), then you find it from symptoms and evidence, fix it in your code, and write `INCIDENT.md`. A fault can break an allowed path, or quietly open a blocked one. You are scored on the investigation, not the speed.

## Demo Day and gate G3

- **Demo Day** (end of week 9): a three-minute talk to the cohort and guests: the need, the diagram, the access matrix, the fault you survived, and what it cost.
- **Gate G3, Capstone defence:** a walkthrough with your mentor. Expect to explain your address plan and growth, read a matrix row and show the rule and the test behind it, explain the fault drill, and make one small live change to your network and show its effect with your tests. Keep your lab files ready to deploy (or, on AWS, be ready to apply for one hour).
