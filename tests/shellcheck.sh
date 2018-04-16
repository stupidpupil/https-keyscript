#!/bin/sh
shellcheck -s sh --exclude=SC2181,SC2162 lib/cryptsetup/scripts/wget_or_ask
