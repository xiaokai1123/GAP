#! /bin/sh
set -e

# source function library
. /etc/init.d/functions

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/bin:"

case "$1" in
  start)
        echo "Starting : Init Mysql DB"
	if [ ! -f /data/mysql/.mysql ]; then
		for file in /etc/dbsql/*
		do
			if [ "${file##*.}" = "sql" ]; then
				mysql -u root <${file}
			fi
		done
		touch /data/mysql/.mysql
	fi
        echo "done."
        ;;
  stop)
        ;;

  restart)
        ;;

  *)
        echo "Usage: /etc/init.d/init_mysql_tab.sh {start|stop|restart}"
        exit 1
esac

exit 0
