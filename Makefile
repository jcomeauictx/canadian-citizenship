CANADA := https://www.canada.ca/en
IMMIGRATION := $(CANADA)/immigration-refugees-citizenship
FORMS := $(IMMIGRATION)/services/application/application-forms-guides
APPLY := $(FORMS)/application-citizenship-certificate-adults-minors.html
DOWNLOADS := $(HOME)/Downloads
APPLICATION := $(DOWNLOADS)/cit0001e.pdf
PAGES = $(wildcard page*.pdf)
all: $(APPLICATION) $(PAGES:.pdf=.ps) $(addprefix test,$(PAGES))
testpage%.pdf: test.ps page%.ps
	gs \
	 -dNOSAFER \
	 -dBATCH \
	 -dNOPAUSE \
	 -sDEVICE=pdfwrite \
	 -sOutputFile=$@ \
	 -- $+
page%.ps: page%.pdf
	pdftops $<
page0001.pdf: $(APPLICATION)
	pdfseparate $< page%04d.pdf
$(APPLICATION):
	xdg-open $(APPLY)
