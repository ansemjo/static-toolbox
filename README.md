# static gpg binary

Requirements:

* Docker
* GNU make

## compilation

Pull the latest alpine image:

    make pull

Compile `gpg`:

    make gpg
    ./gpg --version

## configuration / updates

The compiled packages are all defined in [build.sh](build.sh) and the
configuration options for gnupg are given at the very bottom of the file.

If you want to use updated packages, you'll need to find and replace the
download links in `build.sh`. Find updates here:

* [GnuPG Downloads](https://gnupg.org/download/)
* [SQLite Downloads](https://www.sqlite.org/download.html?)
  (use the `autoconf` packages)
