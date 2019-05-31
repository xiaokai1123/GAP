#!/bin/sh
#
# This script is for format flash.
#

#function:
#arg1: sdx
partition() {
    disk_=/dev/${1}
    if [ ! -e ${disk_} ]; then
        echo "The device node ${disk_} not effect."
        return 1
    fi

    #umount /run/media/${1}1
    #umount /run/media/${1}2
    #umount /run/media/${1}3
    #umount /run/media/${1}4
    dd if=/dev/zero of=${disk_} bs=1k count=8
    #parted ${disk_} mklabel gpt 
    parted ${disk_} mklabel msdos 
    parted ${disk_} mkpart primary fat32 1 500
    parted ${disk_} mkpart primary ext4 501 1200
    parted ${disk_} mkpart primary ext4 1201 20480
    parted ${disk_} mkpart primary ext4 20481 100%
    parted ${disk_} set 1 boot on

    mkfs.vfat ${disk_}1
    mkfs.ext4 -F ${disk_}2
    mkfs.ext4 -F ${disk_}3
    mkfs.ext4 -F ${disk_}4
}

partition sda

