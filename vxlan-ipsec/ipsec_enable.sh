#!/bin/bash

#
# This script is a modified version of the script found at
# https://gist.github.com/vishvananda/7094676
# The only difference being, this script uses dummy interfaces
# instead of the loopback

set -x
if [ "$5" == "" ]; then
    echo "usage: $0 <local_ip> <remote_ip> <new_local_ip> <new_remote_ip> <remote-ssh-ip>"
    echo "creates an ipsec tunnel between two machines"
    exit 1
fi

PRIMARY_INTF="eth0"
SRC="$1"; shift
DST="$1"; shift
LOCAL="$1"; shift
REMOTE="$1"; shift

KEY1=0x`dd if=/dev/urandom count=32 bs=1 2> /dev/null| xxd -p -c 64`
KEY2=0x`dd if=/dev/urandom count=32 bs=1 2> /dev/null| xxd -p -c 64`
ID=0x`dd if=/dev/urandom count=4 bs=1 2> /dev/null| xxd -p -c 8`

sudo ip xfrm policy flush
sudo ip xfrm state flush
sudo ip xfrm state add src $SRC dst $DST proto esp spi $ID reqid $ID mode tunnel auth sha256 $KEY1 enc aes $KEY2
sudo ip xfrm state add src $DST dst $SRC proto esp spi $ID reqid $ID mode tunnel auth sha256 $KEY1 enc aes $KEY2
sudo ip xfrm policy add src $LOCAL dst $REMOTE dir out tmpl src $SRC dst $DST proto esp reqid $ID mode tunnel
sudo ip xfrm policy add src $REMOTE dst $LOCAL dir in tmpl src $DST dst $SRC proto esp reqid $ID mode tunnel
sudo ip addr flush dev ipsec-dummy
sudo ip addr add $LOCAL dev ipsec-dummy
sudo ip route add $REMOTE dev $PRIMARY_INTF src $LOCAL


ssh $REMOTE /bin/bash << EOF
    sudo ip xfrm policy flush
    sudo ip xfrm state flush
    sudo ip xfrm state add src $SRC dst $DST proto esp spi $ID reqid $ID mode tunnel auth sha256 $KEY1 enc aes $KEY2
    sudo ip xfrm state add src $DST dst $SRC proto esp spi $ID reqid $ID mode tunnel auth sha256 $KEY1 enc aes $KEY2
    sudo ip xfrm policy add src $REMOTE dst $LOCAL dir out tmpl src $DST dst $SRC proto esp reqid $ID mode tunnel
    sudo ip xfrm policy add src $LOCAL dst $REMOTE dir in tmpl src $SRC dst $DST proto esp reqid $ID mode tunnel
    sudo ip addr flush dev ipsec-dummy
    sudo ip addr add $REMOTE dev ipsec-dummy
    sudo ip route add $LOCAL dev $PRIMARY_INTF src $REMOTE
EOF
