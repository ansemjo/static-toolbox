# STATIC TOOLBOX

Build scripts to compile various static binaries inside a container.

## REQUIREMENTS

* container runtime: [`podman`](https://podman.io/) or
  [`docker`](https://www.docker.com/)
* GNU `awk`, `find`, `make`, `tar`

## USAGE

Available build targets are given by the scripts in [`build/`](build/):

    make fdisk sfdisk
    make gpg
    make git

## ADD YOUR OWN

Add your own build scripts in `build/`:

- define your base image with a comment: `# FROM: <baseimage>`
- only the script itself is mounted in the container, supply everything inline
- the working directory is `/build`
- output files should be placed in `$EXPORTDIR/`
- *ideally, the script is named after the compiled binary*
