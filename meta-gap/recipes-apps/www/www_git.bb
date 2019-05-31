SUMMARY = "Web"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS_${PN}= "python python-flask python-flask-sqlalchemy python-shelljob mysql-python python-celery"

inherit externalsrc

EXTERNALSRC = "${EXTERNAL_SOURCES_DIR}/www"
EXTERNALSRC_BUILD = "${EXTERNAL_SOURCES_DIR}/www"

inherit update-rc.d
INITSCRIPT_NAME = "www.sh"
INITSCRIPT_PARAMS = "start 60 1 2 3 4 5 . stop 75 0 6 ."

do_install() {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/www.sh ${D}${sysconfdir}/init.d
	install -d ${D}${localstatedir}/www
	cp -a ${B}/* ${D}${localstatedir}/www/
}

INSANE_SKIP_${PN} = "${sysconfdir} ${localstatedir}"

PACKAGES = "${PN}"
FILES_${PN} = "${sysconfdir} ${localstatedir}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
