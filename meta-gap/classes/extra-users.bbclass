inherit extrausers

#encrypt passwd can be generate from command:
#openssl passwd -1 -salt $(< /dev/urandom tr -dc '[:alnum:]' | head -c 32)
#passwd Rongan123!@#
#shadow $1$CHM6Ligf$Pe61op9JqCgYVNTWAktXP0

EXTRA_USERS_PARAMS = "useradd -g root -u 0 -o -p '\$1\$CHM6Ligf\$Pe61op9JqCgYVNTWAktXP0' admin;usermod -s /usr/bin/vtysh admin;"

EXTRA_USERS_PARAMS += "usermod -s /bin/sh root;usermod -s /bin/false nobody;usermod -s /bin/false www;usermod -s /sbin/nologin www-data;"
#EXTRA_USERS_PARAMS += "usermod -s /sbin/nologin root;usermod -s /bin/false nobody;usermod -s /bin/false www;usermod -s /sbin/nologin www-data;"

EXTRA_USERS_PARAMS += "\
    userdel -r bin;\
    userdel -r bin;\
    userdel -r sys;\
    userdel -r daemon;\
    userdel -r games;\
    userdel -r man;\
    userdel -r lp;\
    userdel -r mail;\
    userdel -r news;\
    userdel -r uucp;\
    userdel -r proxy;\
    userdel -r kmem;\
    userdel -r dialout;\
    userdel -r fax;\
    userdel -r voice;\
    userdel -r cdrom;\
    userdel -r floppy;\
    userdel -r tape;\
    userdel -r sudo;\
    userdel -r audio;\
    userdel -r dip;\
    userdel -r backup;\
    userdel -r operator;\
    userdel -r list;\
    userdel -r irc;\
    userdel -r src;\
    userdel -r gnats;\
    userdel -r shadow;\
    userdel -r utmp;\
    userdel -r video;\
    userdel -r sasl;\
    userdel -r plugdev;\
    userdel -r staff;\
    userdel -r games;\
    userdel -r shutdown;\
    userdel -r users;\
    userdel -r sync;\
"
EXTRA_USERS_PARAMS += "\
    groupdel daemon;\
    groupdel bin;\
    groupdel sys;\
    groupdel adm;\
    groupdel disk;\
    groupdel lp;\
    groupdel mail;\
    groupdel news;\
    groupdel uucp;\
    groupdel man;\
    groupdel proxy;\
    groupdel kmem;\
    groupdel dialout;\
    groupdel fax;\
    groupdel voice;\
    groupdel cdrom;\
    groupdel floppy;\
    groupdel tape;\
    groupdel sudo;\
    groupdel audio;\
    groupdel dip;\
    groupdel backup;\
    groupdel operator;\
    groupdel list;\
    groupdel irc;\
    groupdel src;\
    groupdel gnats;\
    groupdel shadow;\
    groupdel utmp;\
    groupdel video;\
    groupdel sasl;\
    groupdel plugdev;\
    groupdel staff;\
    groupdel games;\
    groupdel shutdown;\
    groupdel users;\
"

EXTRA_USERS_PARAMS += "\
	groupadd auditmanager;\
	groupadd securitymanager;\
	groupadd supermanager;\
	groupadd sysmanager;\
	usermod -G supermanager admin\
"