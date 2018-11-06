
# container runtime
RUNTIME := podman
IMAGE := alpine:latest

# fdisk version to build
VERSION := 2.33

.PHONY: fdisk
fdisk: fdisk-$(VERSION)
fdisk-$(VERSION): build.sh
	$(RUNTIME) run --rm -it \
		-v $$PWD:/rundir -w /rundir \
		-e VERSION=$(VERSION) \
		$(IMAGE) ash build.sh

.PHONY: pull
pull:
	$(RUNTIME) pull $(IMAGE)
