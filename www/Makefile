.PHONY: build run export www-site clean

DOCKER_IMAGE:= com.patater.$(notdir $(shell pwd))

all: build

# Generate the static site
www-site:
	$(MAKE) -C patater.github.io build

# Build the image
build: www-site
	docker build -t ${DOCKER_IMAGE} .

run: build
	docker run -i -t --rm --name www -p 80:80 -p 443:443 -v $(CWD)/www-data:/www-data:ro -v $(CWD)/ssl-keys:/etc/letsencrypt:rw com.patater.www

export:
	docker save ${DOCKER_IMAGE} | xz -9 > ${DOCKER_IMAGE}.docker.tar.xz

clean:
	@rm -f ${DOCKER_IMAGE}.docker.tar.xz
