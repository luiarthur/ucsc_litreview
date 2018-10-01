SHELL=/bin/bash

filename := sampling

.PHONY: build clean

all: build clean

build: $(filename).tex
	pdflatex $(filename).tex
	bibtex $(filename).aux
	pdflatex $(filename).tex
	pdflatex $(filename).tex

clean:
	rm -f *.{log,aux,nav,out,snm,toc,blg,bbl,fdb_latexmk,fls}

