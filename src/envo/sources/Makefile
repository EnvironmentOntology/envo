align-lter.tsv: lter.obo
	blip-findall -i $< -i ../envo.obo -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'LTER'),entity_pair_label_reciprocal_best_intermatch(X,Y,S),id_idspace(Y,'ENVO'),\+entity_xref_idspace(Y,Z,'LTER')" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

align-lter-chebi.tsv: lter.obo
	blip-findall -i $< -r chebi -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'LTER'),entity_pair_label_reciprocal_best_intermatch(X,Y,S),id_idspace(Y,'CHEBI'),\+entity_xref_idspace(Y,Z,'LTER')" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

align-%.tsv: %.obo
	blip-findall -i $< -i ../envo.obo -u metadata_nlp -goal index_entity_pair_label_match "class(X),id_idspace(X,'SPIRE'),entity_pair_label_reciprocal_best_intermatch(Y,X,S),id_idspace(Y,'ENVO'),\+((entity_xref(Y,Z),id_idspace(Z,'SPIRE')))" -select "x(X,Y,S)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

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
