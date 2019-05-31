DESCRIPTION = "This Python module returns a `tzinfo` object with the local timezone information under Unix and Win-32."
SECTION = "devel/python"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://PKG-INFO;beginline=8;endline=8;md5=8227180126797a0148f94f483f3e1489"

inherit setuptools

SRCNAME = "tzlocal"

SRC_URI = "https://files.pythonhosted.org/packages/cb/89/e3687d3ed99bc882793f82634e9824e62499fdfdc4b1ae39e211c5b05017/${SRCNAME}-1.5.1.tar.gz"

SRC_URI[md5sum] = "4553be891efa0812c4adfb0c6e818eec"
SRC_URI[sha256sum] = "4ebeb848845ac898da6519b9b31879cf13b6626f7184c496037b818e238f2c4e"

S = "${WORKDIR}/${SRCNAME}-${PV}"

