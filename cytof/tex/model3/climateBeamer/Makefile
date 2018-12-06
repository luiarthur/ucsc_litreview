.PHONY: clean build all img

PRES_NAME = adv_alui

all: img build clean

build: $(PRES_NAME).tex
	pdflatex $(PRES_NAME).tex 
	bibtex *.aux
	pdflatex $(PRES_NAME).tex
	pdflatex $(PRES_NAME).tex

clean:
	rm -f *.log *.aux *.nav *.out *.snm *.toc *.bbl *.blg *.vrb
	rm -f img.zip

purge: clean
	rm -f $(PRES_NAME).pdf
	rm -rf results

img:
	./pullGraphs
	mkdir -p results
	unzip img.zip -d results
