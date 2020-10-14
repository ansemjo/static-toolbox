#!/usr/bin/env bash
# compile all binaries and package some metadata for publishing
set -eu

# clean directory
git clean -idx

# compile all binaries
make all
make sources

# calculate checksums
sha256sum $(ls | grep -vE '(build|Makefile|README.md|release.sh)') | tee CHECKSUMS.sha256

# output versions to a text file
for util in $(cd build/ && ls | grep -v '.keys'); do
  case $util in
    busybox) ./$util | head -1;;
    zstd) ./zstd -V | sed 's/ \?\*\+ \?//g';;
    *) ./$util --version | head -1;;
  esac
done | tee VERSIONS
