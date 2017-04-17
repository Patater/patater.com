.PHONY: build export clean

SUBDIRS := $(shell ls)

all: build

# Build all the images
build:
	@for i in $(SUBDIRS); do if test -e $$i/Makefile ; then $(MAKE) -C $$i build || { exit 1;} fi; done;

export: build
	@for i in $(SUBDIRS); do if test -e $$i/Makefile ; then $(MAKE) -C $$i export || { exit 1;} fi; done;
	@rm -rf images
	@mkdir -p images
	@find . -name "*.docker.tar.xz" -exec cp -fv {} images \;

clean:
	@rm -rf images
	@for i in $(SUBDIRS); do if test -e $$i/Makefile ; then $(MAKE) -C $$i clean || { exit 1;} fi; done;
