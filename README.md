# STATIC TOOLBOX

Dockerfile based build scripts to compile various static binaries of useful tools.

I often found myself in shells where I needed a newer version of a particular tool,
which was not available through the package manager .. or the system even lacked a
package manager to begin with. In that case it can be helpful to have portable
binaries that you can just copy to the target without worrying about library
dependencies and be able to use it right away. This does not account for cross-compilation
for a different architecture of course but most of the systems in question were
`x86_64`, anyway.

The scripts placed in `build/` are Dockerfiles that are built with the `builtkit`
frontend. However, the end result is not a container image but a built binary that
is saved in the base directory, which you can then copy where-ever you like.
The fact that everything is built inside a container means that you do not need to
provide any specific build environment – besides an installation of Docker.

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

Some of the scripts use GPG signatures for which the trusted signing keys are stored
in `build/*.keys` files and are imported before checking the downloaded sources.

## ADD YOUR OWN

Add your own build scripts in `build/`:

- add a Dockerfile named like the binary you want to compile
- use seperate `RUN` commands for better caching of steps
- the `build/` directory will be the context, so you may add scripts and `COPY` them
- use a final `FROM scratch` stage and only copy the output binary into this rootfs
