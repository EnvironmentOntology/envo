PATTERN_DIR=patterns
#PATTERN_IDS=$(wildcard ../patterns/dosdp-patterns/[a-z]*.yaml)
PATTERN_IDS=biome
ALL_PATTERNS=$(patsubst ../patterns/dosdp-patterns/%.yaml,%,$(PATTERN_IDS))
DOSDPT=dosdp-tools
SCRIPTDIR=util
SPARQLDIR=sparql

.PHONY: matches matches_annotations sparql_test2 ensure-tmpdir-envo ensure-pattern-match-dir ensure-pattern-annotations-dir ensure-sparql-reportdir

tmp/envo-edit-merged.owl: $(SRC) | ensure-tmpdir-envo
	$(ROBOT) merge -i $< -o $@

# Ensures the temporary directory exists
ensure-tmpdir-envo:
	mkdir -p tmp/

PATTERN_MATCH_DIR=patterns/matches

matches: tmp/envo-edit-merged.owl | ensure-pattern-match-dir
	$(DOSDPT) query --ontology=$< --catalog=catalog-v001.xml --reasoner=elk --obo-prefixes=true --batch-patterns="$(ALL_PATTERNS)" --template="$(PATTERN_DIR)" --outfile="$(PATTERN_MATCH_DIR)/logical/"

# Ensures the pattern match directory exists
ensure-pattern-match-dir:
	mkdir -p $(PATTERN_MATCH_DIR)/logical

matches_annotations: tmp/envo-edit-merged.owl | ensure-pattern-annotations-dir
	$(DOSDPT) query --ontology=$< --catalog=catalog-v001.xml --reasoner=elk --restrict-axioms-to=annotation --obo-prefixes=true --batch-patterns="$(ALL_PATTERNS)" --template="$(PATTERN_DIR)" --outfile="$(PATTERN_MATCH_DIR)/annotations/"

# Ensures the pattern annotations directory exists
ensure-pattern-annotations-dir:
	mkdir -p $(PATTERN_MATCH_DIR)/annotations

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

sparql_test2: $(SRC) modules/tags.owl | ensure-sparql-reportdir
	$(ROBOT) merge $(addprefix -i , $^) verify --queries sparql/dosdp-conforms-violation.sparql -O reports/

# Ensures the reports directory exists for SPARQL tests
ensure-sparql-reportdir:
	mkdir -p reports/

test: sparql_test2
