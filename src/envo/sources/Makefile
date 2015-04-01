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
