SUMMARY = "ISO GAP apps"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "openssl readline ncurses libevent protobuf protobuf-c libhtp glib-2.0 sqlite3 mysql5 json-c iptables libcap samba"

inherit externalsrc

EXTERNALSRC = "${EXTERNAL_SOURCES_DIR}/gap20"
EXTERNALSRC_BUILD = "${EXTERNAL_SOURCES_DIR}/gap20"

#inherit update-rc.d

#INITSCRIPT_NAME = "gap20.sh"
#INITSCRIPT_PARAMS = "start 55 1 2 3 4 5 . stop 85 0 6 ."

U_PLATFORM = "x86"

#GAP_ENABLE_GUANGTIE_FEATURE = "1"

EXTRA_OEMAKE = "CC='${CC}'"

#CFLAGS += "-I${STAGING_DIR_TARGET}${includedir}/samba-4.0"
#CFLAGS += "-I${STAGING_DIR_TARGET}${includedir}/glib-2.0"
#CFLAGS += "-I${STAGING_DIR_TARGET}/usr/lib/glib-2.0/include"
#CFLAGS += "-I${STAGING_DIR_TARGET}/usr/lib64/glib-2.0/include"

do_compile() {
    make clean
    #make all PLATFORM=${U_PLATFORM} GAP_ENABLE_GUANGTIE_FEATURE=${GAP_ENABLE_GUANGTIE_FEATURE}
    make all PLATFORM=${U_PLATFORM} SDKTARGETSYSROOT=${STAGING_DIR_TARGET}
}

do_install() {
    make install PLATFORM=${U_PLATFORM} DEST_INSTALL=${D}
    chmod +s ${D}/usr/bin/vtysh
}

pkg_postinst_${PN}() {
    chmod a+s /usr/bin/vtysh
}

INSANE_SKIP_${PN} = "ldflags"

PACKAGES = "${PN}"
FILES_${PN} = "/"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
