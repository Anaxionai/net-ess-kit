# NET-ESS course kit

This is the course kit for **NET-ESS, Cloud & DevOps Networking Essentials**, a 9-week course.
It holds what your tasks need beyond your own work: the laptop, containerlab and AWS set-up guides, the lab networks (a three-container app, office networks as code, five broken labs), the CloudNet app and OpenTofu skeleton, the Guided starters and the capstone briefs.
Your task briefs link to files in this kit.

## Get the kit

Run this once, in the **Ubuntu (WSL) terminal**, in week 1 (Launchpad task 11, part 1 of finishing the laptop):

```bash
git clone https://github.com/Anaxionai/net-ess-kit.git ~/net-ess-kit
```

This makes the folder `~/net-ess-kit` in your Linux home. Keep it next to your course repository, never inside it.

Check it: `ls ~/net-ess-kit` lists `README.md`, `VERSIONS.md`, `setup`, `labs` and the other folders below.

Two other terminals need their own copy later, because each has its own home folder:

- **Git Bash**, for the P2 and P3 briefs that copy kit folders in Git Bash: `cd ~ && git clone https://github.com/Anaxionai/net-ess-kit.git` (see [`setup/containerlab.md`](setup/containerlab.md), step 5).
- **The Containerlab terminal** (from week 4): the same clone, as [`setup/containerlab.md`](setup/containerlab.md) shows.

## Update the kit

When a task says "Run `git pull` in your copy of the course kit", run it in the copy that task uses:

```bash
cd ~/net-ess-kit
git pull
```

Do not change the kit's files. Copy a file or folder into your own repository first, then change your copy.
If `git pull` says your local changes would be overwritten, run `git restore .` in the kit folder, then `git pull` again.

## The course in one table

| Weeks | Module | What you build | Kit folders it uses |
|---|---|---|---|
| 1 | LP Launchpad | Your path to real websites, your home network mapped, one web visit in Wireshark, a ready laptop | `setup/windows.md`, `try-it.md` |
| 2–3 | P1 LabNet | Linux and container networking: subnets, routes, ports, DNS, Docker networks, an nftables firewall, HTTPS | `labs/labnet/`, `starters/p01-labnet/` |
| 4–5 | P2 OfficeLab | Two offices as code in containerlab: routing, OSPF, NAT, DHCP and DNS, a WireGuard VPN, zones, five broken labs | `setup/containerlab.md`, `labs/officelab/`, `labs/broken/`, `starters/p02-officelab/` |
| 6–7 | P3 CloudNet | A VPC on AWS with OpenTofu, behind a load balancer with HTTPS, then torn down | `setup/aws.md`, `labs/cloudnet/`, `starters/p03-cloudnet/` |
| 8–9 | CP1, CP2 Capstone | A network for a real need: plan, build, test, survive a fault drill, defend | `capstone/` |

## What is in the kit

| Path | What it is | Used in |
|---|---|---|
| `README.md` | This file | the whole course |
| `LICENSE`, `.gitattributes`, `.gitignore` | The MIT licence, LF line endings for every text file, and the files Git must ignore (captures, OpenTofu state, private keys) | the whole course |
| `VERSIONS.md` | The version of every tool and image the course uses | the whole course |
| `setup/windows.md` | Git Bash in VS Code, WSL 2 with Ubuntu, Docker Desktop, Wireshark and Npcap, and which terminal to use for what | LP |
| `setup/containerlab.md` | The Containerlab WSL distro, the router image, a first two-node lab, and the advice for 8 GB laptops | P2, capstone |
| `setup/aws.md` | The AWS Free plan account, MFA, an IAM user, `aws login`, the budget alarm first, and the teardown rule | P3, capstone |
| `try-it.md` | Free sites: a subnet calculator, the root servers, Wireshark sample captures, Mermaid Live Editor, the AWS Pricing Calculator | learn cards |
| `labs/labnet/` | P1's three-container app (web, api, db) on two Docker networks, and the firewall lab in `firewall/` | P1 |
| `labs/officelab/` | The OfficeLab wiring: one office, then two offices, the router image and each router's `frr.conf` | P2 |
| `labs/broken/` | Five broken labs, each with one fault to find | P2 |
| `labs/cloudnet/` | The CloudNet app, its user-data scripts, and an OpenTofu skeleton with no network resources | P3 |
| `starters/` | The Guided starters: half-done files for each project, for students on the Guided level | P1–P3 |
| `capstone/` | How the capstone works, the plan template and three briefs | CP1, CP2 |

## Safety rules for the whole course

- **Capture and test only your own traffic, your own lab and your own cloud account.** Never scan, capture or probe a network or machine you do not own.
- **No private key, password, token or state file in any committed file.** You make your own WireGuard keys; committed configs hold public keys only. The kit holds no keys.
- **On AWS, the budget alarm comes first, and you destroy what you built at the end of every working day.**

## Line endings

The kit's `.gitattributes` makes Git check out every text file with LF line endings, on Windows too. Topology files, `frr.conf`, scripts and Dockerfiles then work in Linux and in containers. Set VS Code's **Files: Eol** to `\n` ([`setup/windows.md`](setup/windows.md)) so your own files are LF too.

## Licence and attribution

- **The kit's code and configuration** are under the MIT licence: see [`LICENSE`](LICENSE).
- **Made-up names.** Greenleaf Clinic, Claypot Crafts and Brightpath Skills Centre are training briefs, not real organisations. The addresses `198.51.100.0/24` and `203.0.113.0/24` are reserved for documentation (RFC 5737).
- **Tools and images** keep their own licences: FRRouting (GPL-2.0), containerlab (BSD-3-Clause), WireGuard tools (GPL-2.0), nftables (GPL-2.0), dnsmasq (GPL), Caddy (Apache-2.0), OpenTofu (MPL-2.0), Wireshark (GPL-2.0), Npcap (its own free licence for personal use). Docker Desktop is free under the Personal plan for individual learning, and for small businesses with fewer than 250 employees and less than $10 million in yearly revenue.
- Company and product names belong to their owners.
