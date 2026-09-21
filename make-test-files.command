#!/bin/sh
# Copyright (C) 2026 Aron Sommer. See LICENSE file for full license details.

# Creates the files that README.md in this folder tests with, in a folder
# named "files" next to this script. Double-click it, or run it from Terminal:
#
#   sh make-test-files.command
#
# An existing "files" folder is removed first. Everything is random bytes;
# only the sizes matter.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
dest=$here/files
rm -rf "$dest"
mkdir "$dest"
cd "$dest"

echo "keep me" > keep-me.txt

# 1 MiB minus 12 bytes: with the 12-byte MTP header this is an exact multiple
# of the 512-byte USB packet, the case that once failed every pull.
head -c 1048564 /dev/urandom > zlp-test.bin

# 5 GiB: over the 4 GiB that MTP's 32-bit size field can hold, which the app
# handles with a separate path, and long enough to watch the progress.
head -c 5368709120 /dev/urandom > big-push-test.bin
head -c 300000 /dev/urandom > replace-test.bin
head -c 200000 /dev/urandom > Case-Test.bin
cp "$here/heic-test.heic" heic-test.heic

# 4000 GiB that takes no disk space, for the copy that must be refused.
mkfile -n 4000g too-big.bin

# Two folders with 20,000 empty files each, so a delete takes a few seconds.
mkdir delete-test delete-test/folder-A delete-test/folder-B
i=0
while [ $i -lt 20000 ]; do
  : > "delete-test/folder-A/a-$i.txt"
  : > "delete-test/folder-B/b-$i.txt"
  i=$((i + 1))
done

echo
echo "Test files are in $dest"
echo "Checksum of big-push-test.bin, needed for test 3:"
shasum -a 256 big-push-test.bin | cut -c1-64
echo
echo "You can close this window."
