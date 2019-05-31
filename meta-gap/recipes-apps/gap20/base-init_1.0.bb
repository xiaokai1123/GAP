SUMMARY = "GAP initial scriptes"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://baseinit.sh \
    file://init-inner.sh \
    file://init-outer.sh \
    file://S01test.sh \
    file://S03seum.sh \
    file://S03init_gpg_pub_key.sh \
    file://S02iptables.sh \
    file://S04init-port.sh \
    file://S05logincache.sh \
"
S = "${WORKDIR}/${PN}-${PV}"

inherit update-rc.d

INITSCRIPT_NAME = "baseinit.sh"
INITSCRIPT_PARAMS = "start 20 1 2 3 4 5 . stop 75 0 6 ."

do_install(){
	install -d ${D}/etc/init.d	
	
	install -m 0755 ${WORKDIR}/baseinit.sh ${D}/etc/init.d
	install -m 0755 ${WORKDIR}/init-inner.sh ${D}/etc/init.d
	install -m 0755 ${WORKDIR}/init-outer.sh ${D}/etc/init.d
	install -d ${D}/etc/init.d/inner
	install -m 0755 ${WORKDIR}/S01test.sh ${D}/etc/init.d/inner
	install -m 0755 ${WORKDIR}/S03seum.sh ${D}/etc/init.d/inner
	install -d ${D}/etc/init.d/outer
	install -m 0755 ${WORKDIR}/S01test.sh ${D}/etc/init.d/outer
	install -m 0755 ${WORKDIR}/S03seum.sh ${D}/etc/init.d/outer

	install -m 0755 ${WORKDIR}/S02iptables.sh ${D}/etc/init.d/outer/
	install -m 0755 ${WORKDIR}/S03init_gpg_pub_key.sh ${D}/etc/init.d/inner/
	install -m 0755 ${WORKDIR}/S02iptables.sh ${D}/etc/init.d/inner/

	install -m 0755 ${WORKDIR}/S04init-port.sh ${D}/etc/init.d/inner
	install -m 0755 ${WORKDIR}/S04init-port.sh ${D}/etc/init.d/outer

	#install -m 0644 ${WORKDIR}/ntpdate ${D}/etc/outer_ntpdate 
	install -m 0755 ${WORKDIR}/S05logincache.sh ${D}/etc/init.d/inner
	install -m 0755 ${WORKDIR}/S05logincache.sh ${D}/etc/init.d/outer
}

PACKAGES = "${PN}"
FILES_${PN} = "${sysconfdir}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
