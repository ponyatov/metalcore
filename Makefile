CWD		= $(CURDIR)
MODULE	= $(notdir $(CWD))
OS     ?= $(shell uname -s)

NOW		= $(shell date +%d%m%y)
REL		= $(shell git rev-parse --short=4 HEAD)

PIP = $(CWD)/bin/pip3
PY  = $(CWD)/bin/python3
PYT = $(CWD)/bin/pytest

NIMBLE = $(HOME)/.nimble/bin/nimble
NIM    = $(HOME)/.nimble/bin/nim


.PHONY: all
all: metaL metaL.ini
	./$^

.PHONY: tests
tests: docs
	nimpretty --indent:2 tests/test1.nim
	nimble test

.PHONY: docs
docs:
	cd $@ ; find ../src -type f -regex .+.nim$$ | xargs -n1 -P0 nim doc



.PHONY: py
py: $(PY) metaL.py metaL.ini
	$^
.PHONY: pyt
pyt: $(PYT) test_metaL.py
	$^

SRC = src/metaL.nim src/core.nim

metaL: $(SRC) $(MODULE).nimble Makefile
	echo $(SRC) | xargs -n1 -P0 nimpretty --indent:2
	nimble build



.PHONY: install
install: debian $(PIP) $(NIMBLE)
	$(PIP) install    -r requirements.txt
	$(MAKE) requirements.txt

.PHONY: update
update: debian $(PIP)
	$(PIP) install -U    pip
	$(PIP) install -U -r requirements.txt
	$(MAKE) requirements.txt

$(PIP) $(PY):
	python3 -m venv .
	$(PIP) install -U pip pylint autopep8
	$(MAKE) requirements.txt
$(PYT):
	$(PIP) install -U pytest
	$(MAKE) requirements.txt

.PHONY: requirements.txt
requirements.txt: $(PIP)
	$< freeze | grep -v 0.0.0 > $@

.PHONY: debian
debian:
	sudo apt update
	sudo apt install -u `cat apt.txt`

$(NIMBLE):
	curl https://nim-lang.org/choosenim/init.sh -sSf | sh



.PHONY: master shadow release

MERGE  = Makefile README.md .gitignore .vscode/tasks.json apt.txt requirements.txt
MERGE += metaL.py test_metaL.py metaL.ini
MERGE += $(MODULE).nimble src tests

master:
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)
	$(MAKE) tests

shadow:
	git checkout $@

release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	git checkout shadow
