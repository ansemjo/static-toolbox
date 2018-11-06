#!/usr/bin/env ash

set -e

# save original rundir
RUNDIR=$PWD

# install requirements
apk add --no-cache \
  gnupg \
  build-base \
  linux-headers

# switch to build directory
mkdir -p /build
cd /build

# download packages
download() {
  mirror="https://mirrors.edge.kernel.org/pub/linux"
  cat=$1; pkg=$2; ver=$3;
  get() {
    rm -f "$(basename "$1")"
    wget "$1"
  }
  get "$mirror/$cat/$pkg/v$ver/$pkg-$ver.tar.gz"
  get "$mirror/$cat/$pkg/v$ver/$pkg-$ver.tar.sign"
}

# download files
download utils util-linux 2.33

# import gpg keys and trust them
gpg --import <<"GPGKEYS"
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
oe7UZowk
=a4fN
-----END PGP PUBLIC KEY BLOCK-----
GPGKEYS

# set ownertrust to ultimate
printf '%s:6:\n' \
  B0C64D14301CC6EFAEDF60E4E4B71D5EEC39C284 \
  | gpg --import-ownertrust

# verify signatures
for g in *.gz; do
  gunzip -f $g
done
for s in *.sign; do
  gpg --verify "$s"
  rm -f "$s"
done

# extract packages
for t in *.tar; do
  tar xf "$t"
done

# compile with config options
compile() {
  export CFLAGS="-static -s"
  export LDFLAGS="-static -s -pie"
  package=$1; target=$2; shift 2;
  (cd "$package"* && ./configure $@ && make -j$(nproc) $target)
}

# compile binary
export CFLAGS="-static -s"
export LDFLAGS="-static -s -pie"
cd util-linux*
./configure \
  --enable-static \
  --enable-static-programs=fdisk \
  --disable-pylibmount \
  --without-python
make -j$(nproc) fdisk.static

# copy binary to output
cp -vf fdisk.static $RUNDIR/fdisk
