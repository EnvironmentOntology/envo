# This Makefile is for use by the ENVO Release Manager (currently cjm)
# Also used by Jenkins: http://build.berkeleybop.org/job/build-envo
# 
# requirements: Oort (http://code.google.com/p/owltools/wiki/OortIntro)
#
# To make a release, type 'make release' in this directory

OBO=http://purl.obolibrary.org/obo
USECAT= --catalog-xml catalog-v001.xml
MODS = entity_attribute_location entity_quality_location entity_attribute process_attribute
ALL_MODS_OWL = $(patsubst %, modules/%.owl, $(MODS))
ALL_MODS_CSV = $(patsubst %, modules/%.csv, $(MODS))
ROBOT= robot
OWLTOOLS= owltools

all: build

#include Makefile-OBO

test: envo-edit.owl all_modules all_imports envo.owl
travis_test: test_python envo-edit.owl all_modules envo.owl

full_test: test envo.check-obo subsets/EnvO-Lite-GSC.check-obo

# temp test for travis
test_python:
	python3 --version

build: all_modules all_imports envo.owl envo.obo envo.json subsets/envo-basic.obo subsets/envo-basic.json subsets/EnvO-Lite-GSC.obo 

prepare_release: build  copy-release

copy-release:
	cp -pr catalog-v001.xml envo.obo envo.owl envo.json subsets mappings imports ../..

# generic conversion for OGs
%.json: %.owl
	robot convert -input $< -o $@

debug.owl: envo-edit.owl
	owltools --use-catalog  $< --merge-support-ontologies --run-reasoner -r elk -u -m $@

#release: envo-basic.obo release-diffs

# Merge in all module files, whilst removing the corresponding import
envo-edit-module-merge.owl: envo-edit.owl
	owltools $(USECAT) $<  $(patsubst %, --remove-import-declaration $(OBO)/envo/modules/%.owl, $(MODS)) -o $@.tmp
	owltools $(USECAT) $@.tmp  $(ALL_MODS_OWL) --merge-support-ontologies -o $@

envo.owl: envo-edit-module-merge.owl
	robot reason -i $< -r ELK relax reduce -o $@

envo-simple.owl: envo.owl
	owltools --use-catalog $< --remove-imports-declarations --remove-dangling-annotations -o $@


###	ontology-release-runner --catalog-xml catalog-v001.xml --reasoner elk  --skip-format owx --skip-format obo  --error-report envo-errors.txt $< --allow-overwrite --asserted --simple
##	ontology-release-runner --catalog-xml catalog-v001.xml  --skip-format owx --run-obo-basic-dag-check --error-report envo-errors.txt $< --allow-overwrite --asserted --simple

#envo.owl: envo-edit.owl
#	robot reason -s true --input $< --reasoner elk --output $@


.PRECIOUS: envo.obo

envo.obo: envo.owl
	owltools $(USECAT) $< --merge-imports-closure --add-obo-shorthand-to-properties -o -f obo --no-check $@.tmp && grep -v ^owl-axioms $@.tmp > $@


# TODO - fix IRI
subsets/envo-basic.owl: envo-simple.owl
	owltools $< imports/ro_import.owl --merge-imports-closure --set-ontology-id $(OBO)/$@ -o $@.tmp && mv $@.tmp $@

subsets/envo-basic.obo: envo-simple.owl
	owltools $< imports/ro_import.owl --merge-imports-closure  --add-obo-shorthand-to-properties --set-ontology-id $(OBO)/$@ -o -f obo --no-check $@.tmp && grep -v ^owl-axioms $@.tmp > $@

#envo-mireot.obo: envo-edit.owl chebi-lite.obo pato-lite.obo
#	ontology-release-runner --no-subsets --skip-format owx --run-obo-basic-dag-check --no-reasoner --allow-overwrite --asserted --outdir build $< chebi-lite.obo pato-lite.obo && cp build/envo-merged.obo $@

#chebi-lite.obo: 
#	owltools $(OBO)/chebi.obo --make-subset-by-properties -o -f obo $@
#pato-lite.obo: 
#	owltools $(OBO)/pato.obo --make-subset-by-properties -o -f obo $@

release-diffs:
	cd diffs && make


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

# Ontology dependencies
# We don't include clo, as this is currently not working
IMPORTS = pato uberon chebi ro pco foodon go ncbitaxon  obi po iao fao agro

# Make this target to regenerate ALL
all_imports: $(patsubst %, imports/%_import.owl,$(IMPORTS)) $(patsubst %, imports/%_import.obo,$(IMPORTS))

SEEDS= $(patsubst %, imports/%_terms.txt,$(IMPORTS))


KEEPRELS = BFO:0000050 BFO:0000051 RO:0002202 immediate_transformation_of RO:0002176 IAO:0000136

