.PHONY: build clean

build: repulsive.pdf 

repulsive.pdf: repulsive.tex repulsive.bib natbib.bst natbib.sty
	pdflatex repulsive.tex
	bibtex repulsive.aux
	pdflatex repulsive.tex
	pdflatex repulsive.tex

clean:
	rm -f *.log *.aux *.nav *.out *.snm *.toc *.blg *.bbl
	
cleanall: clean
	rm -f repulsive.pdf
