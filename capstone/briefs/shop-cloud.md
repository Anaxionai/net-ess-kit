# Brief: Claypot Crafts, a small online shop on AWS

**Suggested route: AWS** (OpenTofu, as in P3 CloudNet). Claypot Crafts is a training brief, not a real shop.

## The need

Claypot Crafts sells handmade pottery. Its shop runs on one rented server that is open to the whole internet on every port, with the database on the same machine. The owner wants the shop rebuilt on AWS in Mumbai with the parts separated: a public web tier that is the only thing customers can reach, a private app tier behind it, and nothing else reachable from the internet. It must be cheap: the shop runs on AWS credits for now.

## Users

| Group | Where | Now | In two years | What they must reach |
|---|---|---|---|---|
| Customers | The internet | about 200 visits a day | about 2,000 a day | The shop at its name, over HTTPS only |
| The owner and one helper | Anywhere | 2 | 3 | The admin pages, over HTTPS, from the shop's own login only |
| The developer (you) | Your laptop | 1 | 2 | A shell on each server through Session Manager (no SSH) |
| The app servers | Private subnets | 2 | 4 | Operating system updates, without a NAT gateway |

## Tiers

- **Web tier** (public subnet): the server customers reach, which ends HTTPS (Caddy and Let's Encrypt, a DuckDNS name).
- **App tier** (private subnets in two Availability Zones): two or more app servers behind an internal load balancer with a health check. You may use the kit's CloudNet app (`labs/cloudnet/app/`) as the shop's stand-in.
- **Endpoints** (private): what the app tier needs to install updates and to be reached by Session Manager.

## Paths that must work

- The internet → the web tier on TCP 80 (redirect only) and TCP 443.
- The web tier → the load balancer → the app tier on the app's port.
- The load balancer's health check → each app server.
- The app tier → package updates (through VPC endpoints, not the internet).
- Session Manager → every server.

## Paths that must not work

- The internet → the app tier or the load balancer, on any port.
- The internet → TCP 22 on anything (there is no SSH).
- The web tier → the app servers directly, bypassing the load balancer (prove it).
- The app tier → the internet in general.

## This brief's own rule

**Nothing in a private subnet has a public address or a route to an internet gateway,** and every security-group rule names its source as another security group or a single address, never `0.0.0.0/0`, except the web tier's ports 80 and 443.

## Cost rules

- **No NAT gateway.** It bills by the hour and per GB.
- A load balancer and every public IPv4 address bill by the hour: the network runs for hours, not days. **`tofu destroy` at the end of every working day**, and the budget alarm stays on.
- Put every billed item and its hourly price in your cost estimate.

## Growth

The owner expects ten times the visitors during the Diwali season. Say in your plan what you would change for that month (more app servers, a larger instance type) and what it would cost per day, and make sure the subnets have room for it.
