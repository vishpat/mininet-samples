# A L2 switch using Openflow
![L2 topology](https://github.com/vishpat/mininet-samples/raw/master/l2-switch/topo.png)

![L2 switch](https://github.com/vishpat/mininet-samples/raw/master/l2-switch/topo.png)
The above topology was created using the following mininet command

<pre>
sudo mn  --topo single,3  --controller=none --mac
</pre>

The following openflow rules can be added (at the mininet prompt) to get a DUMB version of the switch working

<pre>
sh ovs-ofctl add-flow s1 arp,actions=FLOOD
sh ovs-ofctl add-flow s1 ip,actions=NORMAL
</pre>

The following openflow rules can be added (at the mininet prompt) to get better version of the same switch
<pre>
sh ovs-ofctl add-flow s1 "arp,nw_dst=10.0.0.1,actions=output:1"
sh ovs-ofctl add-flow s1 "arp,nw_dst=10.0.0.2,actions=output:2"
sh ovs-ofctl add-flow s1 "arp,nw_dst=10.0.0.3,actions=output:3"

sh ovs-ofctl add-flow s1 "ip,nw_dst=10.0.0.1,actions=output:1"
sh ovs-ofctl add-flow s1 "ip,nw_dst=10.0.0.2,actions=output:2"
sh ovs-ofctl add-flow s1 "ip,nw_dst=10.0.0.3,actions=output:3"                                                             
</pre>
