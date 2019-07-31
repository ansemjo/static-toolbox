# use genuinetools/img to build artifacts
.PHONY: build-%
build-%: build/%
	img build -f $< build/ -o type=local,dest=./

# generate target list from available scripts
$(shell find -L build/ -type f ! -name 'gpgkey-*' -printf '%f\n'):
	make build-$@
