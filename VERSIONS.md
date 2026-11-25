# Versions

The tools, images and packages NET-ESS uses, and the version of each.
Briefs never name versions: when a version matters, a task points here.
**Checked on 24 November 2026** against each project's official release page, registry or download page, as the Source column says. The images were built and run on that day.

How to read the tables:

- **Pinned** means: use exactly this version. The kit's own files use it.
- **Course version** means: install this version. A newer patch release (the last number) is fine.
- **Minimum** means: this version or newer.

## On your laptop (Windows)

| Tool | Version | Kind | When | Source and notes |
|---|---|---|---|---|
| Windows | 11, version 23H2 or newer | minimum | week 1 | Docker Desktop needs build 22631 or newer |
| Git for Windows (Git Bash) | 2.45 or newer | minimum | week 1 | git-scm.com |
| VS Code | the newest | — | week 1 | It updates itself. Add the **WSL** extension for the Ubuntu terminal |
| WSL | 2.4.4 or newer | minimum | week 1 | `wsl --version`; update with `wsl --update`. 2.4.4 is also what the Containerlab distro needs (containerlab.dev/windows) |
| Ubuntu on WSL | the current LTS from `wsl --install` | course version | week 1 | Tested with Ubuntu 26.04.1 LTS |
| Docker Desktop | 4.99.0 | course version | week 1 | docs.docker.com; WSL 2 engine. Free under the Personal plan for individual learning, and for small businesses with fewer than 250 employees and less than $10 million in yearly revenue |
| Wireshark | 4.6.10 | course version | week 1 | wireshark.org/download; the Windows x64 installer |
| Npcap | 1.90 (21 October 2026) | course version | week 1 | npcap.com; the Wireshark installer brings the latest stable Npcap |
| Linux tools in Ubuntu | from Ubuntu's `apt` | — | week 1 | `bind9-dnsutils` (dig), `ipcalc`, `netcat-openbsd` (nc), `tcpdump` |

## P2 OfficeLab: containerlab

| Tool or image | Version | Kind | Source and notes |
|---|---|---|---|
| Containerlab WSL distro | `0.83.0-1.0` (8 November 2026) | course version | github.com/srl-labs/wsl-containerlab/releases: the `.wsl` file. Debian 12 with Docker Engine and containerlab inside; user `clab` |
| containerlab | 0.83.0 (7 November 2026) | course version | github.com/srl-labs/containerlab/releases; comes with the distro. Update with `sudo containerlab version upgrade` |
| FRRouting (FRR) | 10.7.1 (31 August 2026) | pinned | frrouting.org; the latest stable release |
| FRR's containerlab image | `quay.io/frrouting/frr:containerlab-10.7.1` | pinned | quay.io/frrouting/frr; containerlab's FRR kind page recommends the `containerlab-<version>` images, published from 10.7.1 on. The base of `officelab-router` |
| `officelab-router` | built from `labs/officelab/router-image/Dockerfile` | — | FRR 10.7.1 on Alpine 3.22.5, plus nftables 1.1.3, wireguard-tools 1.0.20250521, dnsmasq 2.91, tcpdump 4.99.5, bash and dig, from Alpine's packages |
| Host image | `wbitt/network-multitool:extra` | course version | Docker Hub; Alpine 3.24.3, built 27 October 2026. Has ip, ping, traceroute, nc, curl, dig, tcpdump, udhcpc, and nginx on port 80 |

## Networking software, upstream

The kit's images use the versions their Linux distribution packages. The newest upstream releases, for reference:

| Software | Newest release | Source | In the kit's images |
|---|---|---|---|
| WireGuard tools (`wg`, `wg-quick`) | 1.0.20260223 (23 February 2026) | git.zx2c4.com/wireguard-tools | 1.0.20250521 in `officelab-router` (Alpine 3.22). The tunnel itself is in the Linux kernel |
| nftables | 1.1.7 (1 September 2026) | netfilter.org/projects/nftables | 1.1.3 in `officelab-router` and the Debian images; 1.1.6 in Alpine 3.24 |
| dnsmasq | 2.92 | thekelleys.org.uk | 2.91 in `officelab-router` |

## P1 LabNet images

Built by `labs/labnet/compose.yml` from `labs/labnet/images/`.

| Image | Base | Kind | Notes |
|---|---|---|---|
| `labnet-web` | `caddy:2.11.9-alpine` | pinned | Caddy 2.11.9 (5 November 2026) on Alpine 3.24.4 |
| `labnet-api` | `python:3.12.16-slim-trixie` | pinned | Python 3.12.16 on Debian 13.8 |
| `labnet-db` | `postgres:16.16-alpine3.24` | pinned | PostgreSQL 16.16 |
| `labnet-tools` (firewall lab) | `debian:trixie-slim` | course version | Debian 13.8; nftables 1.1.3, tcpdump 4.99.5, dig 9.20 |

Every LabNet image has `ip`, `ss`, `ping`, `dig`, `curl`, `nc` (OpenBSD), `tcpdump`, `nft`, `openssl` and `ps`.

## P3 CloudNet and AWS

| Tool | Version | Kind | Source and notes |
|---|---|---|---|
| AWS CLI v2 | 2.42.2 | course version | github.com/aws/aws-cli (v2 changelog) and winget `Amazon.AWSCLI`. **2.32.0 or newer** is needed for `aws login` |
| OpenTofu | 1.13.9 | course version | github.com/opentofu/opentofu/releases and winget `OpenTofu.Tofu`. Install it with `winget install --exact --id=OpenTofu.Tofu --version 1.13.9`. 1.13.10 came out on 23 November 2026 and was not in winget yet on 24 November; either works. The kit's files need 1.10 or newer |
| AWS provider (`hashicorp/aws`) | 6.74.0 (23 November 2026) | pinned (`~> 6.74.0`) | registry.terraform.io; `tofu init` installs it. `tofu validate` of the kit's skeleton passed with it on 24 November 2026 |
| Server operating system | Amazon Linux 2023 | course version | The SSM parameter `/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64`; its `python3` is 3.9 (3.9.25 tested), which the CloudNet app supports |
| Caddy on the web server | `caddy:2` (now 2.11.9) | course version | Docker Hub; `app/web-init.sh` runs it |
| Instance type | `t3.micro` | course version | On the Free plan's instance list |
| Region | Asia Pacific (Mumbai) `ap-south-1` | pinned | |

## Names and certificates

| Service | Notes |
|---|---|
| DuckDNS | duckdns.org: a free name under `duckdns.org`, A, AAAA and TXT records only |
| Let's Encrypt, through Caddy | At most 5 certificates for the same name every 7 days; never delete Caddy's `/data` volume to "retry" |
