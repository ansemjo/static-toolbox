
# container image
IMAGE := alpine:latest

# container runtime
RUNTIME := podman

fdisk: build.sh
	$(RUNTIME) run --rm -it -v $$PWD:/rundir -w /rundir $(IMAGE) ash build.sh

.PHONY: release
release: fdisk
	version=$$(./$< --version | sed -n 's/.* \([0-9.]*\)$$/\1/'p) && \
	cp -vf $< $<-$$version

.PHONY: pull
pull:
	$(RUNTIME) pull $(IMAGE)
