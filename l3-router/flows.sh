#!/bin/sh

# sudo mn  --custom l3.py --topo l3  --controller=none --mac

GW1_MAC="00:00:00:00:01:01"
GW1_HEX="0x0101"
GW1_IP="10.10.10.1"
GW1_IP_HEX="0x0a0a0a01"
GW2_MAC="00:00:00:00:02:01"
GW2_HEX="0x0201"
GW2_IP="10.10.20.1"
GW2_IP_HEX="0x0a0a1401"

# Table ids
GW_ARP=50
HOST_ARP=60
L3_SRC_MAC_REWRITE=20
L3_DST_MAC_REWRITE=25
L2_FORWARD=30

ovs-ofctl del-flows s1

# Avoid ARP flooding
ovs-ofctl add-flow s1 "table=0,priority=100,arp,nw_dst=10.10.10.3,actions=output:1"
ovs-ofctl add-flow s1 "table=0,priority=100,arp,nw_dst=10.10.10.4,actions=output:2"
ovs-ofctl add-flow s1 "table=0,priority=100,arp,nw_dst=10.10.10.13,actions=output:3"
ovs-ofctl add-flow s1 "table=0,priority=100,arp,nw_dst=10.10.10.14,actions=output:4"

# ARP handing for gateway IP addresses
ovs-ofctl add-flow s1 "table=0,priority=1000,arp,nw_dst=$GW1_IP,actions=resubmit(,$GW_ARP)"
ovs-ofctl add-flow s1 "table=0,priority=1000,arp,nw_dst=$GW2_IP,actions=resubmit(,$GW_ARP)"

# L3 forwarding across subnets
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,nw_src=10.10.10.1/24,dl_dst=$GW1_MAC,actions=resubmit(,$L3_SRC_MAC_REWRITE)"
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,nw_src=10.10.20.1/24,dl_dst=$GW2_MAC,actions=resubmit(,$L3_SRC_MAC_REWRITE)"

# L3 forwarding within same subnet
ovs-ofctl add-flow s1 "table=0,priority=500,ip,nw_src=10.10.10.1/24,nw_dst=10.10.10.3,actions=output:1"
ovs-ofctl add-flow s1 "table=0,priority=500,ip,nw_src=10.10.10.1/24,nw_dst=10.10.10.4,actions=output:2"
ovs-ofctl add-flow s1 "table=0,priority=500,ip,nw_src=10.10.20.1/24,nw_dst=10.10.20.13,actions=output:3"
ovs-ofctl add-flow s1 "table=0,priority=500,ip,nw_src=10.10.20.1/24,nw_dst=10.10.20.14,actions=output:4"

# ARP flows for gateway ips 
ovs-ofctl add-flow s1 "table=$GW_ARP,arp,nw_dst=$GW1_IP,actions=load:0x2->NXM_OF_ARP_OP[], move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[], mod_dl_src:$GW1_MAC, move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[], move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[], load:$GW1_HEX->NXM_NX_ARP_SHA[], load:$GW1_IP_HEX->NXM_OF_ARP_SPA[], in_port"
ovs-ofctl add-flow s1 "table=$GW_ARP,arp,nw_dst=$GW2_IP,actions=load:0x2->NXM_OF_ARP_OP[], move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[], mod_dl_src:$GW2_MAC, move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[], move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[], load:$GW2_HEX->NXM_NX_ARP_SHA[], load:$GW2_IP_HEX->NXM_OF_ARP_SPA[], in_port"

# L3 src rewrite 
ovs-ofctl add-flow s1 "table=$L3_SRC_MAC_REWRITE,ip,nw_dst=10.10.10.1/24,actions=mod_dl_src=$GW1_MAC,dec_ttl,resubmit(,$L3_DST_MAC_REWRITE)"
ovs-ofctl add-flow s1 "table=$L3_SRC_MAC_REWRITE,ip,nw_dst=10.10.20.1/24,actions=mod_dl_src=$GW2_MAC,dec_ttl,resubmit(,$L3_DST_MAC_REWRITE)"

# L3 dst rewrite
ovs-ofctl add-flow s1 "table=$L3_DST_MAC_REWRITE,ip,nw_dst=10.10.10.3,actions=mod_dl_dst=00:00:00:00:00:03,resubmit(,$L2_FORWARD)"
ovs-ofctl add-flow s1 "table=$L3_DST_MAC_REWRITE,ip,nw_dst=10.10.10.4,actions=mod_dl_dst=00:00:00:00:00:04,resubmit(,$L2_FORWARD)"
ovs-ofctl add-flow s1 "table=$L3_DST_MAC_REWRITE,ip,nw_dst=10.10.20.13,actions=mod_dl_dst=00:00:00:00:00:13,resubmit(,$L2_FORWARD)"
ovs-ofctl add-flow s1 "table=$L3_DST_MAC_REWRITE,ip,nw_dst=10.10.20.14,actions=mod_dl_dst=00:00:00:00:00:14,resubmit(,$L2_FORWARD)"

# L2 forwarding
ovs-ofctl add-flow s1 "table=$L2_FORWARD,dl_dst=00:00:00:00:00:03,actions=output:1"
ovs-ofctl add-flow s1 "table=$L2_FORWARD,dl_dst=00:00:00:00:00:04,actions=output:2"
ovs-ofctl add-flow s1 "table=$L2_FORWARD,dl_dst=00:00:00:00:00:13,actions=output:3"
ovs-ofctl add-flow s1 "table=$L2_FORWARD,dl_dst=00:00:00:00:00:14,actions=output:4"

