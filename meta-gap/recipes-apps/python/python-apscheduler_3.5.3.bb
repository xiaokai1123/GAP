DESCRIPTION = "Advanced Python Scheduler (APScheduler) is a Python library that lets you schedule your Python code to be executed later, either just once or periodically."
SECTION = "devel/python"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://PKG-INFO;beginline=8;endline=8;md5=8227180126797a0148f94f483f3e1489"

inherit setuptools

SRCNAME = "APScheduler"

SRC_URI = "https://files.pythonhosted.org/packages/42/a7/c9569e03058430cef420d3543e8f63bc7b32d77ae03278becae977cf32a7/${SRCNAME}-3.5.3.tar.gz"

SRC_URI[md5sum] = "5686871a0331a8b606600b818fe3c862"
SRC_URI[sha256sum] = "6599bc78901ee7e9be85cbd073d9cc155c42d2bc867c5cde4d4d1cc339ebfbeb"

S = "${WORKDIR}/${SRCNAME}-${PV}"

SRC_URI += "file://setup.py"

do_update() {
        cp ${WORKDIR}/setup.py ${S}/setup.py
}

addtask update before do_configure after do_unpack
