SUMMARY = "Mpm application"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

U_PRODUCT = "RonganGap"

DEP_RECIPES_gapx86 = "gap20"

DEPENDS += "${DEP_RECIPES}"

inherit externalsrc

EXTERNALSRC = "${EXTERNAL_SOURCES_DIR}/mpm"
EXTERNALSRC_BUILD = "${EXTERNAL_SOURCES_DIR}/mpm"

inherit update-rc.d

INITSCRIPT_NAME = "mpm.sh"
INITSCRIPT_PARAMS = "start 55  1 2 3 4 5 . stop 60 0 6 ."
#INITSCRIPT_PARAMS = "remove"

inherit autotools-brokensep

MPM_CONF = "mpm.conf"
MPM_CONF_gapx86 = "mpm_gap.conf"

MPM_SH = "mpm.sh"
MPM_SH_gapx86 = "mpm_gap.sh"

EXTRA_OECONF_x86-64 = 'CFLAGS="-I./ -DX86_PLATFORM -D${U_PRODUCT}" LDFLAGS="-lpthread"'

do_install() {
	install -d ${D}${sysconfdir}
	install -m 0755 ${S}/${MPM_CONF} ${D}${sysconfdir}/mpm.conf
	
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/${MPM_SH} ${D}${sysconfdir}/init.d/mpm.sh

	install -d ${D}${bindir}
	install -m 0755 ${B}/mpm ${D}${bindir}/mpm
}

INSANE_SKIP_${PN} = "ldflags"

PACKAGES = "${PN}"
FILES_${PN} = "${sysconfdir} ${bindir}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
