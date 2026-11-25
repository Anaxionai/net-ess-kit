# Try it in the browser

Free sites where you practise a new idea before you use it in your own lab. None of them needs an account.
Use them to check your own working, never instead of it: a concept check, a gate or an Explain-it answer is yours alone.

## Addresses and subnets

| Site | What you do there | When |
|---|---|---|
| [Subnet calculator (subnet-calculator.com/cidr.php)](https://www.subnet-calculator.com/cidr.php) | Type an address and a prefix such as `10.1.10.0/24`; it shows the mask, the first and last usable address, the broadcast address and the number of hosts | LP day 3, P1 subnetting, every address plan |
| [IP address calculator (jodies.de/ipcalc)](https://jodies.de/ipcalc) | The same, in binary: see exactly which bits are network and which are host | P1 subnetting |

How to practise: work the answer out on paper first, then check it here. If they differ, find the bit you got wrong.

## DNS

| Site | What you do there | When |
|---|---|---|
| [IANA root zone database (iana.org/domains/root/db)](https://www.iana.org/domains/root/db) | Every top-level domain (`.com`, `.in`, `.org` …) and who runs it. Open `.in` to see its name servers | P1 DNS in depth |
| [IANA's list of root servers (iana.org/domains/root/servers)](https://www.iana.org/domains/root/servers) | The 13 root server names, `a.root-servers.net` to `m.root-servers.net`, with their addresses and the organisation that runs each one | P1 DNS in depth |
| [The root servers map (root-servers.org)](https://root-servers.org) | Where the copies of each root server are in the world. Find the ones in India | P1 DNS in depth |
| [Google Public DNS lookup (dns.google)](https://dns.google) | Look up any record type (`A`, `AAAA`, `MX`, `NS`, `TXT`) from a public resolver, to compare with your own `dig` | P1 DNS, P3 DNS for a real site |

## Packets

| Site | What you do there | When |
|---|---|---|
| [Wireshark sample captures (wiki.wireshark.org/SampleCaptures)](https://wiki.wireshark.org/SampleCaptures) | Download a small capture and open it in Wireshark on your laptop. Start with **`http.cap`** (a web page fetched over plain HTTP: the TCP handshake, the GET request and the answer), then try a `dns` sample. Practise filters such as `dns`, `tcp.flags.reset == 1` and `http` on someone else's traffic | LP day 4, P1 reading a capture |
| [Wireshark display filter reference (wireshark.org/docs/dfref)](https://www.wireshark.org/docs/dfref/) | Every field you can filter on, by protocol | P1 reading a capture |

Captures from the sample page were made by other people for teaching. Your own captures are only ever of your own traffic and your own lab.

## Diagrams

| Site | What you do there | When |
|---|---|---|
| [Mermaid Live Editor (mermaid.live)](https://mermaid.live) | Type a Mermaid diagram on the left and see it drawn on the right. Paste the finished text into a Markdown file between ` ```mermaid ` and ` ``` `, and GitHub draws it | LP day 5, every project's diagram, the capstone plan |

A first diagram to paste in:

```text
flowchart LR
    laptop["My laptop<br/>192.168.1.23"] --> router["Home router<br/>192.168.1.1"]
    router --> isp["Internet provider"]
    isp --> server["example.com"]
```

## Cloud costs

| Site | What you do there | When |
|---|---|---|
| [AWS Pricing Calculator (calculator.aws)](https://calculator.aws) | Build an estimate: choose the region **Asia Pacific (Mumbai)**, add an EC2 instance, an Application Load Balancer and a public IPv4 address, and read the monthly cost. Then add a NAT gateway and see why the course does not use one | P3 what costs money, the capstone cost estimate |

The calculator needs no account. Save your estimate's link, or write the figures into your plan with the date you read them.
