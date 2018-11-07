
# container runtime
RUNTIME := podman
IMAGE := alpine:latest

# fdisk version to build
VERSION := 2.33

.PHONY: build
build: fdisk-$(VERSION) sfdisk-$(VERSION)
fdisk-% sfdisk-%: build.sh
	$(RUNTIME) run --rm -it \
		-v $$PWD:/rundir -w /rundir \
		-e VERSION=$(VERSION) \
		$(IMAGE) ash build.sh

.PHONY: pull
pull:
	$(RUNTIME) pull $(IMAGE)
