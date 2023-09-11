misclassified_biomes.tsv: envo.owl misclassified_biomes.rq
	robot query \
		--input $(word 1, $^) \
		--query $(word 2, $^) $@