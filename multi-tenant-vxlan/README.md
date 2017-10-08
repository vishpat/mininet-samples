# Multi tenant VxLAN

![topology](https://github.com/vishpat/mininet-samples/raw/master/multi-tenant-vxlan/vxlan.png)

The above topology will require two mininet VMs on the same subnet. On each of the mininet VMs run the following command to create the hosts and OVS bridge.

<pre>
sudo mn  --topo single,4  --controller=none --mac
</pre>

Create two vxlan tunnels between the bridges running the following commands on each VM

<pre>

// VM1 (ip address : 192.188.122.88)

sudo ovs-vsctl add-port s1 vxlan-vni100 -- set interface vxlan-vni100 type=vxlan option:remote_ip=192.168.122.68 option:key=100 ofport_request=100
sudo ovs-vsctl add-port s2 vxlan-vni200 -- set interface vxlan-vni200 type=vxlan option:remote_ip=192.168.122.68 option:key=200 ofport_request=200



// VM2 (ip address : 192.188.122.66)

sudo ovs-vsctl add-port s1 vxlan-vni100 -- set interface vxlan-vni100 type=vxlan option:remote_ip=192.188.122.88 option:key=100 ofport_request=100
sudo ovs-vsctl add-port s1 vxlan-vni200 -- set interface vxlan-vni200 type=vxlan option:remote_ip=192.188.122.88 option:key=200 ofport_request=200
</pre>

Add the following flows on VM1

<pre>
ovs-ofctl del-flows s1

# ARP handling for VNI 100
ovs-ofctl add-flow s1 "table=0,arp,in_port=1,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,arp,in_port=1,nw_dst=10.0.0.1/24,actions=output:100"
ovs-ofctl add-flow s1 "table=0,arp,nw_dst=10.0.0.1,actions=output:1"

ovs-ofctl add-flow s1 "table=0,arp,in_port=2,actions=output:1,100"
ovs-ofctl add-flow s1 "table=0,arp,nw_dst=10.0.0.2,actions=output:2"

# IP handling for VNI 100
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=100,nw_dst=10.0.0.1,actions=output:1"
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=2,nw_dst=10.0.0.1,actions=output:1"
ovs-ofctl add-flow s1 "table=0,priority=900,ip,in_port=1,nw_dst=10.0.0.1/24,actions=output:100"

ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=100,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=1,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,priority=900,ip,in_port=2,nw_dst=10.0.0.1/24,actions=output:100"

# ARP handling for VNI 200
ovs-ofctl add-flow s1 "table=0,arp,in_port=3,actions=output:4,200"
ovs-ofctl add-flow s1 "table=0,arp,nw_dst=10.0.0.3,actions=output:3"

ovs-ofctl add-flow s1 "table=0,arp,in_port=4,actions=output:3,200"
ovs-ofctl add-flow s1 "table=0,arp,nw_dst=10.0.0.4,actions=output:4"

# IP handling for VNI 200
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=200,nw_dst=10.0.0.3,actions=output:3"
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=4,nw_dst=10.0.0.3,actions=output:3"
ovs-ofctl add-flow s1 "table=0,priority=900,ip,in_port=3,nw_dst=10.0.0.1/24,actions=output:200"

ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=200,nw_dst=10.0.0.4,actions=output:4"
ovs-ofctl add-flow s1 "table=0,priority=1000,ip,in_port=3,nw_dst=10.0.0.4,actions=output:4"
ovs-ofctl add-flow s1 "table=0,priority=900,ip,in_port=4,nw_dst=10.0.0.1/24,actions=output:200"

</pre>

Add the following flows on VM2

<pre>

</pre>

