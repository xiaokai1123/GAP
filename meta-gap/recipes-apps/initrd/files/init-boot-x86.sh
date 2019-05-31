#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

ROOT_MOUNT="/mnt"

# Copied from initramfs-framework. The core of this script probably should be
# turned into initramfs-framework modules to reduce duplication.
udev_daemon() {
	OPTIONS="/sbin/udev/udevd /sbin/udevd /lib/udev/udevd /lib/systemd/systemd-udevd"

	for o in $OPTIONS; do
		if [ -x "$o" ]; then
			echo $o
			return 0
		fi
	done

	return 1
}

_UDEV_DAEMON=`udev_daemon`

boot_live_root() {
    fsck.vfat -y /dev/sda1
    fsck.ext4 -y /dev/sda2
    fsck.ext4 -y /dev/sda3
    fsck.ext4 -y /dev/sda4

    mkdir -p /tmp/update
    if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda2 /tmp/update ; then
        fatal "Could not mount update partition"
    fi

    if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda3 $ROOT_MOUNT ; then
        mkfs.ext4 -F /dev/sda3
        mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda3 $ROOT_MOUNT
    fi

    if [ ! -f /tmp/update/tar_ok -a -f "/tmp/update/GAP-X86.rootfs.tar.gz" ]; then
        umount $ROOT_MOUNT
        echo "Format rootfs partition..."
        mkfs.ext4 -F /dev/sda3
        if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda3 $ROOT_MOUNT ; then
            fatal "Could not mount rootfs partition"
        fi
        echo "Please wait!Upgrade system..."
        tar -xf /tmp/update/GAP-X86.rootfs.tar.gz -C ${ROOT_MOUNT} > /dev/null 2>&1
        if [ -f ${ROOT_MOUNT}/lib/modules-/modules.tar.gz ]; then
            tar -xf ${ROOT_MOUNT}/lib/modules-/modules.tar.gz -C ${ROOT_MOUNT} > /dev/null 2>&1
            rm -f ${ROOT_MOUNT}/lib/modules-/modules.tar.gz
        fi
        if [ -f ${ROOT_MOUNT}/lib/modules-/smsc9500.ko ]; then
            cp ${ROOT_MOUNT}/lib/modules-/smsc9500.ko ${ROOT_MOUNT}/lib/modules/`uname -r`/kernel/drivers/net/ethernet/
        fi
        if [ -f ${ROOT_MOUNT}/lib/modules-/smscusbnet.ko ]; then
            cp ${ROOT_MOUNT}/lib/modules-/smscusbnet.ko ${ROOT_MOUNT}/lib/modules/`uname -r`/kernel/drivers/net/ethernet/
        fi
		
		if [ -f "/tmp/update/Configfile_backup.tar.gz" ]; then
			tar -xf /tmp/update/Configfile_backup.tar.gz -C ${ROOT_MOUNT} > /dev/null 2>&1
		fi
		
        mv /tmp/update/GAP-X86.rootfs.tar.gz /tmp/update/.old.rootfs.tar.gz
        sync
        touch /tmp/update/tar_ok
        echo "Done."
    else
        if [ -f /tmp/update/tar_ok ]; then
            rm /tmp/update/tar_ok
        fi
    fi
    umount /tmp/update

    # Move the mount points of some filesystems over to
    # the corresponding directories under the real root filesystem.
    mount -n --move /proc ${ROOT_MOUNT}/proc
    mount -n --move /sys ${ROOT_MOUNT}/sys
    mount -n --move /dev ${ROOT_MOUNT}/dev

    cd $ROOT_MOUNT

    # busybox switch_root supports -c option
    exec switch_root -c /dev/console $ROOT_MOUNT /sbin/init $CMDLINE ||
        fatal "Couldn't switch_root, dropping to shell"
}

