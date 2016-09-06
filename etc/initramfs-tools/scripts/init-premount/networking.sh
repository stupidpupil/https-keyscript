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

# The more sensible approach might be use the configure_networking function
# but I struggled to make this work well independently of configuring NFS
wait_for_udev 10
ipconfig -t 30 -c dhcp -d eth0

# DNS.WATCH
echo 'nameserver 84.200.69.80' > /etc/resolv.conf