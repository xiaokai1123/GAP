SUMMARY = "Rootfs for GAPX86 project."

PROVIDES = "virtual/bundle"

USE_DEPMOD = "0"

DISTRO_FEATURES_remove = "ptest"

PACKAGE_FEED_URIS = "http://192.168.1.23:8000"

IMAGE_FEATURES += " package-management"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

RM_OLD_IMAGE = "1"

IMAGE_NAME = "GAP-X86"

IMAGE_FSTYPES += "tar.gz"

IMAGE_INSTALL = " \
    packagegroup-distro-base \
    packagegroup-machine-base \
"

#IMAGE_INSTALL += " \
#    packagegroup-core-selinux \
#"

require gapx86.inc

inherit core-image

inherit extra-users

do_rootfs[nostamp] = "1"

PACKAGE_EXCLUDE += "dnsmasq"

do_install_img() {
       mv ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.manifest ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.manifest
       rm ${DEPLOY_DIR_IMAGE}/${PN}*
}

addtask install_img before do_build after do_image_complete

TARBALL_NAME = "${IMAGE_NAME}.rootfs.tar.gz"

do_signed() {
        gap_version=`date +%Y%m%d%W`
        bin_name=RSG-${gap_version}.bin
        img_name=RSG-${gap_version}.img
        bbnote "generator a tail desc"
        cp ${DEPLOY_DIR_IMAGE}/${TARBALL_NAME} ${DEPLOY_DIR_IMAGE}/${img_name}
        ${EXTERNAL_SOURCES_DIR}/tools/AddImageHead.sh ${img_name} ${DEPLOY_DIR_IMAGE}
        rm -f ${DEPLOY_DIR_IMAGE}/${img_name}
        bbnote "end signed version file"
}
addtask signed after do_install_img before do_build

