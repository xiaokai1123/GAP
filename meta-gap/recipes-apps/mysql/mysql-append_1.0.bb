SUMMARY = "Initial Mysql DB"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://init_mysql_tab.sh \
    file://createDB.sql \
"

S = "${WORKDIR}/${PN}-${PV}"

inherit update-rc.d

INITSCRIPT_NAME = "init_mysql_tab.sh"
INITSCRIPT_PARAMS = "start 46 1 2 3 4 5 ."

do_install(){
    install -d ${D}/etc/init.d	
    install -m 0755 ${WORKDIR}/init_mysql_tab.sh ${D}/etc/init.d
    install -d ${D}/etc/dbsql
    install -m 0644 ${WORKDIR}/createDB.sql ${D}/etc/dbsql
}

INSANE_SKIP_${PN} = "${sysconfdir} ${bindir}"

PACKAGES = "${PN}"
FILES_${PN} = "${sysconfdir}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
