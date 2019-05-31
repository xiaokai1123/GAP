DESCRIPTION = "Run multiple subprocesses asynchronous/in parallel with streamed output/non-blocking reading. Also various tools to replace shell scripts."
HOMEPAGE = ""
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=33ab1ce13e2312dddfad07f97f66321f"

#RDEPENDS_${PN} += "python-mmap python-multiprocessing"
DEPENDS += "jansson expat"
RDEPENDS_${PN} += "jansson"

PR = "r0"
SRCNAME = "uwsgi"

SRC_URI = "https://pypi.python.org/packages/bb/0a/45e5aa80dc135889594bb371c082d20fb7ee7303b174874c996888cc8511/uwsgi-${PV}.tar.gz"

SRC_URI[md5sum] = "fc50bd9e83b7602fa474b032167010a7"
SRC_URI[sha256sum] = "572ef9696b97595b4f44f6198fe8c06e6f4e6351d930d22e5330b071391272ff"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

