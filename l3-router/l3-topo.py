i#!/usr/bin/python

from mininet.topo import Topo

class L3TestTopo( Topo ):

    """L3 test topology."""

    def __init__( self ):
        """Create custom topo."""

        # Initialize topology
        Topo.__init__( self )

        # Add hosts and switches
        h1 = self.addHost('h1',
                          ip="10.10.10.3/24",
                          mac="00:00:00:00:00:03",
                          defaultRoute="dev h1-eth0 via 10.10.10.1")

        h2 = self.addHost('h2',
                          ip="10.10.10.4/24",
                          mac="00:00:00:00:00:04",
                          defaultRoute="dev h2-eth0 via 10.10.10.1")

        h3 = self.addHost('h3',
                          ip="10.10.20.13/24",
                          mac="00:00:00:00:00:13",
                          defaultRoute="dev h3-eth0 via 10.10.20.1")

        h4 = self.addHost('h4',
                          ip="10.10.20.14/24",
                          mac="00:00:00:00:00:14",
                          defaultRoute="dev h4-eth0 via 10.10.20.1")

        s1 = self.addSwitch('s1')

        # Add links
        self.addLink( s1, h1 )
        self.addLink( s1, h2 )
        self.addLink( s1, h3 )
        self.addLink( s1, h4 )

topos = {'l3': ( lambda: L3TestTopo() )}

