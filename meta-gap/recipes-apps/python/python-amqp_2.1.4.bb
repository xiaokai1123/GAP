DESCRIPTION = "This is a fork of amqplib which was originally written by Barry Pederson. It is maintained by the Celery project, and used by kombu as a pure python alternative when librabbitmq is not available."
HOMEPAGE = "http://celeryproject.org/"
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9d6ba772ac59c08a25a12ce15bd5f27b"

#RDEPENDS_${PN} += "python-importlib python-kombu python-vine"

PR = "r0"
SRCNAME = "amqp"

SRC_URI = "https://pypi.python.org/packages/23/39/06bb8bd31e78962675f696498f7821f5dbd11aa0919c5a811d83a0e02609/amqp-${PV}.tar.gz"

SRC_URI[md5sum] = "035a475e42ef4f431b4e0dca113434bd"
SRC_URI[sha256sum] = "1378cc14afeb6c2850404f322d03dec0082d11d04bdcb0360e1b10d4e6e77ef9"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

