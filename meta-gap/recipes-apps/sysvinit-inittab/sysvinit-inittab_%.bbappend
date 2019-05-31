FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

#for i3-6100u com-e module
SERIAL_CONSOLE = "115200;ttyS0"

SRC_URI += " \
	file://inittab \
"
