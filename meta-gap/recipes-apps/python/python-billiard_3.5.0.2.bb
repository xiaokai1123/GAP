DESCRIPTION = "Python multiprocessing fork with improvements and bugfixes"
HOMEPAGE = "http://github.com/celery/billiard"
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

#RDEPENDS_${PN} += "python-importlib python-kombu python-vine"

PR = "r0"
SRCNAME = "billiard"

SRC_URI = "https://pypi.python.org/packages/e6/b8/6e6750f21309c21ea267834d5e76b89ce64a9ddf38fa4161fd6fb32ffc3b/billiard-${PV}.tar.gz"

SRC_URI[md5sum] = "301a16643bc51d73869df81c9aa1e082"
SRC_URI[sha256sum] = "3eb01a8fe44116aa6d63d2010515ef1526e40caee5f766f75b2d28393332dcaa"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

