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
    fsck.ext4 -y /dev/sda1
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

    if [ ! -f /tmp/update/tar_ok -a -f "/tmp/update/RSA-PPC.rootfs.tar.gz" ]; then
        umount $ROOT_MOUNT
        echo "Format rootfs partition..."
        mkfs.ext4 -F /dev/sda3
        if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda3 $ROOT_MOUNT ; then
            fatal "Could not mount rootfs partition"
        fi
        echo "Please wait!Upgrade system..."
        tar -xf /tmp/update/RSA-PPC.rootfs.tar.gz -C ${ROOT_MOUNT}
        mv /tmp/update/RSA-PPC.rootfs.tar.gz /tmp/update/.old.rootfs.tar.gz
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

    #$_UDEV_DAEMON --daemon
    #udevadm trigger --action=add
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
            label=*)
                label=$optarg ;;
            console=*)
                if [ -z "${console_params}" ]; then
                    console_params=$arg
                else
                    console_params="$console_params $arg"
                fi ;;
        esac
    done
}

early_setup

[ -z "$CONSOLE" ] && CONSOLE="/dev/console"

read_args
[ -z "$label" ] && label="boot"

case $label in
    boot)
	boot_live_root
        ;;
    *)
        # Not sure what boot label is provided.  Try to boot to avoid locking up.
	fatal "Enter debug shell"
        ;;
esac

# If we're getting here, we failed...
fatal "Installation image failed"
