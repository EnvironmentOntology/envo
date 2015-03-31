SRC= ../envo.obo

all: spire-mapping.tsv spire-mapping-by-type.tsv geonames-mapping.tsv sweetrealm-mapping.tsv lter-mapping.tsv

%-mapping.tsv: ../sources/%.obo $(SRC)
	blip-findall -i $< -i $(SRC) "entity_xref(E,X),id_idspace(X,S),downcase_atom(S,'$*')" -select X-E -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

%-mapping-by-type.tsv: ../sources/%.obo $(SRC)
	blip-findall -i $< -i $(SRC) "entity_xref(E,X),id_idspace(X,S),downcase_atom(S,'$*'),subclassT(E,T),\+subclass(T,_)" -select "x(T,X,E)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

%-unmapped.tsv: ../sources/%.obo $(SRC)
	blip-findall -i $< -i $(SRC) "class(X),id_idspace(X,'LTER'),\+entity_xref(_,X),subclassT(X,Root),\+subclass(Root,_)" -select X-Root -label -no_pred | sort -k2 -t$$'\t' > $@.tmp && mv $@.tmp $@
