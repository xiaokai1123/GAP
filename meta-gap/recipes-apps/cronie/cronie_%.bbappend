FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://crontab \
"

do_install_append() {
	install -d ${D}/etc
	install -m 0644 ${WORKDIR}/crontab ${D}/etc/crontab
}
