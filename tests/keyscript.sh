#!/bin/sh

correctCsum="$(sha256sum tests/fixtures/unencrypted_keyfile | cut -d " " -f1)"

passphrase="somepassphrase"
url="https://raw.githubusercontent.com/stupidpupil/https-keyscript/master/tests/fixtures/encrypted_keyfile?$(date +%s)"

export CRYPTTAB_KEY="$passphrase:$url"
export CRYPTTAB_NAME="TestDevice"
export CRYPTTAB_TRIED=0
export HTTPSKEYSCRIPT_TESTING=1

# Run the test against the src version of the keyscript if its available
# or else against the installed version (which is useful for the initramfs test)
keyscriptPath="src/lib/cryptsetup/scripts/wget_or_ask"
if [ ! -f "$keyscriptPath" ]; then
  keyscriptPath="/lib/cryptsetup/scripts/wget_or_ask"
fi

cExitCode=0
output=""

runTest ()
{
  stdout="$(busybox sh "$keyscriptPath" 2>/dev/null)"
  exitCode=$?

  csum="$(echo "$stdout" | sha256sum | cut -d " " -f1)"

  if [ "$exitCode" -ne 0 ];then
    return "$exitCode"
  fi
}

# Assertions
assertChecksumIsCorrect ()
{
  printf "   checksum should be correct "

  if [ "$csum" != "$correctCsum" ]; then
    echo "❌"
    echo "$output"

    cExitCode=$((cExitCode+1))
    return 1
  fi

  echo "✓"
}

assertExitedWithoutError ()
{
  printf "   should exit without error "
  if [ "$exitCode" -ne 0 ];then
    echo "❌"
    cExitCode=$((cExitCode+1))
    return 1
  fi

  echo "✓"
}

assertExitedWithAskpass ()
{
  printf "   should fallback to askpass "
  if [ "$exitCode" -ne 42 ] || [ ! -z "$output" ];then
    echo "❌"
    cExitCode=$((cExitCode+1))
    return 1
  fi

  echo "✓"
}


# Testcases

echo "When run with a valid passphrase and URL"
runTest
assertExitedWithoutError
assertChecksumIsCorrect

echo ""
echo "When run *again* a valid passphrase and URL"
runTest
assertExitedWithoutError
assertChecksumIsCorrect

echo ""
echo "When run with a faulty passphrase"
export CRYPTTAB_KEY="$passphrase/a:$url"
runTest
assertExitedWithAskpass

echo ""
echo "When run with a faulty URL"
export CRYPTTAB_KEY="$passphrase:https://not.a.real.address.example"
runTest
assertExitedWithAskpass

echo ""
echo "When run with an unparseable 'key file' field"
export CRYPTTAB_KEY="not an acceptable key file"
runTest
assertExitedWithAskpass

echo ""
echo "When run with CRYPTTAB_TRIED=1"
export CRYPTTAB_KEY="$passphrase:$url"
export CRYPTTAB_TRIED=1
runTest
assertExitedWithAskpass

exit "$cExitCode"