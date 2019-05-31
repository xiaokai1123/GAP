SUMMARY = "Tsar (Taobao System Activity Reporter) is a monitoring tool"
SECTION = "devel/tools"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=86d3f3a95c324c9479bd8986968f4327"

#DEPENDS = ""

inherit externalsrc

EXTERNALSRC = "${EXTERNAL_SOURCES_DIR}/tsar"
EXTERNALSRC_BUILD = "${EXTERNAL_SOURCES_DIR}/tsar"

EXTRA_OEMAKE = "CC='${CC}'"

do_configure[noexec] = "1"

do_compile() {
    oe_runmake
}

do_install () {
    install -d ${D}
    oe_runmake -j1 DEST_INSTALL=${D} install
}

INSANE_SKIP_${PN} = "ldflags"

PACKAGES = "${PN}"
FILES_${PN} = "/etc /usr"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
