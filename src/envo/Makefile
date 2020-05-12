# ----------------------------------------
# Makefile for envo
# Generated using ontology-starter-kit
# ODK Version: "Unknown"
# ----------------------------------------
# <do not edit above this line>
#
# This Makefile is for use by the ENVO Release Manager (currently cjm)
# Also used for unit tests executed by travis
#
# See README-editors.md for more details on release process
#
# To make a release, type 'make release' in this directory

# ----------------------------------------
# Standard Constants
# ----------------------------------------
# these can be overwritten on the command line

OBO=http://purl.obolibrary.org/obo
URIBASE=                    $(OBO)
ONT=                        envo
ONTBASE=                    $(URIBASE)/$(ONT)
EDIT_FORMAT=                owl
PRE_SRC =                   $(ONT)-edit.$(EDIT_FORMAT)
SRC =                       $(ONT)-edit-module-merged.owl
CATALOG=                    catalog-v001.xml
USECAT=                     --catalog-xml $(CATALOG)
ROBOT=                      robot --catalog $(CATALOG)
OWLTOOLS=                   owltools
RELEASEDIR=                 ../..
REPORTDIR=                  reports
TMPDIR=                     tmp
SPARQLDIR =                 sparql
REPORT_FAIL_ON =            NONE
OBO_FORMAT_OPTIONS =        
###SPARQL_VALIDATION_CHECKS =  equivalent-classes trailing-whitespace owldef-self-reference xref-syntax nolabels
SPARQL_VALIDATION_CHECKS =  equivalent-classes trailing-whitespace owldef-self-reference nolabels
SPARQL_EXPORTS =            basic-report class-count-by-prefix edges xrefs obsoletes synonyms
ODK_VERSION =               "Unknown"

TODAY ?= $(shell date +%Y-%m-%d)
OBODATE ?= $(shell date +'%d:%m:%Y %H:%M')
VERSIONINFO ?= $(TODAY)

FORMATS = owl obo json
FORMATS_INCL_TSV = $(sort $(FORMATS) tsv)


# ----------------------------------------
# Top-level targets
# ----------------------------------------

.PHONY: .FORCE
all: all_imports all_main all_subsets sparql_test all_reports all_assets

test: envo-edit.owl all_modules all_imports envo.owl
travis_test: test_python envo-edit.owl all_modules envo.owl

full_test: test envo.check-obo subsets/EnvO-Lite-GSC.check-obo

# temp test for travis
test_python:
	python3 --version

## -- main targets --
##
## By default this is the cross-product of {ont, ont-base} x FORMATS

MAIN_PRODUCTS = $(sort $(foreach r,$(RELEASE_ARTEFACTS), $(ONT)-$(r)) $(ONT))
MAIN_GZIPPED = 
MAIN_FILES = $(foreach n,$(MAIN_PRODUCTS), $(foreach f,$(FORMATS), $(n).$(f))) $(MAIN_GZIPPED)

all_main: $(MAIN_FILES)

# release products
#build: base all_modules all_imports envo.owl envo.obo envo.json subsets/envo-basic.obo subsets/envo-basic.json subsets/EnvO-Lite-GSC.obo

release: build copy-release

# stages release in top level folder
copy-release:
	cp -pr catalog-v001.xml envo.obo envo.owl envo.json envo-base.owl subsets mappings imports $(RELEASEDIR)

base: envo-base.owl

# generic conversion to make obographjson from OWL files
%.json: %.owl
	$(ROBOT) convert -input $< -o $@

# consider replacing with robot reason -D
debug.owl: envo-edit.owl
	$(OWLTOOLS) --use-catalog  $< --merge-support-ontologies --run-reasoner -r elk -u -m $@

# currently fails
obo-check: envo-edit.owl
	$(OWLTOOLS) --use-catalog  $< -o -f obo $@.tmp && $(OWLTOOLS) --use-catalog  $@.tmp -o -f obo $@

MODS = entity_attribute_location entity_quality_location entity_attribute process_attribute chemical_concentration
ALL_MODS_OWL = $(patsubst %, modules/%.owl, $(MODS))
ALL_MODS_CSV = $(patsubst %, modules/%.csv, $(MODS))

