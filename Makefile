CWD		= $(CURDIR)
MODULE	= $(notdir $(CWD))

NOW		= $(shell date +%d%m%y)
REL		= $(shell git rev-parse --short=4 HEAD)

NIMBLE	= $(HOME)/.nimble/bin/nimble
PRETTY	= $(HOME)/.nimble/bin/nimpretty



.PHONY: all test

all: metaL metaL.ini
	./$^

test:
	$(NIMBLE) test



SRC = src/metaL.nim src/core.nim

metaL: $(SRC) $(MODULE).nimble Makefile
	ls src/*.nim | xargs -n1 $(PRETTY) --indent:2
	$(NIMBLE) build



.PHONY: install
install: debian $(NIMBLE)

.PHONY: debian
debian:
	sudo apt update
	sudo apt install -u `cat apt.txt`

$(NIMBLE):
	curl https://nim-lang.org/choosenim/init.sh -sSf | sh



.PHONY: master shadow release zip wiki

MERGE  = Makefile README.md .gitignore .vscode apt.txt
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
