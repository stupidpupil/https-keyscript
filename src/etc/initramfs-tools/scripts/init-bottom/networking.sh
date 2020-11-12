#!/bin/sh

PREREQ=""

prereqs() {
	echo "$PREREQ"
}

case "$1" in
	prereqs)
		prereqs
		exit 0
	;;
esac

. /scripts/functions

# Bring all interfaces down or set variable IFACE to none
IFDOWN=*

if [ "$BOOT" != nfs ] && [ "$IFDOWN" != none ]; then
    for IFACE in /sys/class/net/$IFDOWN; do
        [ -e "$IFACE" ] || continue
        IFACE="${IFACE#/sys/class/net/}"
        log_begin_msg "Bringing down $IFACE"
        ip link    set   dev "$IFACE" down
        ip address flush dev "$IFACE"
        ip route   flush dev "$IFACE"
	log_end_msg
    done
fi
