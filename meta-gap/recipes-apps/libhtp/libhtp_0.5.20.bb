SUMMARY = "HTTP protocol parser"
DESCRIPTION = "LibHTP is a security-aware parser for the HTTP protocol and the related bits and pieces."
HOMEPAGE = "https://github.com/OISF/libhtp"
SECTION = "devel/tools"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=0c904b06274c9a3b8902b9474fa4682a"

DEPENDS = "zlib"

SRCREV = "e23ea3ac82457a4c48cf4b2a1cc754be0cd7969c"

SRC_URI = "git://github.com/OISF/libhtp.git;protocols=https;branch=0.5.x"

S = "${WORKDIR}/git"

inherit autotools

