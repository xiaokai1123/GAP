FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://ntpd \
    file://ntpdate.crontab \
	file://ntpdate.default \
"

do_install_append() {
    install -d ${D}${sysconfdir}/init.d/
    install -m 0777 ${WORKDIR}/ntpd ${D}${sysconfdir}/init.d/
    install -d ${D}${sysconfdir}/cron.d/
    install -m 0644 ${WORKDIR}/ntpdate.crontab ${D}${sysconfdir}/cron.d/ntp_cron
	install -d ${D}${sysconfdir}/default/
	install -m 0644 ${WORKDIR}/ntpdate.default ${D}${sysconfdir}/default/ntpdate
    #rm -rf ${D}/${sysconfdir}/network/if-up.d/ntpdate-sync
    rm -rf ${D}/${sysconfdir}/network/
}

FILES_ntpdate += "/etc/cron.d"

pkg_postinst_ntpdate_append() {
    if [ -f $D/var/spool/cron/root ]; then
        echo "remove ntpdate crontab"
        sed -i "/ntpdate-sync/d" $D/var/spool/cron/root
    fi
}
