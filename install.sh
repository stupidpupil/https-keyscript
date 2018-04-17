#!/bin/sh
cp src/etc/initramfs-tools/hooks/*.sh /etc/initramfs-tools/hooks/
chmod +x /etc/initramfs-tools/hooks/*.sh

cp "src/etc/initramfs-tools/scripts/init-premount/networking.sh" "/etc/initramfs-tools/scripts/init-premount/networking.sh"
chmod +x "/etc/initramfs-tools/scripts/init-premount/networking.sh"

cp "src/ib/cryptsetup/scripts/wget_or_ask" "/lib/cryptsetup/scripts/wget_or_ask"