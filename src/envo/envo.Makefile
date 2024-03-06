PATTERN_DIR=patterns
#PATTERN_IDS=$(wildcard ../patterns/dosdp-patterns/[a-z]*.yaml)
PATTERN_IDS=biome
ALL_PATTERNS=$(patsubst ../patterns/dosdp-patterns/%.yaml,%,$(PATTERN_IDS))
DOSDPT=dosdp-tools
SCRIPTDIR=util
SPARQLDIR=sparql

.PHONY: matches matches_annotations

tmp/envo-edit-merged.owl: $(SRC)
	mkdir -p tmp/
	$(ROBOT) merge -i $< -o $@

PATTERN_MATCH_DIR=patterns/matches

matches: tmp/envo-edit-merged.owl
	mkdir -p $(PATTERN_MATCH_DIR)/logical
	$(DOSDPT) query --ontology=$< --catalog=catalog-v001.xml --reasoner=elk --obo-prefixes=true --batch-patterns="$(ALL_PATTERNS)" --template="$(PATTERN_DIR)" --outfile="$(PATTERN_MATCH_DIR)/logical/"

matches_annotations: tmp/envo-edit-merged.owl
	mkdir -p $(PATTERN_MATCH_DIR)/annotations
	$(DOSDPT) query --ontology=$< --catalog=catalog-v001.xml --reasoner=elk --restrict-axioms-to=annotation --obo-prefixes=true --batch-patterns="$(ALL_PATTERNS)" --template="$(PATTERN_DIR)" --outfile="$(PATTERN_MATCH_DIR)/annotations/"

##############################################################
###### Pipeline for adding a compoment with tagging ##########
# For example: DOSDP conformance

MATCHED_TSVs=$(foreach V,$(notdir $(wildcard $(PATTERN_MATCH_DIR)/logical/*.tsv)),$(PATTERN_MATCH_DIR)/logical/$V)

tmp/tags-dosdp.tsv:
	python $(SCRIPTDIR)/dosdp-matches-tags.py $(addprefix -d , $(MATCHED_TSVs)) -o $@

tmp/tags-dosdp.owl: tmp/tags-dosdp.tsv
	$(ROBOT) merge -i $(SRC) template --template $< --output $@

modules/tags.owl: tmp/tags-dosdp.owl
	$(ROBOT) merge $(addprefix -i , $^) annotate --ontology-iri $(ONTBASE)/$@ -o $@

sparql_test2: $(SRC) modules/tags.owl
	$(ROBOT) merge $(addprefix -i , $^) verify --queries sparql/dosdp-conforms-violation.sparql -O reports/
