IMAGE := alpine:latest

gpg: build.sh
	ID=$$(docker create -it $(IMAGE) ash /build.sh) \
		 && docker cp build.sh $$ID:/build.sh \
		 && docker start -ai $$ID \
		 && docker cp $$ID:/usr/local/bin/gpg gpg; \
	echo "tidy up ...";	docker rm -f $$ID

.PHONY: release
release: gpg
	version=$$(./$< --version | sed -n 's/^gpg (GnuPG) //p') && \
	lzip -c $< > $<-$$version.lz

.PHONY: pull
pull:
	docker pull $(IMAGE)
