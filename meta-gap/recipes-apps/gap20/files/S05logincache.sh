#!/bin/sh
echo " create table if not exists logincache (ip varchar(24) PRIMARY KEY, errtimes Integer);" | sqlite3 /etc/gap_sqlite3_db.conf
