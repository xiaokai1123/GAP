FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

dirs755_append = " /data /data/log /update /dev/shm"

SRC_URI += " \
	file://fstab \
	file://rongan_eeprom \
	file://sn_write \
"

PROJECT = "RaOS"

do_install_append() {
	echo ${PROJECT} > ${D}${sysconfdir}/hostname
	install -m 0644 fstab ${D}${sysconfdir}
	install -m 0777 rongan_eeprom ${D}/usr/bin
	install -m 0666 sn_write ${D}/usr/bin
	install -d ${D}/etc/modprobe.d
	echo "blacklist i915" >> ${D}/etc/modprobe.d/blacklist.conf
	echo "blacklist drm" >> ${D}/etc/modprobe.d/blacklist.conf
	echo "blacklist altera_cvp" >> ${D}/etc/modprobe.d/blacklist.conf
	echo "blacklist fpga_mgr" >> ${D}/etc/modprobe.d/blacklist.conf
	echo "options kvm ignore_msrs=1" >> ${D}/etc/modprobe.d/kvm.conf
	echo "options kvm allow_unsafe_assigned_interrupts=1" >> ${D}/etc/modprobe.d/kvm_iommu.conf
	echo "options kvm_intel nested=1 ept=1" >> ${D}/etc/modprobe.d/kvm_iommu.conf
}

