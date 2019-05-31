#!/bin/sh
#set -e

# source function library
. /etc/init.d/functions


export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/bin:"

case "$1" in
  start)
	#modprobe bonding mode=2 xmit_hash_policy=1
	modprobe bonding
	ifconfig bond0 192.168.0.3 mtu 1500
	echo +gap > /sys/class/net/bond0/bonding/slaves
	#if [ -d /sys/class/net/pci0 ]; then
	#    echo +pci0 > /sys/class/net/bond0/bonding/slaves
	#    echo +pci1 > /sys/class/net/bond0/bonding/slaves
	#    echo +pci2 > /sys/class/net/bond0/bonding/slaves
	#    echo +pci3 > /sys/class/net/bond0/bonding/slaves

	if [ -d /etc/init.d/outer ]; then
        for s in /etc/init.d/outer/*; do
            $s start
        done
    fi
    #if [ -e /etc/outer_ntpdate ]; then
    #    mv /etc/outer_ntpdate /etc/default/ntpdate
    #fi
	#echo "server 192.168.0.2" > /etc/ntp.conf
	#ntpd -d
	;;
  stop)
	if [ -d /etc/init.d/outer ]; then
            for s in /etc/init.d/outer/*; do
                $s stop
            done
    fi
	ifconfig bond0 down	
	rmmod bonding
	;;

  restart)
	$0 stop
	$0 start
	;;

  *)
	exit 1
esac

exit 0
