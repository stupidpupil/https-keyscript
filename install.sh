#!/bin/sh
cp etc/initramfs-tools/hooks/*.sh /etc/initramfs-tools/hooks/
chmod +x /etc/initramfs-tools/hooks/*.sh

cp "etc/initramfs-tools/scripts/init-premount/networking.sh" "/etc/initramfs-tools/scripts/init-premount/networking.sh"
chmod +x "/etc/initramfs-tools/scripts/init-premount/networking.sh"

cp "lib/cryptsetup/scripts/wget_or_ask" "/lib/cryptsetup/scripts/wget_or_ask"