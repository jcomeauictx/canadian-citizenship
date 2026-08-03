CANADA := https://www.canada.ca/en
IMMIGRATION := $(CANADA)/immigration-refugees-citizenship
FORMS := $(IMMIGRATION)/services/application/application-forms-guides
APPLY := $(FORMS)/application-citizenship-certificate-adults-minors.html
DOWNLOADS := $(HOME)/Downloads
INSTALLED := .installed
APPLICATION := $(DOWNLOADS)/cit0001e.pdf
PAGES := $(shell pdfinfo $(APPLICATION) | awk '$$1 == "Pages:" {print $$2}')
PREVIOUS := $(DOWNLOADS)/cit0001e_prefilled.pdf
FORMPAGES = $(shell seq -f 'page%04g.pdf' 1 $(PAGES))
PREFILLED = $(shell seq -f 'prefilled%04g.pdf' 1 $(PAGES))
PRIVATE := $(HOME)/canada
ifneq ($(SHOWENV),)
export
endif
all: $(FORMPAGES) filledpages result
result: filledform.pdf
	xpdf $<
filledform.pdf: filledpages
	pdfunite filledpage*.pdf $@
filledpages: $(addprefix filled, $(FORMPAGES))
testpage%.pdf: test.ps prefilled%.ps
	gs \
	 -dNOSAFER \
	 -dBATCH \
	 -dNOPAUSE \
	 -sDEVICE=pdfwrite \
	 -sOutputFile=$@ \
	 -- $+
testpages: $(addprefix test, $(FORMPAGES))
.SECONDEXPANSION:
filledpage%.pdf: formfill.ps page%.ps \
 $$(firstword $$(wildcard $$(PRIVATE)/page$$*.txt page$$*.txt) /dev/null)
	gs \
	 -dNOSAFER \
	 -dBATCH \
	 -dNOPAUSE \
	 -sDEVICE=pdfwrite \
	 -sOutputFile=$@ \
	 -- $+
page%.ps: page%.pdf
	pdftops $<
prefilled%.ps: prefilled%.pdf
	pdftops $<
page%.pdf: $(APPLICATION)
	pdfseparate $< page%04d.pdf
prefilled%.pdf: $(PREVIOUS)
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
$(INSTALLED):
	mkdir $@
$(INSTALLED)/seq:
	sudo $(INSTALLER) $(INSTALL) coreutils
	touch $@
$(INSTALLED)/poppler-utils:
	sudo $(INSTALLER) $(INSTALL) $(&F)
	touch $@
.PRECIOUS: page%.pdf
