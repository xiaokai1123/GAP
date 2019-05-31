DESCRIPTION = "Celery is a simple, flexible, and reliable distributed system to process vast amounts of messages, while providing operations with the tools required to maintain such a system."
HOMEPAGE = "http://celeryproject.org/"
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=80e311a389f8f2a8fad52af377af954e"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

#RDEPENDS_${PN} += "python-importlib python-kombu python-vine python-amqp python-billiard python-pytz python-redis"
RDEPENDS_${PN} += "python-kombu python-vine python-amqp python-billiard python-pytz python-redis"
RDEPENDS_${PN} += "python-argparse"

PR = "r0"
SRCNAME = "celery"

SRC_URI = "https://pypi.python.org/packages/b2/b7/888565f3e955473247aef86174db5121d16de6661b69bd8f3d10aff574f6/celery-${PV}.tar.gz"
SRC_URI += "file://celeryd"
SRC_URI += "file://celeryd.conf"

SRC_URI[md5sum] = "364dbf014ad57a6aa60d823670642e5d"
SRC_URI[sha256sum] = "e3d5a6c56a73ff8f2ddd4d06dc37f4c2afe4bb4da7928b884d0725ea865ef54d"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools
inherit update-rc.d
INITSCRIPT_NAME = "celeryd"
INITSCRIPT_PARAMS = "start 60 1 2 3 4 5 . stop 75 0 6 ."

do_install_append(){
    install -d ${D}/etc/init.d
    install -d ${D}/etc/default
    install -m 0755 ${WORKDIR}/celeryd ${D}/etc/init.d
    install -m 0644 ${WORKDIR}/celeryd.conf ${D}/etc/default/celeryd
}
