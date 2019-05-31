FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

#DEPENDS += " mysql5 "

DEPENDS += "libdbi libdbi-drivers"
PACKAGECONFIG = " \
    zlib rsyslogd rsyslogrt klog inet regexp uuid libgcrypt \
    imdiag gnutls imfile libdbi mysql \
"

SRC_URI_append += " \
	file://rsyslog.conf \
	file://50-default.conf \
	file://logrotate.rsyslog \
	file://20-fw.conf \
	file://mysql-inner.conf \
	file://mysql-outer.conf \
"

do_install_extra() {
	install -d ${D}${sysconfdir}/rsyslog.d/
        install -m 0664 ${WORKDIR}/rsyslog.conf ${D}${sysconfdir}/
        install -m 0664 ${WORKDIR}/20-fw.conf ${D}${sysconfdir}/rsyslog.d/
		install -m 0664 ${WORKDIR}/logrotate.rsyslog ${D}${sysconfdir}/rsyslog.d/
        install -m 0664 ${WORKDIR}/50-default.conf ${D}${sysconfdir}/rsyslog.d/
		install -m 0664 ${WORKDIR}/mysql-inner.conf ${D}${sysconfdir}/rsyslog.d/mysql-inner
        install -m 0664 ${WORKDIR}/mysql-outer.conf ${D}${sysconfdir}/rsyslog.d/mysql-outer
}
addtask install_extra after do_install before do_package
