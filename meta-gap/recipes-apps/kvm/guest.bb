SUMMARY = "Configure for kvm"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://guest.xml \
    file://guest.sh \
"

inherit update-rc.d

INITSCRIPT_NAME = "guest.sh"
INITSCRIPT_PARAMS = "start 75  1 2 3 4 5 . stop 60 0 6 ."
#INITSCRIPT_PARAMS = "remove"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install () {
    install -d ${D}/etc/kvm
    install -m 0664 ${WORKDIR}/guest.xml ${D}/etc/kvm
    install -d ${D}/etc/init.d
    install -m 0755 ${WORKDIR}/guest.sh ${D}/etc/init.d
}

PACKAGES = "${PN}"
FILES_${PN} = "/etc"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
