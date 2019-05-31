# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

SYSLOAD_x86-64 = "linux-gap-x86-modules syslinux syslinux-mbr syslinux-extlinux"

PACKAGE_INSTALL = "\
	initramfs \
	${SYSLOAD} \
	busybox \
	bash \
	udev \
	base-files \
	base-passwd \
	initscripts \
	ethtool \
	pciutils  \
	e2fsprogs \
        e2fsprogs-e2fsck \
        dosfstools \
	tar \
	${ROOTFS_BOOTSTRAP_INSTALL} \
"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

RM_OLD_IMAGE = "1"

IMAGE_NAME = "gap-boot"
IMAGE_LINGUAS = ""

LICENSE = "MIT"

IMAGE_FSTYPES = "cpio.gz"
IMAGE_FSTYPES_ppc64 += "cpio.gz.u-boot"

inherit core-image

BAD_RECOMMENDATIONS += "busybox-syslog"

do_install_img() {
	if [ -f ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.cpio.gz.u-boot ]; then
	    mv ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.cpio.gz.u-boot ${DEPLOY_DIR_IMAGE}/ramdisk.img
	    rm ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.* ${DEPLOY_DIR_IMAGE}/${PN}*
	else
	    cp ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.cpio.gz ${DEPLOY_DIR_IMAGE}/initrd
	fi
}

addtask install_img before do_build after do_image_complete

do_rootfs[nostamp] = "1"
do_install_img[nostamp] = "1"
