SUMMARY = "Inner Outer configure files"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://change_my.sh \
    file://inner-my.cnf \
    file://outer-my.cnf \
    file://mysql.conf \
    file://database.conf \
"

S = "${WORKDIR}/${PN}-${PV}"

inherit update-rc.d

INITSCRIPT_NAME = "change_my.sh"
INITSCRIPT_PARAMS = "start 44 1 2 3 4 5 . stop 75 0 6 ."

do_install(){
    install -d ${D}/etc/init.d	
    install -m 0755 ${WORKDIR}/database.conf ${D}/etc/
    install -m 0755 ${WORKDIR}/change_my.sh ${D}/etc/init.d
    install -m 0644 ${WORKDIR}/inner-my.cnf ${D}/etc/
    install -m 0644 ${WORKDIR}/outer-my.cnf ${D}/etc/
    install -d ${D}/etc/rsyslog.d
    install -m 0644 ${WORKDIR}/mysql.conf ${D}/etc/rsyslog.d
}

INSANE_SKIP_${PN} = "${sysconfdir}"

PACKAGES = "${PN}"
FILES_${PN} = "${sysconfdir}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
