# generate target list from available scripts
TARGETS = $(shell find -L build/ -type f ! -name '*.keys' -printf '%f\n')

# group: build all available targets
.PHONY: all
all: $(addprefix build-,$(TARGETS))

# group: export all build sources
.PHONY: sources
sources: $(addsuffix -sources.tar,$(TARGETS))

# clean up built targets
.PHONY: clean
clean:
	rm -fv $(addsuffix -sources.tar,$(TARGETS))
	rm -fv $(TARGETS)

# build a single target
$(TARGETS):
	make build-$@

# use docker with buildkit to build artifacts
.PHONY: build-%
build-%: build/%
	DOCKER_BUILDKIT=1 docker build -f $< build/ \
		-o type=local,dest=./ --target binary

# export downloaded sources from build stage
%-sources.tar: build/%
	DOCKER_BUILDKIT=1 docker build -f $< build/ \
		-o type=tar,dest=- --target sources > $*.tar
