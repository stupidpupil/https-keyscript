#!/bin/sh

correctCsum="$(sha256sum tests/fixtures/unencrypted_keyfile | cut -d " " -f1)"

passphrase="somepassphrase"
url="https://raw.githubusercontent.com/stupidpupil/https-keyscript/master/tests/fixtures/encrypted_keyfile?$(date +%s)"

export CRYPTTAB_KEY="$passphrase:$url"
export CRYPTTAB_NAME="TestDevice"
export CRYPTTAB_TRIED=0

runTest()
{
  output="$(busybox sh lib/cryptsetup/scripts/wget_or_ask)"
  csum="$(echo "$output" | sha256sum | cut -d " " -f1)"

  if [ "$csum" != "$correctCsum" ]; then
    return 1
  fi

  return 0
}

runTest
if [ $? -ne 0 ]; then
  exit 1
fi

runTest
if [ $? -ne 0 ]; then
  exit 1
fi