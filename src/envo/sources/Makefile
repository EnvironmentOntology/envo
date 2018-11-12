align-igsn.tsv: igsn.txt
	rdfmatch -i prefixes.ttl -f tsv -l -A ~/repos/onto-mirror/void.ttl -t $< -i envo exact > $@.tmp && mv $@.tmp $@

align-lter.tsv: lter.obo
	blip-findall -i $< -i ../envo.obo -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'LTER'),entity_pair_label_reciprocal_best_intermatch(X,Y,S),id_idspace(Y,'ENVO'),\+entity_xref_idspace(Y,Z,'LTER')" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

align-lter-chebi.tsv: lter.obo
	blip-findall -i $< -r chebi -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'LTER'),entity_pair_label_reciprocal_best_intermatch(X,Y,S),id_idspace(Y,'CHEBI'),\+entity_xref_idspace(Y,Z,'LTER')" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

align-%.tsv: %.obo
	blip-findall -i $< -i ../envo.obo -u metadata_nlp -goal index_entity_pair_label_match "entity_pair_label_reciprocal_best_intermatch(Y,X,S),id_idspace(X,'ENVO')" -select "x(X,Y,S)" -label -use_tabs -no_pred | grep -i $* > $@.tmp && mv $@.tmp $@

# TODO
no-align-%.txt: %.obo
	blip-findall -i $< -i ../envo-edit.obo "class(X),id_idspace(X,'SPIRE'),\+entity_xref(E,X)" -select X -label > $@

envo-sweet-align.txt:
	blip-findall -u metadata_nlp  -i realm.obo -r envo -goal index_entity_pair_label_match "entity_pair_label_reciprocal_best_intermatch(X,Y,S),belongs(Y,sweet),id_idspace(X,'ENVO')" -select X-Y -label -use_tabs -no_pred > $@.tmp && sort -u $@.tmp > $@

lter-controlled-vocabulary.rdf:
	wget http://vocab.lternet.edu/$@ -O $@

lter.obo: lter-controlled-vocabulary.rdf
	xmlstarlet fo $<  | ./skos2obo.pl > $@

GEMETS = backbone definitions groups
GEMETFS = $(patsubst %,gemet-%.rdf,$(GEMETS))

gemet-backbone.rdf:
	wget http://www.eionet.europa.eu/gemet/gemet-backbone.rdf -O $@

gemet-definitions.rdf:
	wget 'http://www.eionet.europa.eu/gemet/gemet-definitions.rdf?langcode=en' -O $@

gemet-groups.rdf:
	wget 'http://www.eionet.europa.eu/gemet/gemet-groups.rdf?langcode=en' -O $@

gemet-all.rdf: $(GEMETFS)
	rdfcat $^ > $@

gemet.obo: priority-gemet.tsv 
	perl -npe 's//GEMET:/' $< | cut -f1,2 | tbl2obo.pl  > $@

gemet-labels.txt: priority-gemet.tsv
	cut -f2 $<  > $@

GEMETX = eo envo chebi

gemet: $(patsubst %, xrefs-gemet-%.obo,$(GEMETX)) summary-xrefs-gemet.txt

align-gemet-%.tsv: gemet.obo
	blip-findall -i ignore_gemet.pro -i $< -r $* -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'GEMET'),entity_pair_label_reciprocal_best_intermatch(X,Y,S)" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@
.PRECIOUS: align-gemet-%.tsv

xrefs-%.obo: align-%.tsv
	cut -f1-4 $< | sort -u | tbl2obolinks.pl --rel xref - > $@

align-%.pro: align-%.tsv
	cut -f1-4 $< | tbl2p -p m > $@

unmapped-%.tsv: align-%.pro %.obo
	blip-findall -i $< -i $*.obo "class(X),\+m(_,_,X,_)" -select X -label > $@

summary-xrefs-%.txt:
	grep -c ^id: xrefs-$*-*.obo


align-earth: xrefs-earth-envo.obo

earth.rdf:
	wget http://thesaurus.iia.cnr.it/images/thesaurus/earth.rdf -O $@

PREFIXMAPF = prefixes.yaml
earth.obo: earth.rdf
	skos2obo.py -p $(PREFIXMAPF) $< > $@.tmp && mv $@.tmp $@ && ./fix-earth.pl $@


align-earth-%.tsv: earth.obo
	blip-findall -i ignore_gemet.pro -i $< -r $* -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'EARTH'),entity_pair_label_reciprocal_best_intermatch(X,Y,S)" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@
.PRECIOUS: align-earth-%.tsv


# SWEET
sweet.zip:
	wget --no-check-certificate https://sweet.jpl.nasa.gov/sites/default/files/2.3.zip -O $@

sweet/%.obo: sweet/%.owl
	owltools $< -o -f obo $@

geonames.obo: geonames-orig.obo
	./fix-geonames.pl $< > $@

featureCodes_en.txt:
	http://download.geonames.org/export/dump/featureCodes_en.txt


# https://github.com/EnvironmentOntology/envo/issues/333
soil.ttl:
	wget --no-check-certificate https://github.com/EnvironmentOntology/envo/files/1779245/orders.ttl.txt -O $@


## NEW

edit.ttl: ../envo-edit.owl
	owltools --catalog-xml ../catalog-v001.xml $< -o -f ttl $@

obo-%.owl:
	wget --no-check-certificate $(OBO)/$*.owl -O $@
.PRECIOUS: obo-%.owl

SKOSMAP = ../imports/skos-mappings.owl
envo-meo.tsv:
	rdfmatch -c ../../plq/envo_queries.pro -p ENVO -l -X tmp -i $(SKOSMAP)  -f tsv -v -i ../envo.owl -i meo09.ttl unique_match  > $@
other-%-meo.tsv: obo-%.owl
	test -d tmp-$* || mkdir -p tmp-$* 
	rdfmatch -c ../../plq/envo_queries.pro -p MEO -l -X tmp-$* -i $(SKOSMAP)  -f tsv -v -i $< -i meo09.ttl unique_match  > $@.tmp && grep -i $* $@.tmp > $@

lexrules-%.pro: edit.ttl
	test -d tmp-$* || mkdir -p tmp-$*
	rdfmatch --ontA ENVO --ontB $(shell echo $* | tr a-z A-Z) -l -c  ../../plq/envo_queries.pro  -X tmp-$* -f tsv -v -i $< -i $(SKOSMAP)  -i $*.owl  learn > $@
.PRECIOUS: lexrules-%.pro
