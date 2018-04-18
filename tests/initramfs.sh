#!/bin/sh

# This script builds an initramfs and then runs the keyscript.sh tests within it.
# In this way, it tests that that initramfs *hooks* work as intended,
# and that the keyscript works in the reduced environment of the initramfs.

# It tests the *installed* version of the hooks and
# the development version of the keyscript.

if ! (dpkg -s https-keyscript | grep "Status:.*installed" > /dev/null); then
  echo "https-keyscript is not installed"
  exit 1
fi

INITRAMFS_ROOT="tmp/initramfs"

if [ -d "$INITRAMFS_ROOT" ]; then
  echo "$INITRAMFS_ROOT already exists!"
  exit 1
fi

mkdir "$INITRAMFS_ROOT"
mkinitramfs -c gzip -o "$INITRAMFS_ROOT/initramfs.gz"
(cd "$INITRAMFS_ROOT"; zcat "initramfs.gz" | cpio -idmv 2>/dev/null)

echo "initramfs built"

# We don't actually want the image

# By default, initramfs' busybox doesn't include sha256sum
cp "/bin/busybox" "$INITRAMFS_ROOT/bin/sha256sum"

mkdir -p "$INITRAMFS_ROOT/lib/cryptsetup/scripts"
cp "src/lib/cryptsetup/scripts/wget_or_ask" "$INITRAMFS_ROOT/lib/cryptsetup/scripts/wget_or_ask"

cp -r "tests/" "$INITRAMFS_ROOT/tests/"
mkdir "$INITRAMFS_ROOT/tmp"

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