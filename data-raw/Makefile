all: $(addprefix ../data/,priestley_bios_1778.rda priestley_bios_1764.rda priestley_kings.rda)
	@echo $(all)

priestley_bios_1778.json: parse.py priestley_bios_1778.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

priestley_bios_1764.json: parse.py priestley_bios_1764.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

../data/priestley_bios_1778.rda: json2rda.R priestley_bios_1778.json
	Rscript $^

../data/priestley_bios_1764.rda: json2rda.R priestley_bios_1764.json
	Rscript $^

../data/priestley_kings.rda: priestley_kings.R priestley_kings.tsv
	Rscript $<