# See https://github.com/EnvironmentOntology/envo/issues/521
imports/seed.tsv: envo-edit.owl $(ALL_MODS_OWL)
	owltools $(USECAT) $< --merge-imports-closure --export-table $@.tmp && cut -f1 $@.tmp | grep purl.obolib | sort -u > $@

imports/%_combined_seed.tsv: imports/%_terms.txt imports/seed.tsv
	cut -f1 $^ | sort -u > $@

# Create an import module using the OWLAPI module extraction code via OWLTools.
# We use the standard catalog, but rewrite the import to X to be a local mirror of ALL of X.
# After extraction, we further reduce the ontology by creating a "mingraph" (removes all annotations except label) and by 
imports/%_import.owl: mirror/%.owl envo-edit.owl imports/%_combined_seed.tsv
	robot extract -i $< -T imports/$*_combined_seed.tsv -m BOT -O $(ENVO_IMPORTS_BASE_URI)/$@ -o $@.tmp.owl && mv $@.tmp.owl $@

imports/%_import.obo: imports/%_import.owl
	owltools $(USECAT) $< -o -f obo --no-check $@



# clone remote ontology locally, perfoming some excision of relations and annotations
mirror/%-local.owl:
	wget --no-check-certificate $(OBO)/$*.owl -O $@
.PRECIOUS: mirror/%-local.owl

mirror/%.owl: mirror/%-local.owl
	owltools $< --remove-annotation-assertions -l --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS)  -o $@
.PRECIOUS: mirror/%.owl

mirror/clo.owl: envo-edit.owl
	owltools $(OBO)/clo.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/clo.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/agro.owl: envo-edit.owl
	owltools $(OBO)/agro.owl $(REMOVE_SELF_REF) --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/agro.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/sdgio.owl: envo-edit.owl
	owltools http://purl.unep.org/sdg/sdgio.owl $(REMOVE_SELF_REF)  --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id http://purl.unep.org/sdg/sdgio.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/obi.owl: envo-edit.owl
	owltools $(OBO)/obi.owl --remove-classes-in-idspace GO --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/obi.owl -o $@
.PRECIOUS: mirror/%.owl


mirror/foodon.owl: envo-edit.owl
	owltools $(OBO)/foodon.owl --merge-imports-closure $(REMOVE_SELF_REF) --remove-annotation-assertions -l -s -d --remove-axiom-annotations  --set-ontology-id $(OBO)/foodon.owl -o $@
.PRECIOUS: mirror/%.owl

# chebi.owl is large and the owlapi often times out when reading it; use the obo instead
mirror/chebi-local.owl: envo-edit.owl
	wget --no-check-certificate $(OBO)/chebi.owl -O $@ && touch $@
mirror/chebi.owl: mirror/chebi-local.owl
	owltools --no-debug $< --log-debug --remove-annotation-assertions -l --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS)  -o $@
.PRECIOUS: mirror/%.owl

#mirror/ro.owl: mirror/ro-relations.owl mirror/ro-classes.owl
#	owltools $^ --merge-support-ontologies -o $@
mirror/ro.owl:
	owltools $(OBO)/ro.owl --merge-imports-closure -o $@
.PRECIOUS: mirror/ro.owl

mirror/ro-relations.owl: envo-edit.owl
	owltools $(OBO)/ro.owl --merge-imports-closure --remove-tbox --remove-dangling -o $@
mirror/ro-classes.owl: envo-edit.owl
	owltools $(OBO)/ro.owl --merge-imports-closure --make-subset-by-properties -f // --remove-external-classes -k RO --remove-annotation-assertions -l -s -d  -o $@

mirror/bfo.owl: envo-edit.owl
	owltools $(OBO)/bfo.owl --merge-imports-closure --make-subset-by-properties -f // --remove-external-classes BFO --remove-annotation-assertions -l -s -d  --remove-dangling --set-ontology-id $(OBO)/bfo.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/uberon.owl: envo-edit.owl
	owltools $(OBO)/uberon.obo  --remove-axiom-annotations  --make-subset-by-properties -f $(KEEPRELS) --remove-external-classes UBERON --remove-dangling-annotations --remove-annotation-assertions -l -s -d --set-ontology-id $(OBO)/uberon.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/po.owl: envo-edit.owl
	owltools $(OBO)/po.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/po.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/fao.owl: envo-edit.owl
	owltools $(OBO)/fao.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/fao.owl -o $@
.PRECIOUS: mirror/%.owl

ncbitaxon.obo:
	wget -N $(OBO)/ncbitaxon.obo
.PRECIOUS: ncbitaxon.obo

mirror/ncbitaxon.owl: ncbitaxon.obo
	OWLTOOLS_MEMORY=12G owltools $< --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations  --set-ontology-id $(OBO)/ncbitaxon.owl -o $@
