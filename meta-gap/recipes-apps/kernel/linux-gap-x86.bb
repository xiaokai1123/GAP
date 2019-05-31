SUMMARY = "Linux kernel & modules"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "bc-native lzop-native coreutils-native iptables"
RDEPENDS_${PN} = ""

inherit externalsrc 

EXTERNALSRC = "${EXTERNAL_SOURCES_DIR}/linux"
EXTERNALSRC_BUILD = "${EXTERNAL_SOURCES_DIR}/linux"

#do_compile[nostamp] = "1"

do_compile () {
    if [ ! -f ./._build_pass ]; then
        ./build-kernel.sh
        if [ $? = 0 ]; then
            touch ._build_pass
            if [ ! -d "${TMPDIR}/work-shared/${MACHINE} " ]; then
                mkdir -p ${TMPDIR}/work-shared/${MACHINE}
            fi
            #ln -s `pwd` ${TMPDIR}/work-shared/${MACHINE}/kernel-build-artifacts
            #ln -s `pwd` ${TMPDIR}/work-shared/${MACHINE}/kernel-source
        fi
    fi
}

do_install () {
    install -d ${D}/boot
    install -m 0755 ${S}/arch/x86_64/boot/bzImage ${D}/boot
    install -d ${D}/lib/modules-/
    install -m 0755 ${S}/drivers/net/ethernet/intel/e1000e/e1000e.ko ${D}/lib/modules-/
    if [ -d ${S}/igb-5.3.5.20/src ]; then
        install -m 0755 ${S}/igb-5.3.5.20/src/igb.ko ${D}/lib/modules-/
    fi
    if [ -d ${S}/gap-kernel ]; then
        install -m 0755 ${S}/gap-kernel/gap_kernel.ko ${D}/lib/modules-/
    fi
    if [ -d ${S}/fpga ]; then
        install -m 0755 ${S}/fpga/fpga.ko ${D}/lib/modules-/
    fi
    install -m 0755 ${S}/modules.tar.gz ${D}/lib/modules-/
    install -d ${DEPLOY_DIR_IMAGE}
    install -m 0755 ${S}/arch/x86_64/boot/bzImage ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}
} 

PACKAGES = "${PN} ${PN}-modules"
FILES_${PN} = "/boot"
FILES_${PN}-modules = "/lib/modules-"

INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

#INSANE_SKIP_${PN} = "ldflags"
#INSANE_SKIP_${PN} = "already-stripped"
