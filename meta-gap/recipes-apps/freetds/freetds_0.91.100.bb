SUMMARY = "FreeTDS is a set of libraries for Unix and Linux that allows your programs to natively talk to Microsoft SQL Server and Sybase databases."
HOMEPAGE = "http://www.freetds.org"
LICENSE = "GPLv2"

LIC_FILES_CHKSUM = "file://COPYING;md5=c93c0550bd3173f4504b2cbd8991e50b \
                    file://COPYING.LIB;md5=55ca817ccb7d5b5b66355690e9abc605"

RDEPENDS_${PN} = "readline"

SRC_URI = "ftp://ftp.freetds.org/pub/freetds/stable/${PN}-${PV}.tar.gz"
#SRC_URI = "ftp://ftp.freetds.org/pub/freetds/old//${PN}-${PV}.tar.gz/"
#SRC_URI[md5sum] = "7bfcb5c21a9964a0dff62c8a08b7d64d"
#SRC_URI[sha256sum] = "249fde284c2cea5cee46946d4afbc1e666d8a9464a196d05967f0b3901830063"
SRC_URI[md5sum] = "f5e58f203e1545b457a8cbeebcfaa955"
SRC_URI[sha256sum] = "25c5fd50b6a18433eabb7bfcaeeb377111256e5d5b4cbbf17c4f50303f804050"

S = "${WORKDIR}/${PN}-${PV}"

#do_configure(){
#	cd ${S}&&./configure --disable-libiconv
#}

EXTRA_OECONF += "--disable-libiconv"
do_configure () {
    cd ${S}
    ./configure ${CONFIGUREOPTS} ${EXTRA_OECONF} 
}

inherit autotools