# Merge in all module files, whilst removing the corresponding import
$(SRC): $(PRE_SRC)
	$(OWLTOOLS) $(USECAT) $<  $(patsubst %, --remove-import-declaration $(OBO)/envo/modules/%.owl, $(MODS)) -o $@.tmp
	$(OWLTOOLS) $(USECAT) $@.tmp  $(ALL_MODS_OWL) --merge-support-ontologies -o $@

# ----------------------------------------
# Export formats
# ----------------------------------------


$(ONT)-full.obo: $(ONT)-full.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT)-full.json: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@  -a owl:versionInfo $(TODAY) \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@
$(ONT)-base.obo: $(ONT)-base.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT)-base.json: $(ONT)-base.owl
	$(ROBOT) annotate --input $< --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@  -a owl:versionInfo $(TODAY) \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@
# Main release artefacts
$(ONT).owl: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@  -a owl:versionInfo $(TODAY) \
		convert -o $@.tmp.owl && mv $@.tmp.owl $@

$(ONT).obo: $(ONT).owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo
$(ONT).json: $(ONT)-full.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@  -a owl:versionInfo $(TODAY) \
		convert --check false -f json -o $@.tmp.json && mv $@.tmp.json $@

# ----------------------------------------
# Initiating Step: Reason over source
# ----------------------------------------


# by default we use ELK to perform a reason-relax-reduce chain
# after that we annotate the ontology with the release versionInfo

OTHER_SRC = 


$(ONTOLOGYTERMS): $(SRC) $(OTHER_SRC)
	touch $(ONTOLOGYTERMS) && \
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/envo_terms.sparql $@


# base: OTHER sources of interest, such as definitions owl
$(ONT)-base.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) remove --input $< --select imports --trim false \
		merge $(patsubst %, -i %, $(OTHER_SRC)) \
		annotate --annotation http://purl.org/dc/elements/1.1/type http://purl.obolibrary.org/obo/IAO_8000001 \
		--ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ -a owl:versionInfo $(TODAY) \
		--output $@.tmp.owl && mv $@.tmp.owl $@

# Full: The full artefacts with imports merged, reasoned
$(ONT)-full.owl: $(SRC) $(OTHER_SRC)
	$(ROBOT) merge --input $< \
		reason --reasoner ELK --equivalent-classes-allowed all --exclude-tautologies structural \
		relax \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@  -a owl:versionInfo $(TODAY)\
                --output $@.tmp.owl && mv $@.tmp.owl $@

###	ontology-release-runner --catalog-xml catalog-v001.xml --reasoner elk  --skip-format owx --skip-format obo  --error-report envo-errors.txt $< --allow-overwrite --asserted --simple
##	ontology-release-runner --catalog-xml catalog-v001.xml  --skip-format owx --run-obo-basic-dag-check --error-report envo-errors.txt $< --allow-overwrite --asserted --simple

#envo.owl: envo-edit.owl
#	$(ROBOT) reason -s true --input $< --reasoner elk --output $@

# ----------------------------------------
# Subsets
# ----------------------------------------

## -- subset targets --
##
## By default this is the cross-product of SUBSETS x FORMATS
## Note we also include TSV as a format


SUBSETS = envo-basic EnvO-Lite-GSC envoEmpo envoAstro envoPolar envoEmpo envoOmics envoCesab environmental_hazards

SUBSET_ROOTS = $(patsubst %, subsets/%, $(SUBSETS))
SUBSET_FILES = $(foreach n,$(SUBSET_ROOTS), $(foreach f,$(FORMATS_INCL_TSV), $(n).$(f)))


all_subsets: $(SUBSET_FILES)

subsets/%.tsv: subsets/%.owl
	$(ROBOT) export -i $< -c "ID|label|definition" -e $@
#	$(ROBOT) query -f tsv -i $< -s ./sparql/labels.sparql $@

envo-simple.owl: envo-base.owl
	$(OWLTOOLS) --use-catalog $< --remove-imports-declarations --remove-dangling-annotations -o $@

# TODO - fix IRI
subsets/envo-basic.owl: envo-simple.owl
	$(OWLTOOLS) $< imports/ro_import.owl --merge-imports-closure --set-ontology-id $(OBO)/$@ -o $@.tmp && mv $@.tmp $@

subsets/envo-basic.obo: envo-simple.owl
	$(OWLTOOLS) $< imports/ro_import.owl --merge-imports-closure  --add-obo-shorthand-to-properties --set-ontology-id $(OBO)/$@ -o -f obo --no-check $@.tmp && grep -v ^owl-axioms $@.tmp > $@

