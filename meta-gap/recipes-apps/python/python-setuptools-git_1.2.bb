DESCRIPTION = "Setuptools revision control system plugin for Git"
HOMEPAGE = "https://github.com/msabramo/setuptools-git"
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"
SRCNAME = "setuptools-git"

SRC_URI = "https://pypi.python.org/packages/d9/c5/396c2c06cc89d4ce2d8ccf1d7e6cf31b33d4466a7c65a67a992adb3c6f29/setuptools-git-${PV}.tar.gz"

SRC_URI[md5sum] = "40b2ef7687a384ea144503c2e5bc67e2"
SRC_URI[sha256sum] = "ff64136da01aabba76ae88b050e7197918d8b2139ccbf6144e14d472b9c40445"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

