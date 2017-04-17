.PHONY: build run update export www-site

all: build

# Generate the static site
www-site:
	$(MAKE) -C www/patater.github.io build

# Build all the images
build: www-site
	docker build -t com.patater.www www
	docker build -t com.patater.sftp sftp

# Run all the images
run:

update: build run

export:
	docker save ${DOCKER_IMAGE} | xz -9 > ${DOCKER_IMAGE}.tar.xz
