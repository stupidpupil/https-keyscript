#!/bin/sh
SC_EXCLUDE="SC2181,SC2162,SC1091,SC2129"

shellcheck -s sh --exclude="$SC_EXCLUDE" src/lib/cryptsetup/scripts/fetch_or_ask \
  src/etc/initramfs-tools/hooks/*.sh \
  src/etc/initramfs-tools/scripts/init-premount/networking.sh
