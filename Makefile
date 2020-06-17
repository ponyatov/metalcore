CWD		= $(CURDIR)
MODULE	= $(notdir $(CWD))

NOW		= $(shell date +%d%m%y)
REL		= $(shell git rev-parse --short=4 HEAD)

NIMBLE	= $(HOME)/.nimble/bin/nimble

.PHONY: all test
all: metaL
	./$^

test:
	$(NIMBLE) test

SRC  = src/metaL.nim src/core.nim

metaL: $(SRC) $(MODULE).nimble Makefile
	ls src/*.nim | xargs -n1 nimpretty --indent:2
	$(NIMBLE) build
