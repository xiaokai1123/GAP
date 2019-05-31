FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://defconfig \
    file://bootked.pp \
    file://0001-fix-optional-issue-on-sysadm-module.patch \
    file://0002-make-unconfined_u-the-default-selinux-user.patch \
"

do_install_append () {
    install -d ${D}/etc/selinux/
    install -m 0755 ${WORKDIR}/defconfig ${D}/etc/selinux/config
    install -m 0755 ${WORKDIR}/bootked.pp ${D}/etc/selinux/
}

