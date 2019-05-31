# libdbi OE build file
# Copyright (C) 2005, Koninklijke Philips Electronics NV.  All Rights Reserved
# Released under the MIT license (see packages/COPYING)

DESCRIPTION = "Database Independent Abstraction Layer for C"
HOMEPAGE = "http://libdbi.sourceforge.net/"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=d8045f3b8f929c1cb29a1e3fd737b499"
SECTION = "libs"

INC_PR = "r0"

SRC_URI = "${SOURCEFORGE_MIRROR}/libdbi/libdbi-${PV}.tar.gz"

inherit autotools

EXTRA_OECONF = "--disable-docs"

PR = "${INC_PR}.0"

SRC_URI[md5sum] = "05e2ceeac4bc85fbe40de8b4b22d9ab3"
SRC_URI[sha256sum] = "dafb6cdca524c628df832b6dd0bf8fabceb103248edb21762c02d3068fca4503"
