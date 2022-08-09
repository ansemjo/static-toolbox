# generate target list from available scripts
TARGETS = $(shell find -L build/ -type f ! -name '*.keys' -printf '%f\n')

# group: build all available targets
.PHONY: all
all: $(addprefix compiled/,$(TARGETS))

# group: export all build sources
.PHONY: sources
sources: $(addsuffix -sources,$(TARGETS))

# clean up built targets
.PHONY: clean
clean:
	rm -fv $(addsuffix -sources.tar,$(TARGETS))
	rm -fv $(TARGETS)

# create the output directory
compiled/:
	mkdir -p $@

# build a single target
$(TARGETS):
	make compiled/$@

# use docker with buildkit to build artifacts
compiled/%: build/% compiled/
	DOCKER_BUILDKIT=1 docker build -f $< build/ $(BUILDARGS) \
		-o type=local,dest=compiled/ --target binary

# list of source targets for completion
$(addsuffix -sources,$(TARGETS)):
	make compiled/$@.tar

# export downloaded sources from build stage
compiled/%-sources.tar: build/% compiled/
	DOCKER_BUILDKIT=1 docker build -f $< build/ $(BUILDARGS) \
		-o type=tar,dest=- --target sources > compiled/$*.tar
