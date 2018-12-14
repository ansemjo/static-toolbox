# container runtime
RUNTIME := $(shell which podman || which docker)

# timestamp for container naming
TIMESTAMP := $(shell date --utc +%F-%H%M%S%Z)

# use a build script to compile a binary
.PHONY: build-%
build-%: build/%
	$(RUNTIME) run -it --name $@-$(TIMESTAMP) \
		-v $(realpath $<):/build.sh:ro \
		-e EXPORTDIR=/export -w /build \
		-e LDFLAGS="-Wl,-z,now -Wl,-z,relro -static -s" \
		-e CFLAGS="-fPIC -pie -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -static -s" \
		--tmpfs /tmp \
		$(shell awk '/FROM:/{ print $3 }' $<) sh /build.sh
	$(RUNTIME) export $@-$(TIMESTAMP) \
		| tar xv --strip-components 1 --wildcards 'export/*'
	$(RUNTIME) rm $@-$(TIMESTAMP)

# generate target list from available scripts
$(shell find -L build/ -type f -printf '%f\n'):
	make build-$@
