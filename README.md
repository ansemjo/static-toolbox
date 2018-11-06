# static fdisk binary

Requirements:

* container runtime: `podman` or `docker`
* `make`

## compilation

Pull the latest [alpine](https://hub.docker.com/_/alpine/) image:

    make pull

Compile `fdisk`:

    make fdisk

