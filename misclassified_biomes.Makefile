# from src/envo, do `./run.sh make all` first

misclassified_biomes.tsv: src/envo/envo.owl misclassified_biomes.rq
	robot query \
		--input $(word 1, $^) \
		--query $(word 2, $^) $@
