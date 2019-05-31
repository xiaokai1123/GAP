FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += " \
    file://interfaces \
    file://init \
"

do_install_append() {
    install -d ${D}/etc/init.d/
    install -m 0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/network/interfaces
    install -m 0755 ${WORKDIR}/init ${D}/etc/init.d/networking
}
