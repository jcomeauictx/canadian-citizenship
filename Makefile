CANADA := https://www.canada.ca/en
IMMIGRATION := $(CANADA)/immigration-refugees-citizenship
FORMS := $(IMMIGRATION)/services/application/application-forms-guides
APPLY := $(FORMS)/application-citizenship-certificate-adults-minors.html
DOWNLOADS := $(HOME)/Downloads
APPLICATION := $(DOWNLOADS)/cit0001e.pdf
page0001.pdf: $(APPLICATION)
	pdfseparate $< page%04d.pdf
$(APPLICATION):
	xdg-open $(APPLY)
