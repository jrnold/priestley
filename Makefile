PYTHON ?= python3
RSCRIPT ?= Rscript

DATASETS = Biographies Kings Specimen
RDA_FILES = $(addprefix data/,$(addsuffix .rda,$(DATASETS)))
R_FILES = $(addprefix R/,$(addsuffix .R,$(DATASETS)))

build: $(RDA_FILES) $(R_FILES) docs website

data-raw/priestley_bios.json: data-raw/parse.py data-raw/names_from_description_of_the_chart.txt data-raw/Categories.yml
	$(PYTHON) $< --categories-filename $(word 3,$^) -o $@ $(word 2,$^)

data/Biographies.rda: data-raw/Biographies.R data-raw/priestley_bios.json
	$(RSCRIPT) $<

data/Kings.rda: data-raw/Kings.R data-raw/priestley_kings.tsv
	$(RSCRIPT) $<

data/Specimen.rda: data-raw/Specimen.R data-raw/small-chart.yml data/Biographies.rda
	$(RSCRIPT) $<

R/%.R: data/%.rda data-raw/documentation.yml
	$(RSCRIPT) data-raw/doc-data.R data-raw/documentation.yml $^

.PHONY: docs
docs:
	$(RSCRIPT) -e 'devtools::document()'

.PHONY: pkgdown
website:
	$(RSCRIPT) -e 'pkgdown::build_site()'

test:
	$(RSCRIPT) -e 'devtools::check()'
