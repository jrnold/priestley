DATASETS := Biographies Kings Specimen

DATA_DIR = ../data
R_DIR = ../R

DATA_FILES = $(addsuffix .rda,$(addprefix $(DATA_DIR)/,$(DATASETS)))
R_FILES = $(addsuffix .R,$(addprefix $(R_DIR)/,$(DATASETS)))

.PHONY: all
all: build

.PHONY: build
build: build-data build-docs

.PHONY: build-docs
build-docs: build-data
	Rscript -e 'devtools::document()'

.PHONY: build-data
build-data: $(DATA_FILES) $(R_FILES)
	@echo $(DATA_FILES) $(R_FILES)

Biographies.json: parse.py Biographies.yml Categories.yml
	python $< $(word 2,$^) --outfile $@

$(DATA_DIR)/Biographies.rda: Biographies.R Biographies.json Categories.yml
	Rscript $^ $@

$(DATA_DIR)/Kings.rda: Kings.R Kings.csv
	Rscript $^ $@

$(DATA_DIR)/Specimen.rda: Specimen.R ../data/Biographies.rda Specimen.yml
	Rscript $^ $@

$(R_DIR)/%.R: $(DATA_DIR)/%.rda doc-data.R documentation.yml
	Rscript doc-data.R documentation.yml $< $@
