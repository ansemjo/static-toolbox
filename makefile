# container runtime
RUNTIME := $(shell which podman || which docker)

# base image
IMAGE := alpine:latest

# timestamp for container naming
TIMESTAMP := $(shell date --utc +%F-%H%M%S%Z)

# use a build script to compile a binary
.PHONY: build-%
build-%: build/%
	$(RUNTIME) run -it --name $@-$(TIMESTAMP) \
		-v $(realpath $<):/build.sh:ro \
		-e EXPORTDIR=/export -w /build \
		$(IMAGE) ash /build.sh
	$(RUNTIME) export $@-$(TIMESTAMP) \
		| tar xv --strip-components 1 --wildcards 'export/*'
	$(RUNTIME) rm $@-$(TIMESTAMP)

# generate target list from available scripts
$(shell find build/ -type f -printf '%f\n'):
	make build-$@

# pull latest base image
.PHONY: pull
pull:
	$(RUNTIME) pull $(IMAGE)
