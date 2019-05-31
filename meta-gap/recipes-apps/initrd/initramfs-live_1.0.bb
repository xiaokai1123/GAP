SUMMARY = "Init script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
RDEPENDS_${PN} = "udev udev-extraconf parted e2fsprogs-mke2fs"
SRC_URI = "\
        file://init-boot-x86.sh \
        file://parted.sh \
        file://syslinux.cfg \
        file://i210/eeupdate64e \
        file://i210/I210_Invm_Copper_APM_v0.6.txt \
        file://i210/fuse.sh \
"

PR = "r0"

S = "${WORKDIR}"

do_install[depends] += "core-image-initrd:do_install_img"
do_install_x86-64[depends] += "core-image-x86:do_install_img"

TARBALL_x86-64 = "GAP-X86.rootfs.tar.gz"

INITRD_NAME_x86-64 = "initrd"

do_install() {
        install -d ${D}/dev
        mknod -m 600 ${D}/dev/console c 5 1
        mknod -m 666 ${D}/dev/null c 1 3
        mknod -m 0660 ${D}/dev/loop0 b 7 0
        install -d ${D}/sbin
        install -d ${D}/usr/bin
        install -m 0755 ${WORKDIR}/init-boot-x86.sh ${D}/sbin/init
        install -m 0755 ${WORKDIR}/parted.sh ${D}/usr/bin/

        install -d ${D}/tools
        install -m 0755 ${WORKDIR}/i210/eeupdate64e ${D}/tools
        install -m 0755 ${WORKDIR}/i210/I210_Invm_Copper_APM_v0.6.txt ${D}/tools
        install -m 0755 ${WORKDIR}/i210/fuse.sh ${D}/tools
        
        install -d ${D}/boot
        install -m 0755 ${WORKDIR}/syslinux.cfg ${D}/
        install -m 0666 ${DEPLOY_DIR_IMAGE}/${TARBALL} ${D}/
        install -m 0666 ${DEPLOY_DIR_IMAGE}/${INITRD_NAME} ${D}/boot/
}

FILES_${PN} += "/"
