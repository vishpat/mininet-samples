## Setup

The setup and the openflow rules remain the same as mentioned in the [multi-tenant-vxlan](https://github.com/vishpat/mininet-samples/tree/master/multi-tenant-vxlan) tutorial. The things that change are creation of the vxlan tunnel and addition of IPsec encryption for the Vxlan traffic. In addition the user is also required to install [strongswan](https://www.strongswan.org) on each of the VM.

## Vxlan Tunnel

In order to create an IPSec tunnel between the two VMs, we will be creating a *dummy* interface on each of the VMs and assign it an IP address. The dummy interface IP address will be used to create the Vxlan tunnels as shown below.

### VM1
The eth0 on VM1 has the IP *192.168.122.68* and we will be using the *192.168.123.68* as the dummy interface IP.

<pre>
ip link add ipsec-dummy type dummy
ip link set up ipsec-dummy
ip addr add 192.168.123.68 dev ipsec-dummy
ip route add 192.168.123.212 dev eth0 src 192.168.123.68
ovs-vsctl add-port s1 vxlan-vm2 -- set interface vxlan-vm2 type=vxlan option:remote_ip=192.168.123.212 option:key=flow ofport_request=10
</pre>

### VM2
The eth0 on VM1 has the IP *192.168.122.212* and we will be using the *192.168.123.212* as the dummy interface IP.

<pre>
ip link add ipsec-dummy type dummy
ip link set up ipsec-dummy
ip addr add 192.168.123.212 dev ipsec-dummy
ip route add 192.168.123.68 dev eth0 src 192.168.123.212
ovs-vsctl add-port s1 vxlan-vm2 -- set interface vxlan-vm2 type=vxlan option:remote_ip=192.168.123.212 option:key=flow ofport_request=10
</pre>

The vxlan endpoints are the dummy interface IP addresses instead of the eth0 IP addresses. At this point on the flows are added the traffic should be able to flow across different namespaces.  

## IPSec Encryption
IPSec encryption using *static* keys can be enabled by running the ipsec\_enable.sh as follows

<pre>
./ipsec_enable.sh 192.168.122.68 192.168.122.212 192.168.123.68 192.168.123.212 
</pre>
