# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

PROVIDES = "virtual/install"

INITRAMFSNAME = "initramfs-install"
INITRAMFSNAME_x86-64 = "initramfs-live"

KERNELIMG_x86-64 = "linux-gap-x86"

SYSLINUX_CFG_C_x86-64 = "${TOPDIR}/../meta-gap/recipes-apps/initrd/files/isolinux.cfg"

PACKAGE_INSTALL = "\
	${INITRAMFSNAME} \
	${KERNELIMG} \
	busybox \
	udev \
	base-files \
	base-passwd \
	initscripts \
	e2fsprogs \
        e2fsprogs-e2fsck \
	${ROOTFS_BOOTSTRAP_INSTALL} \
"

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

RM_OLD_IMAGE = "1"

IMAGE_NAME = "gap-install"
IMAGE_LINGUAS = ""

LICENSE = "MIT"

IMAGE_FSTYPES = "tar.gz"

IMAGE_FSTYPES_x86-64 = "live"

NOHDD = "1"

INITRD_IMAGE_LIVE_x86-64 = "core-image-initrd"

INSTALLTAR_x86-64 = "GAP-X86.install.tar.gz"

inherit core-image

BAD_RECOMMENDATIONS += "busybox-syslog"

do_install_img() {
	if [ -f ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.tar.gz ]; then
	    mv ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.tar.gz ${DEPLOY_DIR_IMAGE}/${INSTALLTAR}
	fi
	rm ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.* ${DEPLOY_DIR_IMAGE}/${PN}*
}

addtask install_img before do_build after do_image_complete

do_rootfs[nostamp] = "1"
do_install_img[nostamp] = "1"
