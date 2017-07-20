#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/wget

ARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH)

# A mindlessly compiled list produced by running `strace wget …`
# to ensure DNS and SSL support
copy_exec /lib/$ARCH/libc.so.6
copy_exec /lib/$ARCH/libdl.so.2
copy_exec /lib/$ARCH/libgcc_s.so.1
copy_exec /lib/$ARCH/libm.so.6
copy_exec /lib/$ARCH/libnss_dns.so.2
copy_exec /lib/$ARCH/libnss_files.so.2
copy_exec /lib/$ARCH/libpthread.so.0
copy_exec /lib/$ARCH/libresolv.so.2
copy_exec /lib/$ARCH/libuuid.so.1
copy_exec /lib/$ARCH/libz.so.1

copy_exec /usr/lib/$ARCH/libffi.so.6
copy_exec /usr/lib/$ARCH/libgmp.so.10
copy_exec /usr/lib/$ARCH/libgnutls-deb0.so.28
copy_exec /usr/lib/$ARCH/libhogweed.so.2
copy_exec /usr/lib/$ARCH/libicudata.so.52
copy_exec /usr/lib/$ARCH/libicuuc.so.52
copy_exec /usr/lib/$ARCH/libidn.so.11
copy_exec /usr/lib/$ARCH/libnettle.so.4
copy_exec /usr/lib/$ARCH/libp11-kit.so.0
copy_exec /usr/lib/$ARCH/libpsl.so.0
copy_exec /usr/lib/$ARCH/libstdc++.so.6
copy_exec /usr/lib/$ARCH/libtasn1.so.6

copy_exec /usr/lib/$ARCH/gconv/gconv-modules.cache
copy_exec /usr/lib/locale/locale-archive

# To allow the HTTPS cert to be verified
copy_exec /etc/ssl/certs/ca-certificates.crt
