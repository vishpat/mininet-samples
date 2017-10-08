# A simple L2 switch using Openflow

![L2 switch](https://github.com/vishpat/mininet-samples/raw/master/l2-switch/topo.png)
The above topology was created using the following mininet command

<pre>
sudo mn  --topo single,3  --controller=none --mac
</pre>

The following openflow rules can be added (at the mininet prompt) to get this switch working

<pre>
sh ovs-ofctl add-flow s1 arp,actions=FLOOD
sh ovs-ofctl add-flow s1 ip,actions=NORMAL
</pre>
