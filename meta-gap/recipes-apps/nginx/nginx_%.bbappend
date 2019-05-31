FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://server.crt \
    file://server.key \
    file://client.crt \
    file://inner.conf \
    file://outer.conf \
"

do_install_append () {
    install -d ${D}/etc/nginx/key_cert
    install -m 0755 ${WORKDIR}/server.crt ${D}/etc/nginx/key_cert/server.crt
    install -m 0755 ${WORKDIR}/server.key ${D}/etc/nginx/key_cert/server.key
    install -m 0755 ${WORKDIR}/client.crt ${D}/etc/nginx/key_cert/client.crt
    install -d ${D}/etc/nginx/vhost
    install -m 0644 ${WORKDIR}/inner.conf ${D}/etc/nginx/vhost
    install -m 0644 ${WORKDIR}/outer.conf ${D}/etc/nginx/vhost
    rm -rf ${D}/var/www/localhost
}

