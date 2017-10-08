# L3 router using Openflow
![topology](https://github.com/vishpat/mininet-samples/raw/master/l3-router/topo.png)

The above topology was created using mininet (l3-topo.py) using the following command

<pre>
sudo mn  --custom l3-topo.py --topo l3  --controller=none --mac
</pre>

The flows were added to the OVS bridge using flows.sh 

**NOTE**: The mininet VM comes with an old version of OpenVswitch which does not support the flows for ARP replies. To get over this problem, install OVS version 2.6. The instructions to upgrade the OVS on the mininet VM can be found [here.](
https://github.com/mininet/mininet/wiki/Installing-new-version-of-Open-vSwitch)
