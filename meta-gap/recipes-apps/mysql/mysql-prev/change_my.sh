#!/bin/sh

inout=`cat /var/run/boardtype`

if [ x"$inout" = x"outer" ]; then
    echo 'run at outer,disable mysql service'
    #cp -f /etc/outer-my.cnf /etc/my.cnf
    update-rc.d -f mysqld remove
    update-rc.d -f install_db remove
    update-rc.d -f redis-server remove
    update-rc.d -f celeryd remove
    cp -f /etc/inner-my.cnf /etc/my.cnf
else
    echo 'run at inner'
    cp -f /etc/inner-my.cnf /etc/my.cnf
fi
