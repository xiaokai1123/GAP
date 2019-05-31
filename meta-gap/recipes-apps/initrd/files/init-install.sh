#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

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
    else
        if [ ! -d /dev ]; then
                fatal "ERROR: /dev doesn't exist and kernel doesn't has devtmpfs enabled."
        fi
    fi

    mkdir -p /run
    mkdir -p /var/run
}

read_args() {
    [ -z "$CMDLINE" ] && CMDLINE=`cat /proc/cmdline`
    for arg in $CMDLINE; do
        optarg=`expr "x$arg" : 'x[^=]*=\(.*\)'`
        case $arg in
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

if [ -e /usr/bin/parted.sh ]; then
    /usr/bin/parted.sh
    mkdir -p /tmp/boot
    if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda1 /tmp/boot ; then
        fatal "Could not mount boot partition"
    fi
    mkdir -p /tmp/boot/boot
    cp /boot/ramdisk.img /tmp/boot/boot/
    sync
    umount /tmp/boot
    mkdir -p /tmp/update
    if ! mount -t ext4 -o rw,loop,noatime,nodiratime /dev/sda2 /tmp/update ; then
        fatal "Could not mount update partition"
    fi
    cp /RSA-PPC.rootfs.tar.gz /tmp/update
    sync
    umount /tmp/update
    echo "Complete!Reboot now"
    reboot -f
fi

# If we're getting here, we failed...
fatal "Installation image failed"