install_live_root() {
    echo "Configure Board SN..."
    # Get user input
    #while false; do
    while true; do
        if read -t 120 -p "Please input SN: " sn_input ; then
            if [ -n "$sn_input" ]; then
                sn_sample=$sn_input
                lenth=`expr length $sn_sample`
                if [ "$lenth" -ne "16" ]; then
                    echo "SN is invalid."
                    continue
                fi
                sn_head=${sn_sample:0:6}
                if [ $sn_head = "RSG010" -o $sn_head = "RSG020" -o $sn_head = "RSG030" -o $sn_head = "RSG040" ]; then
                    echo "SN is valid."
                    #set to eeprom
                    lspci -n | grep "8086:1533" > /dev/null 2>&1
                    if [ $? != 0 ]; then
                        echo "Not found valid eeprom." 
                    else
                        MAGIC=0x15338086
                        offset=0x03f0
                    fi
                    sn_interface="eth3"
                    sn_write=${sn_sample}
                    sn_len=$((${#sn_write}-1))
                    for i in $(seq 0 ${sn_len})
                    do
                        # convert ascii to hex data
                        value=${sn_write:i:1}
                        sn_hex=`printf "0x%x" "'${value}"`
                        hex_value=`printf "%s" $sn_hex`
                        echo "value: ${value}, ascii: $hex_value"
                        # first offset is 0x0ff0 , self increate offset every value
                        ethtool -E ${sn_interface} magic ${MAGIC} offset $offset length 1 value $hex_value > /dev/null 2>&1
                        offset=$(($offset+1))
                    done
                    if read -t 120 -p "Please input MAC: " mac_input ; then
                        if [ -n "$mac_input" ]; then
                            mac_sample=$mac_input
                            mac_lenth=`expr length $mac_sample`
                            if [ "$mac_lenth" -ne "15" ]; then
                                echo "MAC is invalid.Example: MAC001122334455"
                                continue
                            fi
                            offset=0x04e0
                            mac_interface="eth3"
                            mac_write=${mac_sample}
                            mac_len=$((${#mac_write}-1))
                            for i in $(seq 0 ${mac_len})
                            do
                                # convert ascii to hex data
                                value=${mac_write:i:1}
                                mac_hex=`printf "0x%x" "'${value}"`
                                hex_value=`printf "%s" $mac_hex`
                                echo "value: ${value}, ascii: $hex_value"
                                ethtool -E ${mac_interface} magic ${MAGIC} offset $offset length 1 value $hex_value > /dev/null 2>&1
                                offset=$(($offset+1))
                            done
                        else
                            continue
                        fi
                    else
                            echo "Input MAC timeout 120s.Reboot now"
                            reboot -f
                    fi
                    break
                fi
            else
                continue
            fi
        else
                echo "Input SN timeout 120s.Reboot now"
                reboot -f
        fi
    done

    if [ -e /usr/bin/parted.sh ]; then
        echo "Format disk..."
        /usr/bin/parted.sh
        echo "Complete parted."
        mkdir -p /tmp/src
        if ! mount -t vfat /dev/sdb1 /tmp/src ; then
            fatal "Could not mount udisk install partition"
        fi
        mkdir -p /tmp/media
        if ! mount -t ext4 -o loop /tmp/src/rootfs.img /tmp/media ; then
            fatal "Could not mount udisk rootfs.img"
        fi
        mkdir -p /tmp/boot
        dd if=/usr/share/syslinux/mbr.bin of=/dev/sda bs=440 count=1
        syslinux -s /dev/sda1
        if ! mount -t vfat /dev/sda1 /tmp/boot ; then
            fatal "Could not mount boot partition"
        fi
        mkdir -p /tmp/boot/boot
        cp /tmp/media/boot/initrd /tmp/boot/boot/
        cp /tmp/media/boot/bzImage /tmp/boot/boot/
        cp /tmp/media/syslinux.cfg /tmp/boot/
        cp /tmp/src/isolinux/vesamenu.c32 /tmp/boot/
        cp /tmp/src/isolinux/libcom32.c32 /tmp/boot/
        cp /tmp/src/isolinux/libutil.c32 /tmp/boot/
        sync
        umount /tmp/boot
        mkdir -p /tmp/update
        if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda2 /tmp/update ; then
            fatal "Could not mount update partition"
        fi
        cp /tmp/media/GAP-X86.rootfs.tar.gz /tmp/update
        sync
        umount /tmp/update
        umount /tmp/media
        umount /tmp/src
        sync
        echo "Complete!Reboot now"
        reboot -f
    fi
}

fatal() {
    echo $1 >$CONSOLE
    echo >$CONSOLE
    exec sh
}

early_setup() {
    mkdir -p /proc
    mkdir -p /sys
    mount -t proc proc /proc
    mount -t sysfs sysfs /sys

    # use /dev with devtmpfs
    if grep -q devtmpfs /proc/filesystems; then
        mkdir -p /dev
        mount -t devtmpfs devtmpfs /dev
        mkdir -p /dev/shm
        mount /dev/shm
    else
        if [ ! -d /dev ]; then
                fatal "ERROR: /dev doesn't exist and kernel doesn't has devtmpfs enabled."
        fi
    fi

    mkdir -p /run
    mkdir -p /var/run

    if [ -d /lib/modules- ]; then
        if [ -f /lib/modules-/igb.ko ]; then
            echo "load igb driver..."
            cd /lib/modules-/ && insmod igb.ko
        fi
        if [ -f /lib/modules-/e1000e.ko ]; then
            echo "load e1000e driver..."
            cd /lib/modules-/ && insmod e1000e.ko
        fi
    fi

    #$_UDEV_DAEMON --daemon
    #udevadm trigger --action=add
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            label=*)
                label=$optarg 
                ;;
            console=*)
                if [ -z "${console_params}" ]; then
                    console_params=$arg
                else
                    console_params="$console_params $arg"
                fi
                ;;
        esac
    done
}

early_setup

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args
[ -z "$label" ] && label="BOOT"

case $label in
    BOOT)
        boot_live_root
        ;;
    INSTALL)
        install_live_root
        ;;
    *)
        # Not sure what boot label is provided.  Try to boot to avoid locking up.
	fatal "Enter debug shell"
        ;;
esac

# If we're getting here, we failed...
fatal "Installation image failed"
