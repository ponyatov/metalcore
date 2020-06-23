CWD		= $(CURDIR)
MODULE	= $(notdir $(CWD))

NOW		= $(shell date +%d%m%y)
REL		= $(shell git rev-parse --short=4 HEAD)

NIMBLE	= $(HOME)/.nimble/bin/nimble
PRETTY	= $(HOME)/.nimble/bin/nimpretty



.PHONY: all
all: metaL metaL.ini
	./$^

.PHONY: test
test:
	nimpretty --indent:2 tests/test1.nim 
	nimble test

.PHONY: docs
docs:
	cd $@ ; find ../src -type f -regex .+.nim$$ | xargs -n1 -P0 nim doc



SRC = src/metaL.nim src/core.nim

metaL: $(SRC) $(MODULE).nimble Makefile
	echo $(SRC) | xargs -n1 -P0 nimpretty --indent:2
	nimble build



.PHONY: install
install: debian $(NIMBLE)

.PHONY: debian
debian:
	sudo apt update
	sudo apt install -u `cat apt.txt`

$(NIMBLE):
	curl https://nim-lang.org/choosenim/init.sh -sSf | sh



.PHONY: master shadow release zip wiki

MERGE  = Makefile README.md .vscode apt.txt
MERGE += src tests metaL.ini

master:
	git checkout $@
	git checkout shadow -- $(MERGE)

shadow:
	git checkout $@

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow

zip:
	git archive --format zip --output $(MODULE)_src_$(NOW)_$(REL).zip HEAD
