# build all available targets
.PHONY: all
all: $(TARGETS)

# generate target list from available scripts
TARGETS = $(shell find -L build/ -type f ! -name '*.keys' -printf '%f\n')
$(TARGETS):
	make build-$@

# use docker with buildkit to build artifacts
.PHONY: build-%
build-%: build/%
	DOCKER_BUILDKIT=1 docker build -f $< build/ -o type=local,dest=./
