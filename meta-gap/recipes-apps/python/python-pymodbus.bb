DESCRIPTION = "A full modbus protocol written in python"
SECTION = "devel/python"
HOMEPAGE = "https://github.com/riptideio/pymodbus"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit setuptools

SRC_URI = "https://github.com/riptideio/pymodbus/archive/v2.1.0.tar.gz"

SRC_URI[md5sum] = "8b378b859f48c116545677ea66d17ce8"
SRC_URI[sha256sum] = "c07ff46fa16b8861471336c18a26ca965675f341e8bea62296c6ce695d3a4c64"

S = "${WORKDIR}/pymodbus-2.1.0"

