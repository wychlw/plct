main.pdf: main.rmd *.png
	R -e 'rmarkdown::render("main.rmd")'
	rm -f main.log

clean:
	rm -f main.pdf

all: main.pdf

.PHONY: clean all