#envo-mireot.obo: envo-edit.owl chebi-lite.obo pato-lite.obo
#	ontology-release-runner --no-subsets --skip-format owx --run-obo-basic-dag-check --no-reasoner --allow-overwrite --asserted --outdir build $< chebi-lite.obo pato-lite.obo && cp build/envo-merged.obo $@

#chebi-lite.obo:
#	$(OWLTOOLS) $(OBO)/chebi.obo --make-subset-by-properties -o -f obo $@
#pato-lite.obo:
#	$(OWLTOOLS) $(OBO)/pato.obo --make-subset-by-properties -o -f obo $@

release-diffs:
	cd diffs && make


## -- import targets --
##
## By default this is the cross-product of IMPORT_MODULES x FORMATS

IMPORTS = pato uberon chebi ro pco foodon go ncbitaxon  obi po iao fao agro

IMPORT_ROOTS = $(patsubst %, imports/%_import, $(IMPORTS))
IMPORT_OWL_FILES = $(foreach n,$(IMPORT_ROOTS), $(n).owl)
IMPORT_FILES = $(IMPORT_OWL_FILES)

all_imports: $(IMPORT_FILES)


# ----------------------------------------
# Regenerate imports
# ----------------------------------------
# Uses OWLAPI Module Extraction code

# Type 'make imports/X_import.owl' whenever you wish to refresh the import for an ontology X. This is when:
#
#  1. X has changed and we want to include these changes
#  2. We have added one or more new IRIs from X into envo-edit.owl
#  3. We have removed references to one or more IRIs in X from envo-edit.owl
#
# You should NOT edit these files directly, changes will be overwritten.
#
# If you want to add something to these, edit envo-edit.owl and add an axiom with a IRI from X. You don't need to add any information about X.

# Base URI for local subset imports
ENVO_IMPORTS_BASE_URI = $(OBO)/envo

# owltools command for removing self-reference
# this is a temp fix until all upstreams implement Jim's solution
# See also https://github.com/EnvironmentOntology/envo/issues/610
REMOVE_SELF_REF= --remove-classes-in-idspace -d ENVO


# Make this target to regenerate ALL
all_imports: $(patsubst %, imports/%_import.owl,$(IMPORTS)) $(patsubst %, imports/%_import.obo,$(IMPORTS))

SEEDS= $(patsubst %, imports/%_terms.txt,$(IMPORTS))


KEEPRELS = BFO:0000050 BFO:0000051 RO:0002202 immediate_transformation_of RO:0002176 IAO:0000136

# See https://github.com/EnvironmentOntology/envo/issues/521
imports/seed.tsv: envo-edit.owl $(ALL_MODS_OWL)
	$(OWLTOOLS) $(USECAT) $< --merge-imports-closure --export-table $@.tmp && cut -f1 $@.tmp | grep purl.obolib | sort -u > $@

imports/%_combined_seed.tsv: imports/%_terms.txt imports/seed.tsv
	cut -f1 $^ | sort -u > $@

# Create an import module using the OWLAPI module extraction code via OWLTools.
# We use the standard catalog, but rewrite the import to X to be a local mirror of ALL of X.
# After extraction, we further reduce the ontology by creating a "mingraph" (removes all annotations except label) and by
imports/%_import.owl: mirror/%.owl envo-edit.owl imports/%_combined_seed.tsv
	$(ROBOT) extract -i $< -T imports/$*_combined_seed.tsv -m BOT -O $(ENVO_IMPORTS_BASE_URI)/$@ -o $@.tmp.owl && mv $@.tmp.owl $@

imports/%_import.obo: imports/%_import.owl
	$(OWLTOOLS) $(USECAT) $< -o -f obo --no-check $@



# clone remote ontology locally, perfoming some excision of relations and annotations
mirror/%-local.owl:
	wget --no-check-certificate $(OBO)/$*.owl -O $@
.PRECIOUS: mirror/%-local.owl

mirror/%.owl: mirror/%-local.owl
	$(OWLTOOLS) $< --remove-annotation-assertions -l --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS)  -o $@
.PRECIOUS: mirror/%.owl

