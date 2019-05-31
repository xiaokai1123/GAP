
do_install_append() {
        echo "l root root 0755 /var/log /data/log" >> ${D}/etc/default/volatiles/00_core
}
