#!/bin/sh
#
# This script is for format flash.
#

#function:
#arg1: sda
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
    #parted /dev/sda mklabel gpt 
    parted /dev/sda mklabel msdos 
    parted /dev/sda mkpart primary 1 500
    parted /dev/sda mkpart primary 501 1000
    parted /dev/sda mkpart primary 1001 41960
    parted /dev/sda mkpart primary 41961 100%

    mkfs.ext4 -F ${disk_}1
    mkfs.ext4 -F ${disk_}2
    mkfs.ext4 -F ${disk_}3
    mkfs.ext4 -F ${disk_}4
}

partition sda

