#! /bin/sh
#set -e
exit 0
# source function library
. /etc/init.d/functions

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/bin:"

if [ ! -f /var/run/virtlogd.pid ]; then
    virtlogd -d -p /var/run/virtlogd.pid 
fi


case "$1" in
  start)
        echo "Starting Guest OS"
        if [ ! -f /media/disk1.img ]; then
            qemu-img create -f qcow2 /media/disk1.img 35g
        fi
        if [ ! -f /media/disk2.img ]; then
            qemu-img create -f raw /media/disk2.img 40g
        fi
        IDS=`lspci -s 00:02.0 -n | awk '{print $3}'`
        VID=${IDS:0:4}
        PID=${IDS:5:4}
        modprobe tun
        modprobe vhost_net
        modprobe vfio
        modprobe vfio_iommu_type1
        modprobe vfio_pci ids=8086:1916
        modprobe virtio
        if [ -e /sys/bus/pci/devices/0000\:00\:02.0/driver/unbind ]; then
            echo 0000:00:02.0 > /sys/bus/pci/devices/0000\:00\:02.0/driver/unbind
        fi
        echo $VID $PID > /sys/bus/pci/drivers/vfio-pci/new_id
        sleep 3
        str=`/usr/bin/rongan_eeprom | awk '{print $3}'`
        IN_OUT=`echo ${str:0-1}`
        if test `expr $IN_OUT % 2` == 0 ; then
            #virsh list --all | grep guest || virsh define /etc/kvm/guest-vnc.xml
            virsh list --all | grep guest || virsh define /etc/kvm/guest.xml
            /etc/kvm/disk.sh
            virsh start guest
        else
            #virsh list --all | grep guest || virsh define /etc/kvm/guest-vnc.xml
            virsh list --all | grep guest || virsh define /etc/kvm/guest.xml
            /etc/kvm/disk.sh
            virsh start guest
            /etc/kvm/485.sh
        fi
        list=`ls /tmp/usb*.xml`
        for xml in ${list}
        do
            virsh attach-device --file $xml guest
        done
        echo "done."
        ;;
  stop)
        echo "Stopping Guest OS"
        virsh shutdown guest
        virsh undefine guest
        ;;

  restart)
        $0 stop
        $0 start
        ;;

  *)
        echo "Usage: /etc/init.d/guest.sh {start|stop|restart}"
        exit 1
esac

exit 0
