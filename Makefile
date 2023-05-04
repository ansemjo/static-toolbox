# generate target list from available dockerfiles
TARGETS = $(shell find -L build/ -type f ! -name '*.keys' -printf '%f\n' | sort)
.PHONY: list-targets
list-targets:
	@echo "Available targets:" >&2
	@echo $(TARGETS)

# generate list of available platforms
PLATFORMS = $(addprefix linux-,386 amd64 arm64 armv6 armv7 riscv64 s390x)
.PHONY: list-platforms
list-platforms:
	@echo "Available platforms:" >&2
	@echo $(PLATFORMS)

# get the native docker server platform
NATIVE = $(shell docker version -f "{{ .Server.Os }}/{{ .Server.Arch }}" | sed 's:/:-:g')

# clean up compiled targets
.PHONY: clean
clean:
	rm -rfv compiled/ sources/

# ---------- BINARIES ---------- #

# build all available targets for native platform
.PHONY: all
all: $(addprefix compiled/,$(TARGETS))

# build a single target
$(TARGETS):
	make compiled/$(NATIVE)/$@/

# generate all available targets for all platforms for autocompletion
$(foreach p,$(PLATFORMS),$(foreach t,$(TARGETS),compiled/$p/$t/)):

# use docker with buildx to build artifacts for different platforms
DOCKERBUILD = DOCKER_BUILDKIT=1 docker build $(BUILDARGS) -f $< build/
compiled/linux-386/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/386
compiled/linux-amd64/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/amd64
compiled/linux-arm64/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/arm64
compiled/linux-armv6/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/arm/v6
compiled/linux-armv7/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/arm/v7
compiled/linux-riscv64/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/riscv64
compiled/linux-s390x/%/: build/%
	$(DOCKERBUILD) --target binary -o type=local,dest=$@ --platform linux/s390x

# ---------- SOURCES ---------- #

# export all build sources
SOURCES = $(addsuffix .tar,$(addprefix sources/,$(TARGETS)))
.PHONY: all-sources
all-sources: $(SOURCES)

# export downloaded sources from download stage
$(SOURCES):
sources/%.tar: build/% sources/
	$(DOCKERBUILD) --target sources -o type=tar,dest=$@

sources/:
	mkdir sources/
