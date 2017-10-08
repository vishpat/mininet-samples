# Multi tenant VxLAN

![topology](https://github.com/vishpat/mininet-samples/raw/master/multi-tenant-vxlan/vxlan.png)

The above topology will require two mininet VMs on the same subnet. On each mininet VM run the following command to create the hosts and OVS bridge.

<pre>
sudo mn  --topo single,4  --controller=none --mac
</pre>


