#!/usr/bin/env ash

set -e

# install requirements
apk add --no-cache zlib-dev gnupg build-base

# switch to build directory
mkdir /build
cd /build

download() {
  base="https://gnupg.org/ftp/gcrypt"
  file=$1
  wget "$base/$file" "$base/$file.sig"
}

# download files
download "/gnupg/gnupg-2.2.10.tar.bz2"
download "/libgpg-error/libgpg-error-1.32.tar.bz2"
download "/libgcrypt/libgcrypt-1.8.3.tar.bz2"
download "/libksba/libksba-1.3.5.tar.bz2"
download "/libassuan/libassuan-2.5.1.tar.bz2"
download "/ntbtls/ntbtls-0.1.2.tar.bz2"
download "/npth/npth-1.6.tar.bz2"

# import gpg keys and trust them
gpg --import <<"GPGKEYS"
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=jIGA
-----END PGP PUBLIC KEY BLOCK-----
GPGKEYS

printf '%s:6:\n' \
  D8692123C4065DEA5E0F3AB5249B39D24F25E3B6 \
  031EC2536E580D8EA286A9F22071B08A33BD3F06 \
  | gpg --import-ownertrust

# verify signatures
for s in *.sig; do
  gpg --verify "$s"
  rm -f "$s"
done

# export packages
for t in *.tar*; do
  tar xf "$t"
done

# compile
compile() {
  LDFLAGS="-static -pie"
  package=$1; shift 1;
  (cd "$package" && ./configure $@ && make LDFLAGS="$LDFLAGS" && make install)
}

compile "libgpg-error-1.32"
compile "libassuan-2.5.1"
compile "libgcrypt-1.8.3"
compile "libksba-1.3.5"
compile "npth-1.6"
compile "ntbtls-0.1.2"
compile "gnupg-2.2.10"
