#! /bin/sh
#set -e

# source function library
. /etc/init.d/functions

remove_rpm(){
	boardtype=`cat /var/run/boardtype`
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/bin:"

case "$1" in
  start)
	#modprobe bonding mode=2 xmit_hash_policy=1
	modprobe bonding
	ifconfig bond0 192.168.0.2 mtu 1500
	echo +gap > /sys/class/net/bond0/bonding/slaves
	#if [ -d /sys/class/net/pci0 ]; then
	#    echo +pci0 > /sys/class/net/bond0/bonding/slaves
	#    echo +pci1 > /sys/class/net/bond0/bonding/slaves
	#    echo +pci2 > /sys/class/net/bond0/bonding/slaves
	#    echo +pci3 > /sys/class/net/bond0/bonding/slaves
	#fi

	udpsvd -vE 0.0.0.0 69 tftpd -c /tmp &
	if [ -d /etc/init.d/inner ]; then
            for s in /etc/init.d/inner/*; do
                $s start
            done
    fi
	#touch /etc/ntp.conf
	#ntpd -l -I bond0
	;;
  stop)
	if [ -d /etc/init.d/inner ]; then
            for s in /etc/init.d/inner/*; do
                $s stop
            done
    fi
	pidof udpsvd && kill -9 `pidof udpsvd`
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
