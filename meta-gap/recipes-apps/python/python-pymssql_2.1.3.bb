DESCRIPTION = "DB-API interface to Microsoft SQL Server for Python. (new Cython-based version)"
HOMEPAGE = "http://pymssql.org"
SECTION = "devel/python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=fbc093901857fcd118f065f900982c24"

DEPENDS += "python-setuptools-git freetds"
PR = "r0"
SRCNAME = "pymssql"

SRC_URI = "https://pypi.python.org/packages/4c/c8/5ad36d8d3c304ab4f310c89d0593ab7b6229568dd8e9cde927311b2f0c00/pymssql-${PV}.tar.gz"

SRC_URI[md5sum] = "eb159dfeec0d0bc3312f1b24c028a2f4"
SRC_URI[sha256sum] = "afcef0fc9636fb059d8e2070978d8b66852f4046531638b12610adc634152427"

S = "${WORKDIR}/${SRCNAME}-${PV}"

inherit setuptools

do_package_qa[noexec] = "1"

