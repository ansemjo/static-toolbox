IMAGE := alpine:latest

gpg: build.sh
	ID=$$(docker create -it $(IMAGE) ash /build.sh) \
		 && docker cp build.sh $$ID:/build.sh \
		 && docker start -ai $$ID \
		 && docker cp $$ID:/usr/local/bin/gpg gpg; \
	echo "tidy up ...";	docker rm -f $$ID

gpg.lz: gpg
	lzip -k $<

.PHONY: pull
pull:
	docker pull $(IMAGE)
