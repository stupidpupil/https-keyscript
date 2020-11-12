#!/bin/sh
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


. /usr/share/initramfs-tools/hook-functions

# include a module dynamically loaded by a library
# $1 - directory to search for the library (may be / to search all of initramfs)
# $2 - library to search for
# $3 - module to include relative to library found
# example: lib_module /lib 'libc.so.*' 'libnss_dns.so.*'
#	   lib_module /usr/lib 'libpango-*.so.*' 'pango/*/modules/pango-basic-fc.so'
# Does not handle spaces in directory or module names and .. in module names.
# Source: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=636697
lib_module()
{
    dir="$1"
    lib="$2"
    mod="$3"
    { find "${DESTDIR}${dir}" -name "${lib}" -type l
      find "${DESTDIR}${dir}" -name "${lib}" -type f ; } | { while read i ; do
        lib_dir="$(dirname "$i" | sed -e "s ^${DESTDIR}  " )"
        ls "${lib_dir}"/"${mod}" | { while read j ; do
        copy_exec "$j"
        done ; }
    done ; }
}

# sys-libs/glibc loads additional libraries reqired for domain name lookups dynamically,
# they doesn't get picked up by initramfs installation scripts. Let's include them manually.
# For more information, see https://wiki.gentoo.org/wiki/Custom_Initramfs#DNS
lib_module /lib 'libc.so.*' 'libnss_dns.*'
lib_module /lib 'libc.so.*' 'libnss_files.so.*'
lib_module /lib 'libc.so.*' 'libresolv.so.*'
lib_module /usr/lib 'libc.so.*' 'libnss_dns.*'
lib_module /usr/lib 'libc.so.*' 'libnss_files.so.*'
lib_module /usr/lib 'libc.so.*' 'libresolv.so.*'
