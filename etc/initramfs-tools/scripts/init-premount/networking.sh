#!/bin/sh
set -e

PREREQ=""

prereqs()
{
    echo "$PREREQ"
}

case $1 in
    prereqs)
        prereqs
        exit 0
        ;;
esac

. /scripts/functions

wait_for_udev 10
ipconfig -t 30 -c dhcp -d eth0

# DNS.WATCH
echo 'nameserver 84.200.69.80' > /etc/resolv.conf