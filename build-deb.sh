#!/usr/bin/fakeroot /bin/sh

chmod u=rwx src/etc/initramfs-tools/hooks/*.sh
chmod u=rwx src/etc/initramfs-tools/scripts/init-premount/*.sh
chmod u=rwx src/lib/cryptsetup/scripts/wget_or_ask

dpkg-deb -b src https-keyscript.deb