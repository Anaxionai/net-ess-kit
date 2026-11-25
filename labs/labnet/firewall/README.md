# The firewall lab (P1)

One server with nftables ready, and two clients to test it from. You write the server's firewall.

| Container | Address | What it is |
|---|---|---|
| `labnet-fw` | 172.28.30.10 | The server. It listens on TCP 22 (SSH), 80 (web), 8080 (admin) and 5432 (a database stand-in), and has the `NET_ADMIN` permission, so `nft` can change its firewall |
| `labnet-office` | 172.28.30.20 | An office computer |
| `labnet-guest` | 172.28.30.30 | A guest's laptop |

All three are on one network, `172.28.30.0/24`. **This folder is `/lab` inside all three containers**, so a file you save here (your `nftables.conf`) is at `/lab/nftables.conf` in `labnet-fw` at once.

| File | What it is |
|---|---|
| `compose.yml` | The three containers. They build from `../images/tools`, so keep this folder inside your `labnet/` folder |
| `test-ports.sh` | Tests one address from inside a container: ping, then each TCP port |
| `nftables.conf` | **Not in the kit.** You write it in the firewall task |

The four services on `labnet-fw` are stand-ins: each answers one line, so a test can see the port is open. Nothing on it is a real SSH server or database.

**Safety:** test only the lab's containers. Never point `nc`, `test-ports.sh` or any scanner at an address outside your lab or your own cloud account.

## Start it

Run these in the **Ubuntu (WSL) terminal**, in your copy of this folder (`labnet/firewall/`), with Docker Desktop running:

```bash
docker compose up -d
docker exec labnet-office sh /lab/test-ports.sh 172.28.30.10
```

The first start builds the image and takes a minute. With no firewall yet, everything is open:

```text
from labnet-office to 172.28.30.10 at 2026-11-24T14:34:01Z
ping OK
22/tcp OPEN
80/tcp OPEN
8080/tcp OPEN
5432/tcp OPEN
```

Test only some ports by naming them: `docker exec labnet-guest sh /lab/test-ports.sh 172.28.30.10 80 8080`.

## Reading the results

| Result | What happened on the wire | What causes it |
|---|---|---|
| `ping OK` / `ping FAIL` | An ICMP echo reply came back within 2 seconds, or not | A rule allows or drops ICMP |
| `OPEN` | SYN, SYN-ACK, ACK: the handshake finished | A service listens and no rule blocked it |
| `REFUSED` | SYN, then a reset (RST) at once | Nothing listens on that port, or a rule says `reject with tcp reset` |
| `TIMEOUT` | SYN, then nothing, until `nc` gives up after 3 seconds | A rule dropped the packet without an answer |

To watch it happen, capture on the server while a test runs, from a second terminal:

```bash
docker exec -it labnet-fw tcpdump -i eth0 -nn tcp or icmp
```

## Loading your rules

Your `nftables.conf` lives in this folder. In `labnet-fw`:

```bash
docker exec labnet-fw nft -c -f /lab/nftables.conf   # check the file, load nothing
docker exec labnet-fw nft -f /lab/nftables.conf      # load it
docker exec labnet-fw nft list ruleset               # see what is loaded, with counters
```

- `nft -c` finds mistakes before they lock you out. An error names the line.
- `nft list ruleset` also shows tables Docker made for its own DNS server (`table ip nat` with `127.0.0.11`). Leave them alone.
- If your rules lock out even the clients, you can still get in: `docker exec -it labnet-fw sh` needs no network. The firewall task uses this.
- To throw every rule away, start a fresh server: `docker compose up -d --force-recreate fw`. A new container starts with no rules.

## Stop it

```bash
docker compose down
```

## If something goes wrong

| What you see | What to do |
|---|---|
| `Operation not permitted` from `nft` | You ran it in `labnet-office` or `labnet-guest`. Run it in `labnet-fw`, which has `NET_ADMIN`. |
| `Could not process rule: No such file or directory` for `/lab/nftables.conf` | Save the file in this folder, then run the command again. Check you started the lab from this folder. |
| `unable to prepare context` or `../images/tools` not found | This folder must sit inside your `labnet/` folder, next to `images/`. |
| `Pool overlaps with other one on this address space` | Another Docker network uses `172.28.30.0/24`. `docker network ls` shows it; stop that project. |
| Every port says `TIMEOUT` after you load the rules | Your input chain drops everything and accepts nothing for that client. Check the accept lines and their addresses. |
| `labnet-fw` cannot resolve names or download anything | With `policy drop` on input, the answers to the server's own requests are dropped too. Read the lesson on `ct state established,related`. |
