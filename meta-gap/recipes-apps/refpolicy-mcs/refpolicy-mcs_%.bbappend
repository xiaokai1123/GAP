FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://defconfig \
    file://0001-update-seusers.patch \
    file://0002-modify-staff_u-contexts.patch \
    file://bootked.pp \
"

do_install_append () {
    install -d ${D}/etc/selinux/
    install -m 0755 ${WORKDIR}/defconfig ${D}/etc/selinux/config
    install -m 0755 ${WORKDIR}/bootked.pp ${D}/etc/selinux/
}

