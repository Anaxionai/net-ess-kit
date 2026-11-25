# officelab-router: the FRR router image for every OfficeLab and broken lab.
# It is FRR's containerlab image plus the Linux tools the labs need:
# nftables (NAT and firewalls), dnsmasq (DHCP and local DNS), WireGuard, bash, tcpdump and dig.
#
# Build it once, in the Containerlab terminal:
#   docker build -t officelab-router ~/net-ess-kit/labs/officelab/router-image
FROM quay.io/frrouting/frr:containerlab-10.7.1

RUN apk add --no-cache nftables dnsmasq wireguard-tools bash tcpdump bind-tools
