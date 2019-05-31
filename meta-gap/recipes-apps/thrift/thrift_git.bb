SUMMARY = "Apache Thrift"
DESCRIPTION =  "A software framework, for scalable cross-language services development"
HOMEPAGE = "https://thrift.apache.org/"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=394465e125cffc0f133695ed43f14047 \
                    file://NOTICE;md5=42748ae4646b45fbfa5182807321fb6c"

DEPENDS = "thrift-native boost flex-native bison-native openssl"

SRC_URI = "git://github.com/apache/thrift.git;branch=0.11.0;protocol=https"

SRCREV = "327ebb6c2b6df8bf075da02ef45a2a034e9b79ba"
S = "${WORKDIR}/git"

SRC_URI += "file://0001-THRIFT-3828-In-cmake-avoid-use-of-both-quoted-paths-.patch"

BBCLASSEXTEND = "native nativesdk"

inherit pkgconfig cmake pythonnative

export STAGING_INCDIR
export STAGING_LIBDIR
export BUILD_SYS
export HOST_SYS

EXTRA_OECMAKE = " \
    -DBUILD_LIBRARIES=ON \
    -DBUILD_COMPILER=ON \
    -DBUILD_TESTING=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_TUTORIALS=OFF \
    -DWITH_CPP=ON \
    -DWITH_JAVA=OFF \
    -DWITH_STATIC_LIB=ON \
    -DWITH_SHARED_LIB=ON \
    -DWITH_OPENSSL=OFF \
    -DWITH_QT4=OFF \
    -DWITH_QT5=OFF \
"

PACKAGECONFIG ??= "libevent glib python"
PACKAGECONFIG[libevent] = "-DWITH_LIBEVENT=ON,-DWITH_LIBEVENT=OFF,libevent,"
PACKAGECONFIG[python] = "-DWITH_PYTHON=ON,-DWITH_PYTHON=OFF,python,"
PACKAGECONFIG[glib] = "-DWITH_C_GLIB=ON,-DWITH_C_GLIB=OFF,glib-2.0 ,"

do_install_append () {
    ln -sf thrift ${D}/${bindir}/thrift-compiler
    if [ -d "${D}/usr/lib" ]; then
	cd ${S}/lib/py
        python setup.py install
        install -d ${D}/usr/lib64/python2.7/site-packages/
        cp -a ${S}/lib/py/build/lib.*/thrift ${D}/usr/lib64/python2.7/site-packages/
	mv ${D}/usr/lib/* ${D}/usr/lib64/
        rm -rf ${D}/usr/lib
    fi
}

LEAD_SONAME = "libthrift.so.${PV}"

# thrift packages
PACKAGE_BEFORE_PN = "${PN}-compiler lib${BPN}"
#FILES_lib${BPN} = "${libdir}/*.so.*"
FILES_lib${BPN} = "/usr/lib64/*.so.* /usr/lib64/python2.7/"
FILES_${PN}-compiler = "${bindir}/*"

# The thrift packages just pulls in some default dependencies but is otherwise empty
RRECOMMENDS_${PN} = "${PN}-compiler lib${BPN}"
ALLOW_EMPTY_${PN} = "1"
RRECOMMENDS_${PN}_class-native = ""
RRECOMMENDS_${PN}_class-nativesdk = ""
