CANADA := https://www.canada.ca/en
IMMIGRATION := $(CANADA)/immigration-refugees-citizenship
FORMS := $(IMMIGRATION)/services/application/application-forms-guides
APPLY := $(FORMS)/application-citizenship-certificate-adults-minors.html
DOWNLOADS := $(HOME)/Downloads
APPLICATION := $(DOWNLOADS)/cit0001e.pdf
PAGES = $(wildcard page*.pdf)
PREVIOUS := $(DOWNLOADS)/cit0001e_prefilled.pdf
PREFILLED = $(wildcard prefilled*.pdf)
all: page0001.pdf $(PAGES:.pdf=.ps) result
result: filledform.pdf
	xpdf $<
filledform.pdf: filledpages
	pdfunite filledpage*.pdf $@
filledpages: $(addprefix filled, $(PAGES))
testpage%.pdf: test.ps prefilled%.ps
	gs \
	 -dNOSAFER \
	 -dBATCH \
	 -dNOPAUSE \
	 -sDEVICE=pdfwrite \
	 -sOutputFile=$@ \
	 -- $+
testpages: $(addprefix test, $(PAGES))
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
page0001.pdf: $(APPLICATION)
	pdfseparate $< page%04d.pdf
prefilled0001.pdf: $(PREVIOUS)
	pdfseparate $< prefilled%04d.pdf
$(APPLICATION):
	xdg-open $(APPLY)
clean:
	rm -f filledpage0*.pdf
distclean: clean
	rm -f page0*.ps page0*.pdf testpage0*.pdf prefilled0*.*
