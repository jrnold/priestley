PYTHON ?= python3
RSCRIPT ?= Rscript

DATASETS := Biographies Kings Specimen

DATA_DIR = data
R_DIR = R

DATA_FILES = $(addsuffix .rda,$(addprefix $(DATA_DIR)/,$(DATASETS)))
R_FILES = $(addsuffix .R,$(addprefix $(R_DIR)/,$(DATASETS)))

.PHONY: all
all: build

.PHONY: build
build: build-sources build-docs README.md build-site

.PHONY: build-docs
build-docs: build-sources
	Rscript -e 'devtools::document()'

.PHONY: build-sources
build-sources: $(DATA_FILES) $(R_FILES)

data-raw/Biographies.json: data-raw/parse.py data-raw/Biographies.yml data-raw/Categories.yml
	$(PYTHON) $< $(word 2,$^) --outfile $@

$(DATA_DIR)/Biographies.rda: data-raw/Biographies.R data-raw/Biographies.json data-raw/Categories.yml
	$(RSCRIPT) $^ $@

$(DATA_DIR)/Kings.rda: data-raw/Kings.R data-raw/Kings.csv
	$(RSCRIPT) $^ $@

$(DATA_DIR)/Specimen.rda: data-raw/Specimen.R data/Biographies.rda data-raw/Specimen.yml
	$(RSCRIPT) $^ $@

$(R_DIR)/%.R: $(DATA_DIR)/%.rda data-raw/doc-data.R data-raw/documentation.yml
	$(RSCRIPT) data-raw/doc-data.R data-raw/documentation.yml $< $@

.PHONY: build-site
build-site: build-sources
	$(RSCRIPT) -e 'pkgdown::build_site()'

README.md: README.Rmd
	$(RSCRIPT) -e 'rmarkdown::render("$<")'

.PHONY: test
test:
	$(RSCRIPT) -e 'devtools::check()'
