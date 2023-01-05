#!/bin/sh
PREREQ="networking"
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


. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/wget /usr/bin/real_wget
copy_exec /etc/ssl/certs/ca-certificates.crt
