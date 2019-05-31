FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://76-net-description.rules \
"

do_install_append() {
	install -d ${D}/lib64/udev/rules.d/
	install -m 0755 ${WORKDIR}/76-net-description.rules ${D}/lib64/udev/rules.d/
}

FILES_${PN} = "/"
