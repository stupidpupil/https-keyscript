#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

if [ -x /bin/keyctl ]
then
        copy_exec /bin/keyctl
fi