.PRECIOUS: mirror/ncbitaxon.owl

mirror/pco.owl: envo-edit.owl
		owltools $(OBO)/pco.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/pco.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/iao.owl: envo-edit.owl
	owltools $(OBO)/iao.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/iao.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/omp.owl: envo-edit.owl
	owltools $(OBO)/omp.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/omp.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/pato.owl: envo-edit.owl
	owltools $(OBO)/pato.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/pato.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/flopo.owl: envo-edit.owl
	owltools $(OBO)/flopo.owl --remove-annotation-assertions -l -s -d --remove-axiom-annotations --remove-dangling-annotations --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/flopo.owl -o $@
.PRECIOUS: mirror/%.owl

# ----------------------------------------
# STYLE CHECKS
# ----------------------------------------
is_utf: envo-edit.owl
	iconv -f UTF-8 -t ISO-8859-15 $< > $@

# ----------------------------------------
# OBO CHECKS
# ----------------------------------------
# Check OE can parse the file.
# This requires installing oboedit, which comes with a cmd line app called obo2obo
%.check-obo: %.obo
	obo2obo -o $@ $<

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
subsets/envoMeo.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset envoMeo --iri $(OBO)/envo/$@ -o $@
subsets/envoMeo.obo: subsets/envoMeo.owl
	owltools $< -o -f obo $@

subsets/envoEmpo.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset envoEmpo --iri $(OBO)/envo/$@ -o $@
subsets/envoEmpo.obo: subsets/envoEmpo.owl
	owltools $< -o -f obo $@

subsets/envoOmics.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset envoOmics --iri $(OBO)/envo/$@ -o $@
subsets/envoOmics.obo: subsets/envoOmics.owl
	owltools $< -o -f obo $@

subsets/EnvO-Lite-GSC.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset EnvO-Lite-GSC --iri $(OBO)/envo/$@ -o $@
subsets/EnvO-Lite-GSC.obo: subsets/EnvO-Lite-GSC.owl
	owltools $< -o -f obo $@

subsets/environmental_hazards.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset environmental_hazards --iri $(OBO)/envo/$@ -o $@
subsets/environmental_hazards.obo: subsets/environmental_hazards.owl
	owltools $< -o -f obo $@

subsets/wwfBiome.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset wwfBiome --iri $(OBO)/envo/$@ -o $@
subsets/wwfBiome.obo: subsets/wwfBiome.owl
	owltools $< -o -f obo $@

subsets/nlcd2011.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset nlcd2011 --iri $(OBO)/envo/$@ -o $@
subsets/nlcd2011.obo: subsets/nlcd2011.owl
	owltools $< -o -f obo $@

subsets/envoPolar.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset envoPolar --iri $(OBO)/envo/$@ -o $@
subsets/envoPolar.obo: subsets/envoPolar.owl
	owltools $< -o -f obo $@

subsets/envoCesab.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset envoCesab --iri $(OBO)/envo/$@ -o $@
subsets/envoCesab.obo: subsets/envoCesab.owl
	owltools $< -o -f obo $@

subsets/envoAstro.owl: subsets/envo-basic.obo
	owltools $< --extract-ontology-subset --fill-gaps --subset envoAstro --iri $(OBO)/envo/$@ -o $@
subsets/envoAstro.obo: subsets/envoAstro.owl
	owltools $< -o -f obo $@



# ----------------------------------------
# Reports
# ----------------------------------------
REPORTS=edges basicReport termTable tags stats subsetTable
all_reports: $(patsubst %, reports/envo-%.tsv, $(REPORTS))

reports/envo-%.tsv: envo.owl sparql/%.sparql
	arq --data $< --query sparql/$*.sparql --results tsv > $@.tmp && mv $@.tmp $@


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
	apply-pattern.py -P curie_map.yaml -b http://purl.obolibrary.org/obo/ -i $< -p patterns/$*.yaml  > modules/$*.omn && owltools modules/$*.omn --set-ontology-id $(OBO)/envo/modules/$*.owl -o $@

modules/%.obo: modules/%.owl
	owltools $< -o -f obo $@.tmp && grep -v ^owl-axioms $@.tmp > $@


envo-edit.csv: envo-edit.owl
	owltools $(USECAT) $< --merge-support-ontologies --export-table $@.tmp && cut -f1 $@.tmp | grep ENVO_ | perl -npe 's@https@http@' > $@

fill: envo-edit.csv
	fill-col1-ids.pl --min 9000000 -m 10000000  $(ALL_MODS_CSV) $<

# meta

#modules/%.tsv:
#	blip-findall -i patterns/spec.obo  -consult pmaker.pro -r envo -r chebi -r pato pattern_$*/3 -no_pred -label -use_tabs > $@
