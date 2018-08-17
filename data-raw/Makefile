all: $(addprefix ../data/,Biographies.rda Kings.rda Specimen.rda)
	@echo $(all)

priestley_bios_1778.json: parse.py priestley_bios_1778.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

priestley_bios_1764.json: parse.py priestley_bios_1764.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

../data/Biographies.rda: Biographies.R priestley_bios_1778.json priestley_bios_1764.json
	Rscript $^

../data/Kings.rda: Kings.R priestley_kings.tsv
	Rscript $<

../data/Specimen.rda: Specimen.R small-chart.yml ../data/Biographies.rda
	Rscript $<
