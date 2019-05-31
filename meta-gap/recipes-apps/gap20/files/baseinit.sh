#! /bin/sh
#set -e

# source function library
. /etc/init.d/functions


export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/bin:"

which vtysh | xargs -n 1 chmod a+s

mkdir -p /data/log
mkdir -p /home/admin

test -e /lib/modules/3.10.56-rt50+/kernel/net/netfilter/xt_LOG.ko && modprobe xt_LOG

test -e /lib/modules-/gap_kernel.ko && insmod /lib/modules-/gap_kernel.ko

test -e /lib/modules-/fpga.ko && insmod /lib/modules-/fpga.ko

test -f /usr/bin/mysql_install_db || exit 0

if [ ! -d /data/mysql/mysql ]; then
    echo "Starting : Init Mysql prepare"
    /usr/bin/mysql_install_db --user=mysql --datadir=/data/mysql
    mkdir -p /data/db/data && chmod 777 /data/db/data
    mkdir -p /data/db/index && chmod 777 /data/db/index
    echo "done."
fi

str=`/usr/bin/rongan_eeprom | awk '{print $3}'`
IN_OUT=`echo ${str:0-1}`
if test `expr $IN_OUT % 2` == 0 ; then
    echo outer > /var/run/boardtype
    if [ ! -f /usr/bin/iptables_init ]; then
        cp /usr/bin/iptables_init_outer /usr/bin/iptables_init
    fi
	if [ ! -e /etc/gap/zebra.conf ]; then
		cp /etc/gap/zebra_outer.conf /etc/gap/zebra.conf
		cp /etc/gap/zebra.conf /etc/gap/zebra.conf.priv
	fi
	
    /etc/init.d/init-outer.sh start
else
    echo inner > /var/run/boardtype
    if [ ! -f /usr/bin/iptables_init ]; then
        cp /usr/bin/iptables_init_inner /usr/bin/iptables_init
    fi
	if [ ! -e /etc/gap/zebra.conf ]; then
		cp /etc/gap/zebra_inner.conf /etc/gap/zebra.conf
		cp /etc/gap/zebra.conf /etc/gap/zebra.conf.priv
	fi
	
    /etc/init.d/init-inner.sh start
fi

chown -R mysql:mysql /data/mysql

if [ ! -d /data/key_cert ]; then
	mkdir /data/key_cert
fi

if [ ! -e /data/key_cert/gap.crt ]; then
	cp /etc/nginx/key_cert/gap.crt /data/key_cert/gap.crt
fi

if [ ! -e /data/key_cert/gap.key ]; then
	cp /etc/nginx/key_cert/gap.key /data/key_cert/gap.key
fi

if [ ! -e /data/key_cert/ca.crt ]; then
	cp /etc/nginx/key_cert/ca.crt /data/key_cert/ca.crt
fi

if [ ! -d /data/coredump ]; then
	mkdir -p /data/coredump
fi
echo '/data/coredump/core.%e' > /proc/sys/kernel/core_pattern

exit 0
