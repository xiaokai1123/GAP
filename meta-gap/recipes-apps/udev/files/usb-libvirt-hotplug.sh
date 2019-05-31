#!/bin/sh

date >> /tmp/log_usb
PROG="$(basename "$0")"

echo ACTION=${ACTION} >> /tmp/log_usb
if [ "x${ACTION}" == "xadd" ]; then
  COMMAND='attach-device'
elif [ "x${ACTION}" == "xremove" ]; then
  COMMAND='detach-device'
  FLAG_RM=1
else
  echo "Invalid udev ACTION: ${ACTION}" >> /tmp/log_usb
  exit 1
fi

if [ -z "x${ID_VENDOR_ID}" -o -z "x${ID_MODEL_ID}" ]; then
  exit 1
fi

if [ "x${ID_VENDOR_ID}" == "x0403" -a "x${ID_MODEL_ID}" == "x6001" ]; then
  exit 1                                                                      
fi                                                                            
if [ "x${ID_VENDOR_ID}" == "x0424" -a "x${ID_MODEL_ID}" == "x9e00" ]; then
  exit 1                                                                      
fi                                                                            
if [ "x${ID_VENDOR_ID}" == "x1d6b" -a "x${ID_MODEL_ID}" == "x0002" ]; then
  exit 1                                                                      
fi                                                                            
if [ "x${ID_VENDOR_ID}" == "x0424" -a "x${ID_MODEL_ID}" == "x2514" ]; then
  exit 1                                                                      
fi                                                                            
if [ "x${ID_VENDOR_ID}" == "x8087" -a "x${ID_MODEL_ID}" == "x07e6" ]; then
  exit 1                                                               
fi

if [ "x${ID_VENDOR_ID}" == "x1d6b" -a "x${ID_MODEL_ID}" == "x0003" ]; then
  exit 1                                                               
fi
if [ "x${ID_VENDOR_ID}" == "x1d6b" -a "x${ID_MODEL_ID}" == "x0002" ]; then
  exit 1                                                               
fi
if [ "x${ID_VENDOR_ID}" == "x8087" -a "x${ID_MODEL_ID}" == "x8000" ]; then
  exit 1                                                               
fi
if [ "x${ID_VENDOR_ID}" == "x8087" -a "x${ID_MODEL_ID}" == "x8008" ]; then
  exit 1                                                               
fi
if [ "x${ID_VENDOR_ID}" == "x0b95" -a "x${ID_MODEL_ID}" == "x772b" ]; then
  exit 1                                                               
fi

if [ "x${ID_USB_DRIVER}" != "xusb-storage" -a "x${ID_USB_DRIVER}" != "xusbhid" ]; then
  exit 1                                                               
fi
echo ID_USB_DRIVER=${ID_USB_DRIVER} >> /tmp/log_usb

cat << END > /tmp/usb-${ID_VENDOR_ID}${ID_MODEL_ID}.xml
<hostdev mode='subsystem' type='usb' managed='no'>
  <source>
    <vendor id='0x${ID_VENDOR_ID}' />
    <product id='0x${ID_MODEL_ID}'/>
  </source>
  <address type='usb' bus='$2'/>
</hostdev>
END
virsh detach-device $1 --file /tmp/usb-${ID_VENDOR_ID}${ID_MODEL_ID}.xml 
virsh "${COMMAND}" $1 --file /tmp/usb-${ID_VENDOR_ID}${ID_MODEL_ID}.xml 
if [ ${FLAG_RM} = "1" ]; then
    rm -f /tmp/usb-${ID_VENDOR_ID}${ID_MODEL_ID}.xml
fi