mirror/agro.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/agro.owl $(REMOVE_SELF_REF) --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/agro.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/sdgio.owl: envo-edit.owl
	$(OWLTOOLS) http://purl.unep.org/sdg/sdgio.owl $(REMOVE_SELF_REF)  --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id http://purl.unep.org/sdg/sdgio.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/obi.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/obi.owl --remove-classes-in-idspace GO --remove-classes-in-idspace ENVO --remove-classes-in-idspace CHEBI --remove-classes-in-idspace UBERON --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/obi.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/foodon-local.owl:
	$(OWLTOOLS) $(OBO)/foodon.owl --merge-imports-closure $(REMOVE_SELF_REF) --remove-annotation-assertions -l -s -d --remove-axiom-annotations  --set-ontology-id $(OBO)/foodon.owl -o $@
mirror/foodon.owl: mirror/foodon-local.owl
	$(ROBOT) relax -i $< reduce -o $@
.PRECIOUS: mirror/%.owl

# chebi.owl is large and the owlapi often times out when reading it; use the obo instead
mirror/chebi-local.owl: 
	wget --no-check-certificate $(OBO)/chebi.owl -O $@ && touch $@
mirror/chebi.owl: mirror/chebi-local.owl
	$(OWLTOOLS) --no-debug $< --log-debug --remove-annotation-assertions -l --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS)  -o $@
.PRECIOUS: mirror/%.owl

#mirror/ro.owl: mirror/ro-relations.owl mirror/ro-classes.owl
#	$(OWLTOOLS) $^ --merge-support-ontologies -o $@
mirror/ro.owl:
	$(OWLTOOLS) $(OBO)/ro.owl --merge-imports-closure -o $@
.PRECIOUS: mirror/ro.owl

mirror/ro-relations.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/ro.owl --merge-imports-closure --remove-tbox --remove-dangling -o $@
mirror/ro-classes.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/ro.owl --merge-imports-closure --make-subset-by-properties -f // --remove-external-classes -k RO --remove-annotation-assertions -l -s -d  -o $@

mirror/bfo.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/bfo.owl --merge-imports-closure --make-subset-by-properties -f // --remove-external-classes BFO --remove-annotation-assertions -l -s -d  --remove-dangling --set-ontology-id $(OBO)/bfo.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/uberon.owl: 
	$(OWLTOOLS) $(OBO)/uberon.obo  --remove-axiom-annotations  --make-subset-by-properties -f $(KEEPRELS) --remove-external-classes UBERON --remove-dangling-annotations --remove-annotation-assertions -l -s -d --set-ontology-id $(OBO)/uberon.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/po.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/po.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/po.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/fao.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/fao.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/fao.owl -o $@
.PRECIOUS: mirror/%.owl

ncbitaxon.obo:
	wget $(OBO)/ncbitaxon.obo -O $@.tmp && mv $@.tmp $@
.PRECIOUS: ncbitaxon.obo

mirror/ncbitaxon.owl: ncbitaxon.obo
	OWLTOOLS_MEMORY=12G $(OWLTOOLS) $< --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations  --set-ontology-id $(OBO)/ncbitaxon.owl -o $@
.PRECIOUS: mirror/ncbitaxon.owl

mirror/pco.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/pco.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/pco.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/iao.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/iao.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/iao.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/omp.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/omp.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/omp.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/pato.owl: envo-edit.owl
	$(OWLTOOLS) $(OBO)/pato.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/pato.owl -o $@
.PRECIOUS: mirror/%.owl

# ----------------------------------------
# ALL ASSETS
# ----------------------------------------
## -- all files/assets --

ASSETS = \
  $(IMPORT_FILES) \
  $(MAIN_FILES) \
  $(REPORT_FILES) \
  $(SUBSET_FILES)

all_assets: $(ASSETS)

show_assets:
	echo $(ASSETS)
	du -sh $(ASSETS)

# ----------------------------------------
# STYLE CHECKS
# ----------------------------------------
is_utf: envo-edit.owl
	iconv -f UTF-8 -t ISO-8859-15 $< > $@

# ----------------------------------------
# OBO CHECKS
# ----------------------------------------

DISABLE= multiply-labeled-edge valid-id-space isa-incomplete ascii-check has-definition bad-pmid ontology-declaration-check referenced-id-syntax-check owl-axiom-check
%.obo-gocheck: %.obo GO.xrf_abbs
	iconv -f UTF-8 -t ISO-8859-15 $< > $@-iconv && \
	check-obo-for-standard-release.pl --xref-abbs GO.xrf_abbs $(patsubst %,--disable-%,$(DISABLE)) $< > $@.tmp && mv $@.tmp $@

