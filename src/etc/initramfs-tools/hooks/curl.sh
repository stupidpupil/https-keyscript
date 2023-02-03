#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

# To find out what library are needed do
# strace curl https://badssl.com 2>&1 | grep open
for needed_lib in "libnss_dns*.so*" "libnss_files*.so*" "libresolv*.so*" "ld-linux*.so*" "libc-*.so" "libc.so.*"
do
	lib=$(find /lib/ -name "$needed_lib" -type f)
	if [ ! -z $lib ]
	then
		copy_exec "$lib"
	fi
done

copy_exec /etc/ssl/certs/ca-certificates.crt
copy_exec /usr/bin/curl
