# Multi tenant VxLAN

![topology](https://github.com/vishpat/mininet-samples/raw/master/multi-tenant-vxlan/vxlan.png)

The above topology will require two mininet VMs on the same subnet. On each of the mininet VMs run the following command to create the hosts and OVS bridge.

<pre>
sudo mn  --topo single,4  --controller=none --mac
</pre>

Create a vxlan tunnel between the bridges running the following commands on each VM

<pre>

// VM1 (eth0 ip address : 192.168.122.88)
sudo ovs-vsctl add-port s1 vxlan-vm2 -- set interface vxlan-vm2 type=vxlan option:remote_ip=192.168.122.68 option:key=flow ofport_request=10


// VM2 (eth0 ip address : 192.168.122.66)
sudo ovs-vsctl add-port s1 vxlan-vm1 -- set interface vxlan-vm1 type=vxlan option:remote_ip=192.168.122.88 option:key=flow ofport_request=10
</pre>

Add the following flows on VM1

<pre>
ovs-ofctl del-flows s1

# ARP handling for VNI 100
ovs-ofctl add-flow s1 "table=0,arp,in_port=1,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,arp,in_port=2,nw_dst=10.0.0.1,actions=output:1"

ovs-ofctl add-flow s1 "table=0,arp,in_port=1,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,arp,in_port=2,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=100,nw_dst=10.0.0.1,actions=output:1"
ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=100,nw_dst=10.0.0.2,actions=output:2"

# IP handling for VNI 100
ovs-ofctl add-flow s1 "table=0,ip,in_port=1,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,ip,in_port=2,nw_dst=10.0.0.1,actions=output:1"

ovs-ofctl add-flow s1 "table=0,ip,in_port=1,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,ip,in_port=2,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=100,nw_dst=10.0.0.1,actions=output:1"
ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=100,nw_dst=10.0.0.2,actions=output:2"

# ARP handling for VNI 200
ovs-ofctl add-flow s1 "table=0,arp,in_port=3,nw_dst=10.0.0.4,actions=output:4"
ovs-ofctl add-flow s1 "table=0,arp,in_port=4,nw_dst=10.0.0.3,actions=output:3"

ovs-ofctl add-flow s1 "table=0,arp,in_port=3,nw_dst=10.0.0.3/24,actions=set_field:200->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,arp,in_port=4,nw_dst=10.0.0.3/24,actions=set_field:200->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=200,nw_dst=10.0.0.3,actions=output:3"
ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=200,nw_dst=10.0.0.4,actions=output:4"

# IP handling for VNI 200
ovs-ofctl add-flow s1 "table=0,ip,in_port=3,nw_dst=10.0.0.4,actions=output:4"
ovs-ofctl add-flow s1 "table=0,ip,in_port=4,nw_dst=10.0.0.3,actions=output:3"

ovs-ofctl add-flow s1 "table=0,ip,in_port=3,nw_dst=10.0.0.3/24,actions=set_field:200->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,ip,in_port=4,nw_dst=10.0.0.3/24,actions=set_field:200->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=200,nw_dst=10.0.0.3,actions=output:3"
ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=200,nw_dst=10.0.0.4,actions=output:4"

</pre>

Add the following flows on VM2

<pre>
ovs-ofctl del-flows s1

# ARP handling for VNI 100
ovs-ofctl add-flow s1 "table=0,arp,in_port=3,nw_dst=10.0.0.4,actions=output:4"
ovs-ofctl add-flow s1 "table=0,arp,in_port=4,nw_dst=10.0.0.3,actions=output:3"

ovs-ofctl add-flow s1 "table=0,arp,in_port=3,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,arp,in_port=4,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=100,nw_dst=10.0.0.3,actions=output:3"
ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=100,nw_dst=10.0.0.4,actions=output:4"

# IP handling for VNI 100
ovs-ofctl add-flow s1 "table=0,ip,in_port=3,nw_dst=10.0.0.4,actions=output:4"
ovs-ofctl add-flow s1 "table=0,ip,in_port=4,nw_dst=10.0.0.3,actions=output:3"

ovs-ofctl add-flow s1 "table=0,ip,in_port=3,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,ip,in_port=4,nw_dst=10.0.0.1/24,actions=set_field:100->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=100,nw_dst=10.0.0.3,actions=output:3"
ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=100,nw_dst=10.0.0.4,actions=output:4"

# ARP handling for VNI 200
ovs-ofctl add-flow s1 "table=0,arp,in_port=1,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,arp,in_port=2,nw_dst=10.0.0.1,actions=output:1"

ovs-ofctl add-flow s1 "table=0,arp,in_port=1,nw_dst=10.0.0.1/24,actions=set_field:200->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,arp,in_port=2,nw_dst=10.0.0.1/24,actions=set_field:200->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=200,nw_dst=10.0.0.1,actions=output:1"
ovs-ofctl add-flow s1 "table=0,arp,in_port=10,tun_id=200,nw_dst=10.0.0.2,actions=output:2"

# IP handling for VNI 200
ovs-ofctl add-flow s1 "table=0,ip,in_port=1,nw_dst=10.0.0.2,actions=output:2"
ovs-ofctl add-flow s1 "table=0,ip,in_port=2,nw_dst=10.0.0.1,actions=output:1"

ovs-ofctl add-flow s1 "table=0,ip,in_port=1,nw_dst=10.0.0.1/24,actions=set_field:200->tun_id,output:10"
ovs-ofctl add-flow s1 "table=0,ip,in_port=2,nw_dst=10.0.0.1/24,actions=set_field:200->tun_id,output:10"

ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=200,nw_dst=10.0.0.1,actions=output:1"
ovs-ofctl add-flow s1 "table=0,ip,in_port=10,tun_id=200,nw_dst=10.0.0.2,actions=output:2"

</pre>

