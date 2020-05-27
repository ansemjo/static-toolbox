# STATIC TOOLBOX

Build scripts to compile various static binaries inside a container.

## REQUIREMENTS

* Docker with `DOCKER_BUILDKIT=1` support, i.e. 19.03+
* GNU `make`, `find`

## USAGE

Available build targets are given by the Dockerfiles in [`build/`](build/):

* `make fdisk`
* `make gpg`
* `make git`
* `make make`
* `make zstd`
* `make busybox`
* `make curl`

## ADD YOUR OWN

Add your own build scripts in `build/`:

- add a Dockerfile named like the binary you want to compile
- use seperate `RUN` commands for better caching of steps
- the `build/` directory will be the context, so you may add scripts and `COPY` them
- use a final `FROM scratch` stage and only copy the output binary into this rootfs
