FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://login \
"

do_install_append() {
    install -d ${D}/etc/pam.d/
    install -m 0644 ${WORKDIR}/login ${D}/etc/pam.d/
}
