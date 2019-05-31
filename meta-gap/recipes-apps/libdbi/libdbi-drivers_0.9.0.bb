# libdbi-drivers OE build file
# Copyright (C) 2005, Koninklijke Philips Electronics NV.  All Rights Reserved
# Released under the MIT license (see packages/COPYING)

DESCRIPTION = "Database Drivers for libdbi"
HOMEPAGE = "http://libdbi-drivers.sourceforge.net/"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=d8045f3b8f929c1cb29a1e3fd737b499"

SECTION = "libs"

PROVIDES = "libdbd-sqlite"
DEPENDS = "libdbi sqlite sqlite3 mysql5 postgresql freetds"
RDEPENDS_${PN} = "libdbd-freetds libdbd-mysql libdbd-pgsql libdbd-sqlite3 "

SRC_URI = "${SOURCEFORGE_MIRROR}/libdbi-drivers/libdbi-drivers-${PV}.tar.gz"

SRC_URI[md5sum] = "9f47b960e225eede2cdeaabf7d22f59f"
SRC_URI[sha256sum] = "43d2eacd573a4faff296fa925dd97fbf2aedbf1ae35c6263478210c61004c854"

SRC_URI += " \
	file://0001-don-t-compile-tests-directory.patch \
"

inherit autotools

PACKAGES += "libdbd-sqlite3 libdbd-sqlite libdbd-pgsql libdbd-mysql libdbd-freetds"

EXTRA_OECONF = "--with-dbi-incdir=${STAGING_INCDIR} \
                --with-dbi-libdir=${STAGING_LIBDIR} \
                --with-sqlite \
                --with-sqlite3 \
                --with-pgsql \
                --with-mysql \
		--with-freetds \
                --with-sqlite-libdir=${STAGING_LIBDIR} \
                --with-sqlite-incdir=${STAGING_INCDIR} \
                --with-sqlite3-incdir=${STAGING_INCDIR} \
                --with-sqlite3-libdir=${STAGING_LIBDIR} \
                --with-mysql-incdir=${STAGING_INCDIR}/mysql \
                --with-mysql-libdir=${STAGING_LIBDIR} \
                --with-pgsql-incdir=${STAGING_INCDIR} \
                --with-pgsql-libdir=${STAGING_LIBDIR} \
		--with-freetds-incdir=${STAGING_INCDIR} \
                --with-freetds-libdir=${STAGING_LIBDIR} \
		--disable-docs \
"

FILES_${PN}-dbg += " ${libdir}/dbd/.debug/*.so"
FILES_${PN}-dev += " ${libdir}/dbd/*.la"
FILES_${PN}-staticdev += " ${libdir}/dbd/*.a"

DESCRIPTION_libdbd-sqlite = "SQLite database driver for libdbi"
FILES_libdbd-sqlite = "${libdir}/dbd/libdbdsqlite.so"

DESCRIPTION_libdbd-sqlite3 =  "SQLite3 database driver for libdbi"
FILES_libdbd-sqlite3 = "${libdir}/dbd/libdbdsqlite3.so"

DESCRIPTION_libdbd-mysql = "MySQL4 database driver for libdbi"
FILES_libdbd-mysql = "${libdir}/dbd/libdbdmysql.so"

DESCRIPTION_libdbd-psql = "Postgres SQL database driver for libdbi"
FILES_libdbd-pgsql = "${libdir}/dbd/libdbdpgsql.so"

DESCRIPTION_libdbd-freetds = "MS SQL database driver for libdbi"
FILES_libdbd-freetds = "${libdir}/dbd/libdbdfreetds.so"


