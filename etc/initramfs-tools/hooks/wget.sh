#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/wget

LIB_PAT="\".*/lib/.*\""
STRACED_LIBS=$(strace /usr/bin/wget --no-iri -q -O - https://www.debian.org 2>&1 | grep -o "$LIB_PAT")

echo "$STRACED_LIBS" | while IFS= read -r line
  do
  # Strip the quotation marks
  line="${line%\"}"
  line="${line#\"}"

  if [ -f "$line" ]
  then
    copy_exec "$line"
  fi
done

copy_exec /etc/ssl/certs/ca-certificates.crt
