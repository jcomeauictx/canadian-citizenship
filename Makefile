CANADA := https://www.canada.ca/en
IMMIGRATION := $(CANADA)/immigration-refugees-citizenship
FORMS := $(IMMIGRATION)/services/application/application-forms-guides
APPLY := $(FORMS)/application-citizenship-certificate-adults-minors.html
DOWNLOADS := $(HOME)/Downloads
APPLICATION := $(DOWNLOADS)/cit0001e.pdf
PAGES := $(shell pdfinfo $(APPLICATION) | awk '$$1 == "Pages:" {print $$2}')
PREVIOUS := $(DOWNLOADS)/cit0001e_prefilled.pdf
FORMPAGES = $(wildcard page0*.pdf)
PREFILLED = $(wildcard prefilled0*.pdf)
ifneq ($(SHOWENV),)
export
endif
all: page0001.pdf filledpages result
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
filledpage%.pdf: formfill.ps page%.ps
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
prefilled0001.pdf: $(PREVIOUS)
	pdfseparate $< prefilled%04d.pdf
$(APPLICATION):
	xdg-open $(APPLY)
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
.PRECIOUS: page%.pdf
