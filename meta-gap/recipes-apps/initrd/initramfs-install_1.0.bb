SUMMARY = "Init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
RDEPENDS_${PN} = "udev udev-extraconf parted e2fsprogs-mke2fs"
SRC_URI = "\
        file://init-install.sh \
        file://parted.sh \
"

PR = "r0"

S = "${WORKDIR}"

do_install[depends] += "core-image-initrd:do_install_img"
do_install[depends] += "core-image-ppc:do_install_img"

do_install() {
        install -d ${D}/dev
        mknod -m 600 ${D}/dev/console c 5 1
        mknod -m 666 ${D}/dev/null c 1 3
        mknod -m 0660 ${D}/dev/loop0 b 7 0
        install -d ${D}/sbin
        install -d ${D}/usr/bin
        install -m 0755 ${WORKDIR}/init-install.sh ${D}/sbin/init
        install -m 0755 ${WORKDIR}/parted.sh ${D}/usr/bin/

        install -d ${D}/boot
        cp ${DEPLOY_DIR_IMAGE}/RSA-PPC.rootfs.tar.gz ${D}/
        cp ${DEPLOY_DIR_IMAGE}/ramdisk.img ${D}/boot/
}

FILES_${PN} += "/"
