# generate target list from available scripts
TARGETS = $(shell find -L build/ -type f ! -name '*.keys' -printf '%f\n')

# group: build all available targets
.PHONY: all
all: $(addprefix build-,$(TARGETS))

# group: export all build sources
.PHONY: sources
sources: $(addprefix sources-,$(TARGETS))

# clean up built targets
.PHONY: clean
clean:
	rm -fv $(addsuffix .tar.xz,$(TARGETS))
	rm -fv $(TARGETS)

# build a single target
$(TARGETS):
	make build-$@

# export a buildstage sources tarball
$(addsuffix .tar.xz,$(TARGETS)):
	make sources-$(subst .tar.xz,,$@)

# use docker with buildkit to build artifacts
.PHONY: build-%
build-%: build/%
	DOCKER_BUILDKIT=1 docker build -f $< build/ -o type=local,dest=./

# export the finished build stage per target as source distribution
.PHONY: sources-%
sources-%: build/%
	DOCKER_BUILDKIT=1 docker build -f $< build/ -o type=tar,dest=- --target build | xz > $*.tar.xz
