#!/bin/sh

# This script builds an initramfs and then runs the keyscript.sh tests within it.
# In this way, it tests that that initramfs *hooks* work as intended,
# and that the keyscript works in the reduced environment of the initramfs.

if [ -z "$TEST_INSTALLED" ]; then
  if (dpkg -s https-keyscript | grep "Status:.*installed" > /dev/null); then
    echo "Warning: https-keyscript is installed"
  fi 
else
  if ! (dpkg -s https-keyscript | grep "Status:.*installed" > /dev/null); then
    echo "https-keyscript is not installed"
    exit 1
  fi
fi

#
# Build the initramfs
#

INITRAMFS_ROOT="tmp/initramfs"

if [ -d "$INITRAMFS_ROOT" ]; then
  echo "$INITRAMFS_ROOT already exists!"
  exit 1
fi

mkdir "$INITRAMFS_ROOT"
mkinitramfs -c gzip -o "$INITRAMFS_ROOT/initramfs.gz"
(cd "$INITRAMFS_ROOT"; zcat "initramfs.gz" | cpio -idmv 2>/dev/null)

echo "initramfs built"

#
# Run the initramfs hooks and install the keyscript, if necessary
#

if [ -z "$TEST_INSTALLED" ]; then
  DESTDIR="$(pwd)/$INITRAMFS_ROOT"
  export DESTDIR
  for f in src/etc/initramfs-tools/hooks/*.sh
  do
    bash "$f"
  done

  echo "initramfs hooks run"

  mkdir -p "$INITRAMFS_ROOT/lib/cryptsetup/scripts"
  cp "src/lib/cryptsetup/scripts/wget_or_ask" "$INITRAMFS_ROOT/lib/cryptsetup/scripts/wget_or_ask"

  echo "keyscript copied"
else

  # If there's no reference to the keyscript in the crypttab it won't be installed in the initramfs
  if ! [ -x "$INITRAMFS_ROOT/lib/cryptsetup/scripts/wget_or_ask" ]; then
    mkdir -p "$INITRAMFS_ROOT/lib/cryptsetup/scripts"
    cp "/lib/cryptsetup/scripts/wget_or_ask" "$INITRAMFS_ROOT/lib/cryptsetup/scripts/wget_or_ask"
  fi

fi

#
# Setup the initramfs environment for testing
#

# By default, initramfs' busybox doesn't include sha256sum
cp "/bin/busybox" "$INITRAMFS_ROOT/bin/sha256sum"


echo 'nameserver 84.200.69.80' > "$INITRAMFS_ROOT/etc/resolv.conf"

if [ ! -d "$INITRAMFS_ROOT/dev/" ]; then
  mkdir "$INITRAMFS_ROOT/dev/"
  mount -o bind /dev "$INITRAMFS_ROOT/dev/"
fi


cp -r "tests/" "$INITRAMFS_ROOT/tests/"
mkdir "$INITRAMFS_ROOT/tmp"


chroot "$INITRAMFS_ROOT" busybox sh "/tests/keyscript.sh"
exitCode=$?

sleep 1

#
# Remove the initramfs
#

umount "$INITRAMFS_ROOT/dev"

if [ $? -eq 0 ]; then 
  rm -r "$INITRAMFS_ROOT"
fi

exit "$exitCode"