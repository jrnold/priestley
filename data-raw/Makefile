all: priestley1778.json priestley1764.json

priestley1778.json: parse.py priestley1778.txt Categories.yml
	python $< $(word 2,$^) --outfile $@

priestley1764.json: parse.py priestley1764.txt Categories.yml
	python $< $(word 2,$^) --outfile $@
