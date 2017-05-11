.PHONY: build export clean

DOCKER_IMAGE:= com.patater.$(notdir $(shell pwd))

all: build

# Build the image
build:
	docker build -t ${DOCKER_IMAGE} .

export:
	docker save ${DOCKER_IMAGE} | xz -9 > ${DOCKER_IMAGE}.docker.tar.xz

clean:
	@rm -f ${DOCKER_IMAGE}.docker.tar.xz
