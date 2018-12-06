# STATIC TOOLBOX

Build scripts to compile various static binaries inside a container.

## REQUIREMENTS

* container runtime: [`podman`](https://podman.io/) or
  [`docker`](https://www.docker.com/)
* GNU `make`, `find`, `tar`

## USAGE

Pull the latest [base image](https://hub.docker.com/_/alpine/):

    make pull

Available build targets are given by the scripts in [`build/`](build/):

    make fdisk
    make gpg

## ADD YOUR OWN

Add your own build scripts in `build/`:

- you're running inside a vanilla Alpine container
- only the script itself is mounted in the container, supply everything inline
- the working directory is `/build`
- output files should be placed in `$EXPORTDIR/`
- *ideally, the script is named after the compiled binary*