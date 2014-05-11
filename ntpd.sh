#!/bin/sh
#
# kill existing ntp daemon
[ -f /var/run/ntpd.pid ] && kill `cat /var/run/ntpd.pid`
# try start a new ntp daemon
ntpcommand="busybox-ext ntpd"
if [ -n "$ntpsrv" ]; then
    for ntp in $ntpsrv
    do
      ntpcommand="$ntpcommand -p $ntp"
    done
    $ntpcommand
else
    $ntpcommand -p pool.ntp.org
fi
