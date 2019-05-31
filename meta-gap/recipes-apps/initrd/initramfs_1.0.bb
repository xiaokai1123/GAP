SUMMARY = "Init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
RDEPENDS_${PN} = "udev udev-extraconf parted e2fsprogs-mke2fs"
SRC_URI = "\
        file://init-boot.sh \
"
INITBOOT = "init-boot.sh"

SRC_URI_x86-64 = "\
        file://init-boot-x86.sh \
        file://parted-x86.sh \
"
INITBOOT_x86-64 = "init-boot-x86.sh"

PR = "r0"

S = "${WORKDIR}"

do_install() {
        install -d ${D}/dev
        mknod -m 600 ${D}/dev/console c 5 1
        mknod -m 666 ${D}/dev/null c 1 3
        mknod -m 0660 ${D}/dev/loop0 b 7 0
        install -d ${D}/sbin
        install -m 0755 ${WORKDIR}/${INITBOOT} ${D}/sbin/init
        if [ -f ${WORKDIR}/parted-x86.sh ]; then
            install -d ${D}/usr/bin
            install -m 0755 ${WORKDIR}/parted-x86.sh ${D}/usr/bin/parted.sh
        fi
}

FILES_${PN} += "/sbin /dev"
