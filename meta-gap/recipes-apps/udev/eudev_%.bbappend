FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://50-udev-default.rules \
	file://init_udev \
	file://50-vusb-add.rules \
	file://50-vusb-remove.rules \
	file://usb-libvirt-hotplug.sh \
	file://portalarm.sh \
	file://ethport.rules \
	file://hatakeover.py \
"

do_install_append() {
	install -d ${D}/etc/init.d/
	install -m 0755 ${WORKDIR}/init_udev ${D}/etc/init.d/udev
	install -d ${D}/lib64/udev/rules.d/
	install -m 0644 ${WORKDIR}/50-udev-default.rules ${D}/lib64/udev/rules.d/
	install -m 0644 ${WORKDIR}/50-vusb-remove.rules ${D}/lib64/udev/rules.d/
	install -m 0644 ${WORKDIR}/50-vusb-add.rules ${D}/lib64/udev/rules.d/
	install -m 0755 ${WORKDIR}/usb-libvirt-hotplug.sh ${D}/lib64/udev/

	install -m 0644 ${WORKDIR}/ethport.rules ${D}/lib64/udev/rules.d/
	install -m 0755 ${WORKDIR}/portalarm.sh ${D}/lib64/udev/
	install -m 0755 ${WORKDIR}/hatakeover.py ${D}/lib64/udev/
}

FILES_${PN} = "/"
