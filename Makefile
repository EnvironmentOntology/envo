#######################################
##### Mapping validation  #############
#######################################

MAPPING_DIR=mappings
TMPDIR = tmp

validate-sssom-%:
	mkdir -p $(TMPDIR)
	tsvalid $(MAPPING_DIR)/$*.sssom.tsv --comment "#" --skip E1
	sssom validate $(MAPPING_DIR)/$*.sssom.tsv
	sssom convert $(MAPPING_DIR)/$*.sssom.tsv -o $(TMPDIR)/schema-$*.sssom.ttl

MAPPINGS=$(notdir $(wildcard $(MAPPING_DIR)/*.sssom.tsv))
VALIDATE_MAPPINGS=$(patsubst %.sssom.tsv, validate-sssom-%, $(notdir $(wildcard $(MAPPING_DIR)/*.sssom.tsv)))

validate_mappings: 
	$(MAKE) $(VALIDATE_MAPPINGS)
