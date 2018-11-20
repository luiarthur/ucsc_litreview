SHELL=/bin/bash

filename := sampling

.PHONY: build clean zip

all: build clean

build: $(filename).tex
	pdflatex $(filename).tex
	bibtex $(filename).aux
	pdflatex $(filename).tex
	pdflatex $(filename).tex

clean:
	rm -f *.{log,aux,nav,out,snm,toc,blg,bbl,fdb_latexmk,fls,synctex.gz}

zip:
	zip -r cytof_advancement_alui.zip litreview.bib sampling.tex sampling.pdf includes/ img/ Makefile
