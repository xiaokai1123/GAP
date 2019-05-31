DESCRIPTION = ""
HOMEPAGE = "https://vine.readthedocs.io "
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6fadb0e48ceb84b571372dd706ed76a0"

#RDEPENDS_${PN} += "python-importlib"

PR = "r0"
SRCNAME = "vine"

SRC_URI = "https://pypi.python.org/packages/35/21/308904b027636f13c3970ed7caf2c53fca77fa160122ae3ac392d9eb6307/vine-${PV}.tar.gz"

SRC_URI[md5sum] = "7e56d432c7ba15afcd23416a0ab7725b"
SRC_URI[sha256sum] = "87b95da19249373430a8fafca36f1aecb7aa0f1cc78545877857afc46aea2441"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

