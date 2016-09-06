#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/wget

copy_exec /usr/lib/i386-linux-gnu/libnettle.so.4
copy_exec /usr/lib/i386-linux-gnu/libgnutls-deb0.so.28
copy_exec /lib/i386-linux-gnu/libz.so.1
copy_exec /usr/lib/i386-linux-gnu/libpsl.so.0
copy_exec /usr/lib/i386-linux-gnu/libidn.so.11
copy_exec /lib/i386-linux-gnu/libuuid.so.1
copy_exec /lib/i386-linux-gnu/libc.so.6
copy_exec /usr/lib/i386-linux-gnu/libp11-kit.so.0
copy_exec /usr/lib/i386-linux-gnu/libtasn1.so.6
copy_exec /usr/lib/i386-linux-gnu/libhogweed.so.2
copy_exec /usr/lib/i386-linux-gnu/libgmp.so.10
copy_exec /usr/lib/i386-linux-gnu/libicuuc.so.52
copy_exec /usr/lib/i386-linux-gnu/libffi.so.6
copy_exec /lib/i386-linux-gnu/libdl.so.2
copy_exec /lib/i386-linux-gnu/libpthread.so.0
copy_exec /usr/lib/i386-linux-gnu/libicudata.so.52
copy_exec /usr/lib/i386-linux-gnu/libstdc++.so.6
copy_exec /lib/i386-linux-gnu/libm.so.6
copy_exec /lib/i386-linux-gnu/libgcc_s.so.1
copy_exec /usr/lib/locale/locale-archive
copy_exec /usr/lib/i386-linux-gnu/gconv/gconv-modules.cache
copy_exec /lib/i386-linux-gnu/libnss_files.so.2
copy_exec /lib/i386-linux-gnu/libnss_dns.so.2
copy_exec /lib/i386-linux-gnu/libresolv.so.2

copy_exec /etc/ssl/certs/ca-certificates.crt