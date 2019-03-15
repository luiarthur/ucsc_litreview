AWS_BUCKET_CLIMATE_PRES = "s3://cytof-climate-pres"

.PHONY: clean build all img

PRES_NAME = alui-jsm2019

all: img build clean

build: $(PRES_NAME).tex
	pdflatex $(PRES_NAME).tex 
	bibtex *.aux
	pdflatex $(PRES_NAME).tex
	pdflatex $(PRES_NAME).tex

clean:
	rm -f *.log *.aux *.nav *.out *.snm *.toc *.bbl *.blg
	rm -f *.vrb *.fdb_latexmk *.fls *.synctex.gz

purge: clean
	rm -f $(PRES_NAME).pdf
	rm -rf results

getImg:
	aws s3 sync $(AWS_BUCKET_CLIMATE_PRES) results/

sendImg:
	aws s3 sync results/ $(AWS_BUCKET_CLIMATE_PRES)
