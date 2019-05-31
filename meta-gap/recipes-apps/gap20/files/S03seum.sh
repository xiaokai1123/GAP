#!/bin/sh

exit 0
case "$1" in
    start)
	which linux-filter && schedtool -a 2 -e `which linux-filter` &
    ;;
    stop)
	pidof linux-filter && kill -9 `pidof linux-filter`
    ;;
esac
