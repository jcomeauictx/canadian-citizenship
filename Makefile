CANADA := https://www.canada.ca/en
IMMIGRATION := $(CANADA)/immigration-refugees-citizenship
FORMS := $(IMMIGRATION)/services/application/application-forms-guides
APPLY := $(FORMS)/application-citizenship-certificate-adults-minors.html
DOWNLOADS := $(HOME)/Downloads
INSTALLED := .installed
INSTALLER := $(word 1, $(shell which apt yum dnf apk 2>/dev/null))
INSTALL := install
ifeq ($(notdir $(INSTALLER)),apk)
INSTALL := add
endif
APPLICATION := $(DOWNLOADS)/cit0001e.pdf
PAGES := $(shell pdfinfo $(APPLICATION) >/dev/null 2>&1 | \
 awk '$$1 == "Pages:" {print $$2}')
PREVIOUS := $(DOWNLOADS)/cit0001e_prefilled.pdf
FORMPAGES = $(shell seq -f 'page%04g.pdf' 1 $(PAGES) 2>/dev/null)
PREFILLED = $(shell seq -f 'prefilled%04g.pdf' 1 $(PAGES) 2>/dev/null)
FILLEDPAGES = $(addprefix filled, $(FORMPAGES))
TESTPAGES = $(addprefix test, $(FORMPAGES))
PRIVATE := $(HOME)/canada
ifneq ($(SHOWENV),)
export
endif
all: $(INSTALLED)/poppler-utils $(INSTALLED)/seq $(FORMPAGES) result
result: filledform.pdf $(INSTALLED)/xpdf
	xpdf $<
filledform.pdf: $(FILLEDPAGES) | $(INSTALLED)/seq
	pdfunite $+ $@
testpages.pdf: $(TESTPAGES) | $(INSTALLED)/seq $(INSTALLED)/poppler-utils
	pdfunite $+ $@
testpage0%.pdf: test.ps prefilled0%.ps | $(INSTALLED)/ghostscript
	gs \
	 -dNOSAFER \
	 -dBATCH \
	 -dNOPAUSE \
	 -sDEVICE=pdfwrite \
	 -sOutputFile=$@ \
	 -- $+
.SECONDEXPANSION:
filledpage0%.pdf: formfill.ps page0%.ps \
 $$(firstword $$(wildcard $$(PRIVATE)/page0$$*.txt page0$$*.txt) /dev/null) | \
 $(INSTALLED)/poppler-utils $(INSTALLED)/ghostscript
	gs \
	 -dNOSAFER \
	 -dBATCH \
	 -dNOPAUSE \
	 -sDEVICE=pdfwrite \
	 -sOutputFile=$@ \
	 -- $+
page0%.ps: page0%.pdf $(INSTALLED)/poppler-utils
	pdftops $<
prefilled0%.ps: prefilled0%.pdf $(INSTALLED)/poppler-utils
	pdftops $<
page0%.pdf: $(APPLICATION) $(INSTALLED)/poppler-utils
	pdfseparate $< page%04d.pdf
prefilled0%.pdf: $(PREVIOUS) $(INSTALLED)/poppler-utils
	pdfseparate $< prefilled%04d.pdf
$(APPLICATION):
	xdg-open $(APPLY)
	read -p '<ENTER> when form has been downloaded' done
clean:
	rm -f filledpage0*.pdf
distclean: clean
	rm -f page0*.ps page0*.pdf testpage0*.pdf prefilled0*.*
	rm -f filledform.pdf
env:
ifeq ($(SHOWENV),)
	$(MAKE) SHOWENV=1 $@
else
	$@
endif
%/seq: %
	sudo $(INSTALLER) $(INSTALL) coreutils
	touch $@
%/poppler-utils %/ghostscript %/xpdf: | %
	sudo $(INSTALLER) $(INSTALL) $(@F)
	touch $@
$(INSTALLED) $(PRIVATE):
	mkdir -p $@
.PRECIOUS: page0%.pdf
