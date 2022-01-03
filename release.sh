#!/usr/bin/env bash
# compile all binaries and package some metadata for publishing
set -eu

# (re)compile all binaries
rm -rf compiled/
make all
make sources

# calculate checksums
cd compiled/
sha256sum * > CHECKSUMS

# output versions to a text file
for util in $(cd ../build/ && ls | grep -v '.keys'); do
  version=$(case $util in
    busybox) ./$util | head -1;;
    zstd) ./zstd -V | sed 's/ \?\*\+ \?//g';;
    vim) ./vim --version | head -2 | tr "\n" " ";;
    *) ./$util --version | head -1;;
  esac)
  printf '%s\t%s\n' "$util" "$version"
done | tee VERSIONS
