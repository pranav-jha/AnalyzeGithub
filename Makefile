PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
RESOURCEDIR=$(PREFIX)/share/AnalyzeGithub
RESOURCES=AnalyzeGithub.css sortable.js *.gif
BINARIES=AnalyzeGithub
VERSION=$(shell git describe 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || date +%Y-%m-%d)
SEDVERSION=perl -pi -e 's/VERSION = 0/VERSION = "$(VERSION)"/' --

all: help

help:
	@echo "Usage:"
	@echo
	@echo "make install                   # install to ${PREFIX}"
	@echo "make install PREFIX=~          # install to ~"
	@echo "make release [VERSION=foo]     # make a release tarball"
	@echo

install:
	install -d $(BINDIR) $(RESOURCEDIR)
	install -v $(BINARIES) $(BINDIR)
	install -v -m 644 $(RESOURCES) $(RESOURCEDIR)
	$(SEDVERSION) $(BINDIR)/AnalyzeGithub

release:
	@cp AnalyzeGithub AnalyzeGithub.tmp
	@$(SEDVERSION) AnalyzeGithub.tmp
	@tar --owner=0 --group=0 --transform 's!^!AnalyzeGithub/!' --transform 's!AnalyzeGithub.tmp!AnalyzeGithub!' -zcf AnalyzeGithub-$(VERSION).tar.gz AnalyzeGithub.tmp $(RESOURCES) doc/ Makefile
	@$(RM) AnalyzeGithub.tmp

man:
	pod2man --center "User Commands" -r $(VERSION) doc/AnalyzeGithub.pod > doc/AnalyzeGithub.1

.PHONY: all help install release
