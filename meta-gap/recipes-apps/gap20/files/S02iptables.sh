#!/bin/sh

case "$1" in
    start)
    	iptables_init
    ;;
    stop)
    ;;
esac
