# STATIC TOOLBOX

[![compile release](https://github.com/ansemjo/static-toolbox/actions/workflows/compile.yml/badge.svg)](https://github.com/ansemjo/static-toolbox/actions/workflows/compile.yml)

Dockerfile based build scripts to compile various static binaries of useful tools.

I often found myself in shells where I needed a newer version of a particular tool, which was not available through the package manager .. or the system even lacked a package manager to begin with. In that case it can be helpful to have portable binaries that you can just copy to the target without worrying about library dependencies and be able to use it right away.

The scripts placed in `build/` are Dockerfiles that must be built with the `builtkit` frontend. However, the end result is not a container image but a built binary that is saved in the `compiled/` directory, which you can then copy where-ever you like. The fact that everything is built inside a container means that you do not need to provide any specific build environment – besides an installation of Docker.

Using the `buildx` plugin you can even compile binaries for another platform by starting a multi-platform capable builder instance and adding a `--platform` argument.

## DOWNLOAD

The binaries are compiled in a GitHub workflow regularly. These precompiled binaries and all the downloaded sources that were used can be found in the [action artifacts](https://github.com/ansemjo/static-toolbox/actions/workflows/compile.yml): click on a run and download the corresponding archive form the build artifacts.

## REQUIREMENTS

* Docker with `buildkit` support / `buildx` plugin, i.e. at least 19.03
* `make`, `find`, `sed`

## USAGE

Available build targets are given by the Dockerfiles in [`build/`](build/):

* `make busybox`
* `make curl`
* `make fdisk` (includes `blkid`, `losetup`, `(u)mount`, `nsenter` & `unshare`)
* `make git`
* `make gpg`
* `make make`
* `make openssl`
* `make rsync`
* `make vim`
* `make zstd`

The output will be placed in `compiled/` in a subdirectory matching your native platform.

Some of the scripts use GPG signatures for which the trusted signing keys are stored in `build/*.keys` files and are imported before checking the downloaded sources.

### OTHER PLATFORMS

First, [setup `buildx` for multi-platform building](https://docs.docker.com/build/buildx/multiplatform-images/). Let's assume you already ran `docker buildx create --use ...` etc. and your currently used build server is multi-platform capable. Then you should be able to use the `--platform` argument with `docker build` invocations, too.

The Makefile contains targets for most available platforms. In order to build `fdisk` for `linux/arm64` you'd use the `compiled/linux-arm64/fdisk/` target:

```bash
make compiled/linux-arm64/fdisk/
```

I haven't actually tested all combinations yet, because it takes a *very long time* under emulation. Available target platforms are:

* `linux-amd64`
* `linux-arm64`
* `linux-armv7`
* `linux-armv6`
* `linux-riscv64`
* `linux-s390x`
* `linux-386`

### MANUAL BUILDS

If you want to add some other arguments to `docker build` or want to create your own script, this is the command the gets executed in the example above:

```bash
DOCKER_BUILDKIT=1 docker build -f build/fdisk build/
  --target binary -o type=local,dest=compiled/linux-arm64/fdisk/ \
  --platform linux/arm64
```

## ADD YOUR OWN

Add your own build scripts in `build/`:

- add a Dockerfile named like the binary you want to compile
- use seperate `RUN` commands for better caching of steps
- the `build/` directory will be the context, so you may add scripts and `COPY` them
- use a final `FROM scratch AS binary` stage and only copy the output binary into this rootfs
