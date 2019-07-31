# STATIC TOOLBOX

Build scripts to compile various static binaries inside a container.

## REQUIREMENTS

* [`img`](https://github.com/genuinetools/img/) - standalone, daemon-less,
  unprivileged container image builder (minimum 4f50859d982711827f6f93fe992b66b9a15c9166)
* GNU `make`, `find`

## USAGE

Available build targets are given by the Dockerfiles in [`build/`](build/):

    make fdisk sfdisk
    make gpg
    make git

## ADD YOUR OWN

Add your own build scripts in `build/`:

- add a Dockerfile named like the binary you want to compile
- use seperate `RUN` commands for better caching of steps
- the `build/` directory will be the context, so you may add scripts and `COPY` them
- use a final `FROM scratch` stage and only copy the output binary into this rootfs
