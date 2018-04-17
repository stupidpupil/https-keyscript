#!/bin/sh

correctCsum="$(sha256sum tests/fixtures/unencrypted_keyfile | cut -d " " -f1)"

passphrase="somepassphrase"
url="https://raw.githubusercontent.com/stupidpupil/https-keyscript/master/tests/fixtures/encrypted_keyfile?$(date +%s)"

export CRYPTTAB_KEY="$passphrase:$url"
export CRYPTTAB_NAME="TestDevice"
export CRYPTTAB_TRIED=0
export HTTPSKEYSCRIPT_TESTING=1

keyscriptPath="src/lib/cryptsetup/scripts/wget_or_ask"
if [ ! -f "$keyscriptPath" ]; then
  keyscriptPath="/lib/cryptsetup/scripts/wget_or_ask"
fi

runTest()
{
  output="$(busybox sh "$keyscriptPath" 2>/dev/null)"
  exitCode=$?

  if [ "$exitCode" -ne 0 ];then
    return "$exitCode"
  fi

  csum="$(echo "$output" | sha256sum | cut -d " " -f1)"

  if [ "$csum" != "$correctCsum" ]; then
    echo "Checksum failed for"
    echo "$output"
    return 1
  fi

  return 0
}

cExitCode=0


echo " - First-run test"
runTest
if [ $? -ne 0 ]; then
  echo "   Wrong exit code"
  cExitCode=$((cExitCode+1))
fi

echo ""
echo " - Second-run test"
runTest
if [ $? -ne 0 ]; then
  echo "   Wrong exit code"
  cExitCode=$((cExitCode+1))
fi

echo ""
echo " - Faulty passphrase"
export CRYPTTAB_KEY="$passphrase/a:$url"
runTest
if [ $? -ne 42 ]; then
  echo "   Wrong exit code"
  cExitCode=$((cExitCode+1))
fi

echo ""
echo " - Faulty URL"
export CRYPTTAB_KEY="$passphrase:https://not.a.real.address.example"
runTest
if [ $? -ne 42 ]; then
  echo "   Wrong exit code"
  cExitCode=$((cExitCode+1))
fi

echo ""
echo " - Faulty key file variable"
export CRYPTTAB_KEY="not an acceptable key file"
runTest
if [ $? -ne 42 ]; then
  echo "   Wrong exit code"
  cExitCode=$((cExitCode+1))
fi

echo ""
echo " - CRYPTTAB_TRIED=1"
export CRYPTTAB_KEY="$passphrase:$url"
export CRYPTTAB_TRIED=1
runTest
if [ $? -ne 42 ]; then
  echo "   Wrong exit code"
  cExitCode=$((cExitCode+1))
fi

exit "$cExitCode"