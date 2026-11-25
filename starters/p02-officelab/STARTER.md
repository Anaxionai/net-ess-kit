# Starter: OfficeLab (P2, Guided)

This folder becomes your `officelab/` folder in P2 task 7. It holds the same wiring as the kit's `labs/officelab/` (nodes, images, links), with **`r1` done for task 7** (its interface addresses and its static route) and `pc1`'s address lines in the topology. Everything else is a frame with `TODO(task N)` lines. The address table is in the kit's `labs/officelab/README.md`: keep it open.

## Copy it in

In **Git Bash**, in P2 task 7's folder:

```bash
cp -r ~/net-ess-kit/starters/p02-officelab officelab
ls -a officelab
```

Then deploy from the **Containerlab terminal** (drive C: is `/mnt/c`), after building the router image ([`setup/containerlab.md`](../../setup/containerlab.md)):

```bash
containerlab deploy -t office-a.clab.yml --reconfigure
```

As shipped, `pc1` reaches `r1` and the staff side of it. The server needs your task 7 work on `r2`, `srv1` and the route back.

## What is included

| Path | What it is |
|---|---|
| `office-a.clab.yml`, `two-offices.clab.yml` | The kit's wiring; `office-a.clab.yml` has `pc1`'s exec lines and TODO comments where binds and exec lines go |
| `router-image/Dockerfile` | The `officelab-router` image, the same as the kit's |
| `.gitignore` | `clab-*/` and `secrets/` |
| `configs/r1/frr.conf` | **Done for task 7**; TODO for OSPF |
| `configs/r2/frr.conf`, `configs/edge-a/frr.conf`, `configs/edge-b/frr.conf` | Hostnames and TODOs |
| `configs/edge-a/nftables.conf` | The NAT table and chain; the rule is yours |
| `configs/r1/dnsmasq.conf` | Headings for each part of the config |
| `configs/edge-a/wg0.conf`, `configs/edge-b/wg0.conf` | `[Interface]` and `[Peer]` sections only. **No keys**: you make them in task 16 |
| `configs/r1/nftables.conf`, `configs/r2/nftables.conf` | The zone table, a `policy drop` forward chain, no rules |
| `ACCESS.md` | The zone and matrix tables, empty |
| `tests/zones.sh`, `monitor/reach.sh` | Script frames with comments for each part |

## Every TODO

| Task | Files |
|---|---|
| 7 | `office-a.clab.yml` (guest1, srv1), `configs/r2/frr.conf`, `configs/edge-a/frr.conf` |
| 8 | `configs/r1/frr.conf`, `configs/r2/frr.conf`, `configs/edge-a/frr.conf` |
| 9 | `configs/edge-a/frr.conf`, `configs/edge-a/nftables.conf`, `office-a.clab.yml` (edge-a) |
| 10 | `configs/r1/dnsmasq.conf`, `office-a.clab.yml` (r1) |
| 16 | `configs/edge-a/frr.conf`, `configs/edge-b/frr.conf`, both `wg0.conf` files (you also move office A's binds and exec lines into `two-offices.clab.yml`) |
| 17 | `configs/r1/nftables.conf`, `configs/r2/nftables.conf`, `ACCESS.md`, `tests/zones.sh`, `office-a.clab.yml` (r1, r2) |
| 18 | No starter file: the drill copies the kit's `labs/broken/` into `drill/` |
| 19 | `monitor/reach.sh` |

Find what is left with `grep -rn "TODO(task" officelab/`.

## What you still write yourself

Every address except `r1`'s and `pc1`'s, every route after task 7, OSPF, the NAT rule, the DHCP and DNS settings, both WireGuard configs and your keys, every firewall rule, `evidence.md`, `diagram.md`, `NOTES.md`, `drill/DRILL.md` and the scripts' logic.
