#!/bin/sh -e
PREREQS=""
case $1 in
        prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/wget

strace_and_copy_libs_for_url ()
{
  LIB_PAT="\".*/lib/.*\""
  STRACED_LIBS=$(strace /usr/bin/wget --no-iri -q -O - "$1" 2>&1 | grep -o "$LIB_PAT")

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
}

strace_and_copy_libs_for_url "https://www.debian.org"
strace_and_copy_libs_for_url "https://raw.githubusercontent.com/stupidpupil/https-keyscript/master/tests/fixtures/encrypted_keyfile"

copy_exec /etc/ssl/certs/ca-certificates.crt
