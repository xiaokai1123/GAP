#!/bin/sh

case "$1" in
    start)
	    echo MGMT > /sys/class/net/agl0/ifalias
	    echo HA > /sys/class/net/eth0/ifalias
	    echo P0 > /sys/class/net/eth1/ifalias
	    echo P1 > /sys/class/net/eth2/ifalias
	    echo P2 > /sys/class/net/eth3/ifalias
	    echo P3 > /sys/class/net/eth4/ifalias
	    
	    if [ -e /sys/class/net/bonding_masters ]; then
		echo +agg0 > /sys/class/net/bonding_masters
		echo +agg1 > /sys/class/net/bonding_masters
		echo +agg2 > /sys/class/net/bonding_masters
		echo +agg3 > /sys/class/net/bonding_masters
		echo 4 >  /sys/class/net/agg0/bonding/mode
		echo 4 >  /sys/class/net/agg1/bonding/mode
		echo 4 >  /sys/class/net/agg2/bonding/mode
		echo 4 >  /sys/class/net/agg3/bonding/mode
		echo AGG0 > /sys/class/net/agg0/ifalias
		echo AGG1 > /sys/class/net/agg1/ifalias
		echo AGG2 > /sys/class/net/agg2/ifalias
		echo AGG3 > /sys/class/net/agg3/ifalias
    	    fi
    ;;
    stop)
	    if [ -e /sys/class/net/bonding_masters ]; then
		echo -agg0 > /sys/class/net/bonding_masters
		echo -agg1 > /sys/class/net/bonding_masters
		echo -agg2 > /sys/class/net/bonding_masters
		echo -agg3 > /sys/class/net/bonding_masters
	    fi
    ;;
esac
