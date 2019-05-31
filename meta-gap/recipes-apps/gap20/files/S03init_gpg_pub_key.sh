#! /bin/sh
exit 0

gpg --homedir /etc/ --list-key acorn-ked-u2000 > /dev/null 2>&1
if [ $? -ne 0 ];then
   if [ -e /etc/ked-u2000-pub-key ];then
       rm -rf /etc/trustdb.gpg
       echo "first time to import gpg-pub-key"
       gpg --homedir /etc/ --import /etc/ked-u2000-pub-key
   fi
fi



