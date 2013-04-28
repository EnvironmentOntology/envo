# This Makefile is for use by the ENVO Release Manager (currently cjm)
# Also used by Jenkins: http://build.berkeleybop.org/job/build-envo
# 
# requirements: Oort (http://code.google.com/p/owltools/wiki/OortIntro)
#
# To make a release, type 'make release' in this directory

OBO=http://purl.obolibrary.org/obo

release: envo-basic.obo release-diffs

# all release files are derived from the editors version.
# we use the default Oort setup (hermit as reasoner)
envo-simple.obo: envo-edit.obo
	ontology-release-runner --no-subsets --skip-format owx --run-obo-basic-dag-check --error-report envo-errors.txt $< --allow-overwrite --asserted --simple
.PRECIOUS: envo.obo

envo-basic.obo: envo-simple.obo
	cp envo-simple.obo $@

envo-mireot.obo: envo-edit.obo chebi-lite.obo pato-lite.obo
	ontology-release-runner --no-subsets --skip-format owx --run-obo-basic-dag-check --no-reasoner --allow-overwrite --asserted --outdir build $< chebi-lite.obo pato-lite.obo && cp build/envo-merged.obo $@

chebi-lite.obo: 
	owltools $(OBO)/chebi.obo --make-subset-by-properties -o -f obo $@
pato-lite.obo: 
	owltools $(OBO)/pato.obo --make-subset-by-properties -o -f obo $@

release-diffs:
	cd diffs && make
