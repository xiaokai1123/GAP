DESCRIPTION = "provides a clean way to execute subprocesses"
SECTION = "devel/python"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://PKG-INFO;beginline=8;endline=8;md5=845e560ecc39395e8f142a154032aec7"

inherit setuptools

SRCNAME = "shelljob"

SRC_URI = "https://files.pythonhosted.org/packages/7f/c4/3f1393d9960dd11b85e96a640a7587ce5bf65d75773fec82a744ba52add7/${SRCNAME}-0.5.6.tar.gz"

SRC_URI[md5sum] = "a3354810a7a480d2aa6043ab93a607c8"
SRC_URI[sha256sum] = "0466b5227f59ff7b44f03e76bd025f80fd21a5fac2622312758d96e732e3c73f"

S = "${WORKDIR}/${SRCNAME}-${PV}"

