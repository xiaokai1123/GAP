#! /bin/sh
set -e

# source function library
. /etc/init.d/functions

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/bin:"

case "$1" in
  start)
        echo "Starting Watchdog"
        start-stop-daemon --start --background --exec /usr/bin/sema_wdt
        echo "done."
        ;;
  stop)
        echo "Stopping Watchdog"
	start-stop-daemon --stop --name sema_wdt
	#semaeapi_tool -a SemaEApiWDogStop
        ;;

  restart)
        $0 stop
        $0 start
        ;;

  *)
        echo "Usage: /etc/init.d/wdt.sh {start|stop|restart}"
        exit 1
esac

exit 0
