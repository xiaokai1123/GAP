FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS += "libpam"
RDEPENDS_${PN} += "libpam"

SRC_URI += "\
    file://mkfs_vfat.cfg \
    file://udhcp.cfg \
    file://pam.cfg \
    file://login.cfg \
    file://tar.cfg \
    file://ntp.cfg \
    file://reboot.cfg \
"
