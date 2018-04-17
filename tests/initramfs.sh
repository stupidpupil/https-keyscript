#!/bin/sh

INITRAMFS_ROOT="tmp/initramfs"

if [ -d "$INITRAMFS_ROOT" ]; then
  echo "$INITRAMFS_ROOT already exists!"
  exit 1
fi

# This script builds an initramfs and then runs the keyscript.sh tests within it.
# In this way, it tests that that initramfs *hooks* work as intended.

workingDir="$(mkinitramfs -k -o "$INITRAMFS_ROOT-$(uname -r)" | cut -d " " -f 4 | cut -d "," -f 1)"
echo "initramfs built"

cp -r "$workingDir" "$INITRAMFS_ROOT"
rm -r /var/tmp/mkinitramfs*

# We don't actually want the image
rm "$INITRAMFS_ROOT-$(uname -r)" 

# By default, initramfs' busybox doesn't include sha256sum
cp "/bin/busybox" "$INITRAMFS_ROOT/bin/sha256sum"

mkdir -p "$INITRAMFS_ROOT/lib/cryptsetup/scripts"
cp "src/lib/cryptsetup/scripts/wget_or_ask" "$INITRAMFS_ROOT/lib/cryptsetup/scripts/wget_or_ask"

cp -r "tests/" "$INITRAMFS_ROOT/tests/"

echo 'nameserver 84.200.69.80' > "$INITRAMFS_ROOT/etc/resolv.conf"

if [ ! -d "$INITRAMFS_ROOT/dev/" ]; then
  mkdir "$INITRAMFS_ROOT/dev/"
  mount -o bind /dev "$INITRAMFS_ROOT/dev/"
fi

chroot "$INITRAMFS_ROOT" busybox sh "/tests/keyscript.sh"
exitCode=$?

sleep 1

umount "$INITRAMFS_ROOT/dev"

if [ $? -eq 0 ]; then 
  rm -r "$INITRAMFS_ROOT"
fi

exit "$exitCode"