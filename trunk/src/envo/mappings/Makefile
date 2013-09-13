SRC= ../envo-edit.obo

all: spire-mapping.txt spire-mapping-by-type.txt


%-mapping.txt: ../sources/%.obo $(SRC)
	blip-findall -i $< -i $(SRC) "entity_xref(E,X),id_idspace(X,S),downcase_atom(S,'$*')" -select X-E -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@

%-mapping-by-type.txt: ../sources/%.obo $(SRC)
	blip-findall -i $< -i $(SRC) "entity_xref(E,X),id_idspace(X,S),downcase_atom(S,'$*'),subclassT(E,T),\+subclass(T,_)" -select "x(T,X,E)" -label -use_tabs -no_pred > $@.tmp && mv $@.tmp $@
