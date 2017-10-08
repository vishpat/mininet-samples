# L3 router using Openflow
![topology](https://github.com/vishpat/mininet-samples/raw/master/l3-router/topo.png)

The above topology was created using mininet (l3-topo.py) using the following command

<pre>
sudo mn  --custom l3-topo.py --topo l3  --controller=none --mac
</pre>

The flows were insert on the OVS bridge using flows.sh 
