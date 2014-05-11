#!/bin/sh
#
#exec >/tmp/access.log 2>&1
#set -x

killaccessdaemons() {
  if [ -f /var/run/telnetd.pid ]; then
    kill `cat /var/run/telnetd.pid`
    rm /var/run/telnetd.pid
  fi
  if [ -f /var/run/ftpd.pid ]; then
    kill `cat /var/run/ftpd.pid`
    rm /var/run/ftpd.pid
  fi
}
# start telnet & ftp daemons
startaccessdaemons() {
  if [ ! -f /var/run/telnetd.pid ] || [ ! -d /proc/`cat /var/run/telnetd.pid` ]; then
    telnetd -F -l /bin/bash &
    echo $! >/var/run/telnetd.pid
  fi
  if [ ! -f /var/run/ftpd.pid ] || [ ! -d /proc/`cat /var/run/ftpd.pid` ]; then
    tcpsvd -vE 0.0.0.0 21 ftpd /mnt/sd/DCIM/ &
    echo $! >/var/run/ftpd.pid
  fi
}

# kill the autoupload process
killautoupload() {
  if [ -f /var/run/autoupload.pid ]; then
    kill `cat /var/run/autoupload.pid`
    rm /var/run/autoupload.pid
  fi
}

# start autoupload
startautoupload() {
  if [ ! -f /var/run/autoupload.pid ] || [ ! -d /proc/`cat /var/run/autoupload.pid` ]; then
    :
    $autoup $CONFIG_INI /var/run/autoupload.pid >/tmp/autoupload.log 2>&1 &
    # $autoup $CONFIG_INI /var/run/autoupload.pid &
  fi
}

apssid=$(iwconfig $interface \
		| $bbext grep ESSID: \
		| $bbext sed 's/^.*ESSID:"\([^"]\+\)".*$/\1/')
# Identify current router
ping -c 1 $router >/dev/null 2>&1
routerMAC=$($bbext arp -n $router | $bbext awk '{print $4}')

#
# Handle DHCP event
#
case "$1" in
  deconfig)
    killaccessdaemons
    killautoupload
    ;;
  bound)
    echo "$apssid:$router:$routerMAC" >> /tmp/netid.log
    if [ x"$apssid:$router:$routerMAC" = x"$cfg_ssid:$cfg_router:$cfg_router_mac" ] ; then
      # Trusted network - run open access
      startaccessdaemons
      startautoupload
    else
      # Non trusted networks
      killaccessdaemons
      killautoupload
    fi
    ;;
  renew)
    # Do nothing, no change
    ;;
esac
