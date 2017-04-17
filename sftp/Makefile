.PHONY: build export clean

all: build

# Build the image
build:
	docker build -t com.patater.sftp .

export:
	docker save ${DOCKER_IMAGE} | xz -9 > ${DOCKER_IMAGE}.docker.tar.xz

clean:
	@rm -f ${DOCKER_IMAGE}.docker.tar.xz
