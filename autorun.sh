#!/bin/sh 
telnetd -p 24 -l /bin/sh &
#exec >/tmp/autorun.log 2>&1
#set -x

# Based on:
#    https://www.pitt-pladdy.com/blog/_20140202-083815_0000_Transcend_Wi-Fi_SD_Hacks_CF_adaptor_telnet_custom_upload_/
#
SDCARD=/mnt/sd
CUSTOM=$SDCARD/.custom
CONFIG_INI=$CUSTOM/config.sh
[ ! -x $CUSTOM/busybox-armv5l ] && exit

. $CONFIG_INI
cp $CUSTOM/busybox-armv5l $bbext
chmod a+x $bbext
cp $CUSTOM/autoupload $autoup
chmod a+x $autoup

# Add config settings
DHCP_SCRIPT=/etc/dhcp.script
echo CONFIG_INI=$CONFIG_INI  >>$DHCP_SCRIPT
cat $CONFIG_INI >>$DHCP_SCRIPT

# Add ntp support
cat $CUSTOM/ntpd.sh >>$DHCP_SCRIPT
# Add local access code
cat $CUSTOM/access.sh >>$DHCP_SCRIPT

# safety - change mount to ro
$bbext sed -i.orig -e 's/ -w / -r /' /usr/bin/refresh_sd
refresh_sd

# We now set-up aliases for convenence...
# We run in the background...
( set +x ; . $CUSTOM/alias.sh ) &
