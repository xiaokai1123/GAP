DESCRIPTION = "Library to create spreadsheet files compatible with MS Excel 97/2000/XP/2003 XLS files"
SECTION = "devel/python"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://PKG-INFO;beginline=8;endline=8;md5=e910b35b0ef4e1f665b9a75d6afb7709"

inherit setuptools

SRCNAME = "xlwt"

SRC_URI = "https://files.pythonhosted.org/packages/06/97/56a6f56ce44578a69343449aa5a0d98eefe04085d69da539f3034e2cd5c1/${SRCNAME}-1.3.0.tar.gz"

SRC_URI[md5sum] = "4b1ca8a3cef3261f4b4dc3f138e383a8"
SRC_URI[sha256sum] = "c59912717a9b28f1a3c2a98fd60741014b06b043936dcecbc113eaaada156c88"

S = "${WORKDIR}/${SRCNAME}-${PV}"

