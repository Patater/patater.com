.PHONY: build export www-site clean

all: build

# Generate the static site
www-site:
	$(MAKE) -C patater.github.io build

# Build the image
build: www-site
	docker build -t com.patater.www .

export:
	docker save ${DOCKER_IMAGE} | xz -9 > ${DOCKER_IMAGE}.docker.tar.xz

clean:
	@rm -f ${DOCKER_IMAGE}.docker.tar.xz
