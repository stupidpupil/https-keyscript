#!/bin/sh

correctCsum="$(sha256sum tests/fixtures/unencrypted_keyfile | cut -d " " -f1)"

passphrase="somepassphrase"
url="https://raw.githubusercontent.com/stupidpupil/https-keyscript/master/tests/fixtures/encrypted_keyfile?$(date +%s)"

export CRYPTTAB_KEY="$passphrase:$url"
export CRYPTTAB_NAME="TestDevice"
export CRYPTTAB_TRIED=0
export TESTING=1

runTest()
{
  output="$(busybox sh lib/cryptsetup/scripts/wget_or_ask)"
  exitCode=$?

  if [ "$exitCode" -ne 0 ];then
    return "$exitCode"
  fi

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

export CRYPTTAB_KEY="$passphrase/a:$url"
runTest
if [ $? -ne 42 ]; then
  exit 1
fi

export CRYPTTAB_KEY="$passphrase:https://not.a.real.address.example"
runTest
if [ $? -ne 42 ]; then
  exit 1
fi