GO.xrf_abbs: envo-edit.owl
	wget http://geneontology.org/doc/GO.xrf_abbs -O $@ && touch $@

# ----------------------------------------
# SLIMS
# ----------------------------------------
# These all depend on envo-basic, which is the whole ontology (ie all classes), minus non-basic axioms (e.g. complex owl axioms, some relations)

# Update to use full ENVO graph, as other ontology terms may be included


subsets/%.owl: subsets/envo-basic.obo
	$(OWLTOOLS) $< --extract-ontology-subset --fill-gaps --subset $* -o $@.tmp && \
	$(ROBOT) annotate -i $@.tmp --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@  -a owl:versionInfo $(TODAY) \
	  --output $@
.PRECIOUS: subsets/%.owl
subsets/%.obo: subsets/%.owl
	$(OWLTOOLS) $< -o -f obo --no-check $@.tmp && grep -v ^owl-axioms: $@.tmp > $@



# ----------------------------------------
# Reports
# ----------------------------------------
REPORTS=edges basicReport termTable tags stats subsetTable
all_reports: $(patsubst %, reports/envo-%.tsv, $(REPORTS))

reports/envo-%.tsv: envo.owl sparql/%.sparql
	arq --data $< --query sparql/$*.sparql --results tsv > $@.tmp && mv $@.tmp $@


# ----------------------------------------
# Sparql queries: Q/C
# ----------------------------------------

# these live in the ../sparql directory, and have suffix -violation.sparql
# adding the name here will make the violation check live.
# NOTE: these will soon be phased out and replaced by robot-report

#  run all violation checks
SPARQL_VALIDATION_QUERIES = $(foreach V,$(SPARQL_VALIDATION_CHECKS),$(SPARQLDIR)/$V-violation.sparql)
sparql_test: $(SRC)
	$(ROBOT) verify  --catalog catalog-v001.xml -i $< --queries $(SPARQL_VALIDATION_QUERIES) -O reports/


# ----------------------------------------
# Temp
# ----------------------------------------
mappings/gold-mapping.txt: envo.owl
	blip-findall -u metadata_nlp_parent_dist2_hook -r obol_av -i sources/gold.obo -i $< -u metadata_nlp -goal index_entity_pair_label_match "entity_pair_label_reciprocal_best_intermatch(X,Y,S)" -use_tabs -label -no_pred > $@.tmp && cut -f1-4 $@.tmp | sort -u > $@



# ----------------------------------------
# Modules (from envo-p)
# ----------------------------------------


all_modules: all_modules_owl all_modules_obo
all_modules_owl: $(ALL_MODS_OWL)
all_modules_obo: $(patsubst %, modules/%.obo, $(MODS))

modules/%.owl: modules/%.csv patterns/%.yaml curie_map.yaml
	dosdp-tools --table-format=csv --template=./patterns/$*.yaml --outfile=modules/$*.tmp.owl --obo-prefixes=true generate --infile=modules/$*.csv
	$(ROBOT) annotate --input modules/$*.tmp.owl -O http://purl.obolibrary.org/obo/envo/modules/$*.owl --output modules/$*.owl && rm modules/$*.tmp.owl

modules/%.obo: modules/%.owl
	$(OWLTOOLS) $< -o -f obo $@.tmp && grep -v ^owl-axioms $@.tmp > $@

modules/ebi_biomes.owl: modules/ebi_biomes.csv
	$(ROBOT) template --template $< -i imports/ro_import.owl -o $@.tmp.owl && mv $@.tmp.owl $@

envo-edit.csv: envo-edit.owl
	$(OWLTOOLS) $(USECAT) $< --merge-support-ontologies --export-table $@.tmp && cut -f1 $@.tmp | grep ENVO_ | perl -npe 's@https@http@' > $@

fill: envo-edit.csv
	fill-col1-ids.pl --min 9000000 -m 10000000  $(ALL_MODS_CSV) $<

# meta

#modules/%.tsv:
#	blip-findall -i patterns/spec.obo  -consult pmaker.pro -r envo -r chebi -r pato pattern_$*/3 -no_pred -label -use_tabs > $@
