# Brief: Greenleaf Clinic, two sites joined by a VPN

**Suggested route: Lab** (containerlab, as in P2 OfficeLab). Greenleaf Clinic is a training brief, not a real clinic.

## The need

Greenleaf Clinic runs a main site with a doctor's floor, a reception desk and a small server room. Last year it opened a branch across town with two consulting rooms and a reception desk. Today the branch emails scanned files to the main site, and patient records sit on a laptop. The clinic wants one network: the branch reaches the records server at the main site over the internet, safely; patients in either waiting room get free Wi-Fi that can never see clinical systems.

## Users

| Group | Site | Devices now | In two years | What they must reach |
|---|---|---|---|---|
| Doctors and nurses | Main | 8 | 14 | The records server (HTTPS), the internet |
| Reception | Main | 3 | 4 | The records server (HTTPS, appointments only), the printer, the internet |
| Doctors and nurses | Branch | 4 | 10 | The records server at the main site, over the VPN |
| Reception | Branch | 2 | 3 | The records server over the VPN, the internet |
| Patients (Wi-Fi) | Both waiting rooms | up to 30 at once per site | 50 per site | The internet only |
| IT (one part-time person) | Main | 1 laptop | 1 | SSH to the routers and the server |

## Zones

- **Main site:** clinical staff, reception, patient Wi-Fi, servers (the records server `records`, a file server).
- **Branch:** clinical staff, reception, patient Wi-Fi (a smaller copy of the main site, with no servers).
- **The VPN** between the two edge routers (WireGuard), and **the internet** on each edge.

## Paths that must work

- Clinical staff at both sites → `records` on TCP 443.
- Reception at both sites → `records` on TCP 443.
- Branch staff reach `records` **only through the VPN**, never across the internet in the clear.
- Every zone except servers → the internet (through NAT on its site's edge).
- IT laptop → SSH (TCP 22) to every router and to `records`.
- Patients get addresses by DHCP and a working DNS name lookup.

## Paths that must not work

- Patient Wi-Fi → anything inside the clinic, at either site, on any port, including the routers' own addresses (except DHCP and DNS from their gateway).
- The internet → anything inside, except the WireGuard port on each edge.
- Reception → SSH anywhere.
- The branch → the main site's file server.

## This brief's own rule

**Patient data never leaves the VPN unencrypted:** traffic between a branch zone and the main site's server zone flows only through `wg0`. A capture on the edges' internet link shows only UDP to the WireGuard port.

## Things to decide in your plan

- One subnet per zone per site, with room for the two-year numbers, and a spare block for a third site.
- Whether the routing between sites is static or OSPF over the tunnel, and why.
- Where each Block row is enforced: on the zone router, the edge, or both.

## Growth

The clinic plans a third site within three years, of the branch's size. Your address plan and your VPN design should make adding it a change of a few lines, not a rebuild. Say in the plan how.
