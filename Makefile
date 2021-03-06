-include config.mk

scripts = vblr vbdb $(ILS)/bin/*

build: config.mk configure check root
	@echo "Ready to install:"
	@echo "* vblr will be installed in $(PREFIX)/bin"
	@echo "* Data files will be installed in $(ROOT)"

config.mk: config.mk.def
	cp $< $@
	@echo 'Edit config.mk to specify your ILS, etc.'

clean:
	rm -Rf build

unconfigure: clean
	rm -f config.mk

install: build install-vblr
	@echo Installing root for $(ILS)
	install -d $(ROOT)
	cp -p -R build/root/* $(ROOT)/

configure: config.mk

config.mk:
	./configure

root: build/root/root.kv
	@bbin/build-root $(ILS) build/root
	@bbin/chown.$(ILS) build/root

build/root/root.kv: build/root
	@bbin/configure.$(ILS) > $@

build/root:
	@mkdir -p build/root
	
check:
	@bbin/check-all $(ILS) $(PREFIX) build/root $(scripts)

install-vblr: vblr
	@echo Installing vblr and vbdb
	install -d $(PREFIX)
	install -d $(PREFIX)/bin
	install -d $(PREFIX)/lib
	install vblr $(PREFIX)/bin/
	install vbdb $(PREFIX)/bin/

.PHONY: all configure clean unconfigure check build root install install-vblr
