%-mapping.txt: ../envo-edit.obo
	blip-findall -i $< "entity_xref(E,X),id_idspace(X,S),downcase_atom(S,'$*')" -select X-E -no_pred > $@.tmp && mv $@.tmp $@
