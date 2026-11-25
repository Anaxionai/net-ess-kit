# Brief: Brightpath Skills Centre, staff, guests and servers

**Suggested route: Lab** (containerlab, as in P2 OfficeLab). Brightpath Skills Centre is a training brief, not a real centre.

## The need

Brightpath Skills Centre trains about 60 learners a day in two classrooms. Staff, learners and visiting parents all share one flat Wi-Fi network today, so any learner's laptop can open the staff file share and the attendance server. Last month someone's laptop filled the network with traffic during an exam. The centre wants separate zones, each with only the access it needs, and a guest network that is good for the internet and nothing else.

## Users

| Group | Devices now | In two years | What they must reach |
|---|---|---|---|
| Staff (trainers and the office) | 10 laptops, 2 printers | 18 laptops, 3 printers | The attendance server (HTTPS), the file server (SMB, TCP 445), the printers, the internet |
| Classroom PCs | 40 (two rooms of 20) | 80 (four rooms of 20) | The attendance server (HTTPS) for sign-in, the internet |
| Guests (learners' phones, parents) | up to 80 at once | up to 150 at once | The internet only |
| Servers | 2 (attendance, files) | 3 | Updates from the internet |
| The IT trainer | 1 laptop (in the staff zone) | 1 | SSH to the router and the servers |

## Zones

- **Staff**, **Classrooms** (one zone for now, ready to split per room), **Guests**, **Servers**.
- One router or firewall between the zones, an edge with NAT to the internet, and dnsmasq handing out addresses and the local names (`attendance.brightpath.internal`, `files.brightpath.internal`).

## Paths that must work

- Staff → attendance (TCP 443) and files (TCP 445), the printers, the internet.
- Classrooms → attendance (TCP 443) and the internet.
- Guests → the internet (TCP 80 and 443, and DNS), with addresses from DHCP.
- Servers → the internet for updates.
- IT trainer's laptop → SSH (TCP 22) to the router and both servers.

## Paths that must not work

- Guests → any inside zone, including the router's own addresses (except DHCP and DNS from their gateway).
- Classrooms → files (TCP 445), the printers, or the staff zone.
- Anyone except the IT trainer → SSH anywhere.
- Nothing from the internet starts a connection inside.

## This brief's own rule

**Guests are internet-only:** from the guest zone, no address inside the centre answers on any port, except DHCP and DNS on the guest gateway. Your tests prove it for every inside zone.

## Things to decide in your plan

- One subnet per zone, sized for the two-year numbers, and how the classroom zone splits into four rooms later without renumbering.
- Fixed addresses for the servers and printers, DHCP ranges for the rest.
- Where you enforce each Block row, and why you chose `drop` or `reject` for each.

## Growth

Two more classrooms in two years, and the centre may open its Wi-Fi to a neighbouring college for evening classes as a second guest network. Show in the address plan where both would go.
