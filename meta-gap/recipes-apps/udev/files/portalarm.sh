#!/bin/sh

touch /tmp/eth_port_state
echo `date` ${port}:${state} $1 >> /tmp/eth_port_state
#only for HA link up change to down
if [ x"${state}" = x"down" ] ; then
    match=`cat /etc/gap/businessinif.conf | grep ${port}`
    if [ -n "$match" ]; then
        echo `date` "match rules & apply it." >> /tmp/eth_port_state
        python /lib64/udev/hatakeover.py
        echo `date` "apply it done." >> /tmp/eth_port_state
    fi
else
    echo `date` "port ${port} skip aplly it" >> /tmp/eth_port_state
fi
