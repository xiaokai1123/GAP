FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://0001-fix-iptables-log-drop-log-accept.patch \
        file://0001-add-libxt_land-libxt_psd-libxt_syncookie-to-iptables.patch \
"
