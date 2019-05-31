DESCRIPTION = "A high-level Python Web framework"
HOMEPAGE = "http://flask.pocoo.org/"
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=118fecaa576ab51c1520f95e98db61ce"

PR = "r0"
SRCNAME = "Flask-Cors"

SRC_URI = "https://pypi.python.org/packages/1d/ea/86765a4ae667b4517dc16ef0fc8dd632ca3ea56ef419c4a6de31e715324e/Flask-Cors-${PV}.tar.gz"

SRC_URI[md5sum] = "11800bbedcc64233485f705411091be8"
SRC_URI[sha256sum] = "0a09f3559ded4759387dfa2a355de59bc161f67269a1f4b7b0712a64b1f7dad6"


S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

FILES_${PN} += "${datadir}/flask"
