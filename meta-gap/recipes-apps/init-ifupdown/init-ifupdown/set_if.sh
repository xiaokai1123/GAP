#!/bin/sh
#auth: eason lian
#date: 1/22/2016

check_line()
{
  if [ -z $1 ];then
    echo "error: not valid line"
    exit
  fi
  #echo $1
}

update_line()
{
  check_line ${1}
  #delete & new insert
  sed -i "${1}d" /etc/network/interfaces
  sed -i "${1}i ${2}" /etc/network/interfaces
}

#args: ip mask gateway
func_static()
{
  if [ $# != 3 ];then
    echo "args error"
    return
  fi

  line=`sed -n '/iface agl0 inet dhcp/{=;}' /etc/network/interfaces`
  update_line $line "#iface agl0 inet dhcp"

  line=`sed -n '/iface agl0 inet static/{=;}' /etc/network/interfaces`
  update_line $line "iface agl0 inet static"

  line=`expr "$line" + 1`
  update_line $line "\\\taddress $1"

  line=`expr "$line" + 1`
  update_line $line "\\\tnetmask $2"

  line=`expr "$line" + 1`
  update_line $line "\\\tgateway $3"
}

func_dhcp()
{
  line=`sed -n '/iface agl0 inet dhcp/{=;}' /etc/network/interfaces`
  update_line $line "iface agl0 inet dhcp"

  line=`sed -n '/iface agl0 inet static/{=;}' /etc/network/interfaces`
  update_line $line "#iface agl0 inet static"

  line=`expr "$line" + 1`
  update_line $line "#\taddress 0.0.0.0"

  line=`expr "$line" + 1`
  update_line $line "#\tnetmask 0.0.0.0"

  line=`expr "$line" + 1`
  update_line $line "#\tgateway 0.0.0.0"
}

get_select()
{
  status=
  line=`sed -n '/#iface agl0 inet dhcp/{=;}' /etc/network/interfaces`
  if [ -z $line ];then
     echo "select dhcp"
     status="dhcp"
  fi

  line=`sed -n '/#iface agl0 inet static/{=;}' /etc/network/interfaces`
  if [ -z $line ];then
     echo "select static"
     status="static"
  fi

  if [ -z $status ];then
     echo "error: config file invalid"
     exit 1
  fi
}

case "$1" in
  static)
    cp /etc/network/interfaces_default /etc/network/interfaces
    func_static $2 $3 $4
    ;;
  dhcp)
    cp /etc/network/interfaces_default /etc/network/interfaces
    func_dhcp
    ;;
  status)
    get_select                                                         
    ;;
  *)
    ;;
esac
  
exit

