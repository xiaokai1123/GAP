SUMMARY = "ADlink BMC application"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://ADLINK_SEMA.tar.gz \
    file://wdt.sh \
    file://sema_wdt \
"

inherit update-rc.d

INITSCRIPT_NAME = "wdt.sh"
INITSCRIPT_PARAMS = "start 03  1 2 3 4 5 . stop 59 0 6 ."

do_install() {
    install -d ${D}
    cp -a ${WORKDIR}/usr ${D}
    cp -a ${WORKDIR}/etc ${D}

    install -m 0755 ${WORKDIR}/sema_wdt ${D}/usr/bin
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/wdt.sh ${D}${sysconfdir}/init.d/wdt.sh
}

INSANE_SKIP_${PN} = "already-stripped"

PACKAGES = "${PN}"
FILES_${PN} = "${sysconfdir} /usr"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
