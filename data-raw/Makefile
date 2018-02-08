all: ../data/priestley1778.rda ../data/priestley1764.rda

priestley1778.json: parse.py priestley1778.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

priestley1764.json: parse.py priestley1764.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

../data/priestley1778.rda: json2rda.R priestley1778.json
	Rscript $^

../data/priestley1764.rda: json2rda.R priestley1764.json
	Rscript $^
