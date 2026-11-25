# Five broken labs (P2)

Each lab is one small network, written as one self-contained topology file, with one fault planted in it. Each section below is the ticket a user would send you: what they see, nothing more.

Find each fault **from the running lab**, as on a real network: reproduce the symptom, then check from the bottom layer up, one change at a time. Do not hunt for it by reading the topology file; on a real network you would not have one.

You need the `officelab-router` image ([`setup/containerlab.md`](../../setup/containerlab.md)). Run one lab at a time, in the Containerlab terminal, in your copy of this folder:

```bash
containerlab deploy -t lab1.clab.yml --reconfigure
# ... find the fault, fix it in lab1.clab.yml, deploy again with --reconfigure, test ...
containerlab destroy -t lab1.clab.yml --cleanup
```

Every lab has a PC called `pc1` and a server called `srv1`, with a web page on port 80. Containers are named `clab-broken<N>-<node>`, for example `clab-broken3-pc1`. Each lab uses its own address range, so no two labs share addresses.

## Lab 1: the server has gone quiet

> "Since the change last night, `pc1` (10.6.1.10) cannot reach the server `srv1` at 10.6.2.10. `ping` gets no answer at all, not even an error. The server looks fine to the people next to it."

Symptom test: `docker exec clab-broken1-pc1 ping -c 3 10.6.2.10`

## Lab 2: addresses work, names do not

> "My laptop `pc1` gets an address from the office network as usual, and I can open the server by its address, 10.7.2.10. But `http://srv1.branch.internal` says it cannot find the server."

Symptom test: `docker exec clab-broken2-pc1 curl -s -m 5 http://srv1.branch.internal`

## Lab 3: one server unreachable from one office

> "`pc1` (10.8.1.10) cannot ping the server `srv1` (10.8.2.10). The server itself can reach its router. Nothing changed on `pc1`."

Symptom test: `docker exec clab-broken3-pc1 ping -c 3 10.8.2.10`

## Lab 4: ping works, the web page does not

> "From `pc1` (10.9.1.10) I can ping the server `srv1` (10.9.2.10), but the web page on it never loads: the browser just spins until it gives up."

Symptom test: `docker exec clab-broken4-pc1 curl -s -m 5 -o /dev/null -w "%{http_code}\n" http://10.9.2.10`

## Lab 5: the far side of the network is missing

> "We added a second router last week. `pc1` (10.10.1.10) can reach its own router but nothing behind the new router, including `srv1` (10.10.2.10). Both routers say they are running."

Symptom test: `docker exec clab-broken5-pc1 ping -c 3 10.10.2.10`

## Tools you have

On the hosts: `ip`, `ping`, `traceroute`, `nc`, `curl`, `dig`, `tcpdump`, `cat /etc/resolv.conf`.
On the routers: the same, plus `vtysh -c "show ip route"`, `vtysh -c "show ip ospf neighbor"`, `vtysh -c "show ip ospf interface"`, `nft list ruleset` and `ps`.

Capture on both sides of a router (`tcpdump -ni eth1` and `tcpdump -ni eth2`) to see where a packet stops.
