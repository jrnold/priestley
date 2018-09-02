all: $(addprefix ../data/,Biographies.rda Kings.rda Specimen.rda)
	@echo $(all)

priestley_bios.json: parse.py names_from_description_of_the_chart.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

../data/Biographies.rda: Biographies.R priestley_bios.json Categories.yml
	Rscript $^ $@

../data/Kings.rda: Kings.R Kings.csv
	Rscript $^ $@

../data/Specimen.rda: Specimen.R ../data/Biographies.rda Specimen.yml
	Rscript $^ $@
