OBO = http://purl.obolibrary.org/obo
OTPATH =
OWLTOOLS = OWLTOOLS_MEMORY=10G $(OTPATH)owltools

all: gaz.owl gaz-as-classes.owl

src/gaz.obo:
	cd src && wget -N --no-check-certificate 'https://www.dropbox.com/s/h5njkvs6bfwsihc/gaz.obo%20copy' && cp gaz.obo\ copy $@

gaz.obo: src/gaz.obo
	perl -np fix.pl $< > $@.tmp && ./gaz-swap-relations.pl $@.tmp gaz-relations.obo > $@

gaz-as-classes.owl: gaz.obo
	$(OWLTOOLS) $< --set-ontology-id $(OBO)/gaz/gaz-as-classes.owl -o $@

gaz-abox.owl: gaz.obo
	$(OWLTOOLS) $< --tbox-to-abox -p --set-ontology-id $(OBO)/$@ -o $@

gaz.owl: gaz-abox.owl
	$(OWLTOOLS) $< --add-imports-declarations  $(OBO)/envo.owl gaz-to-envo.ttl --merge-support-ontologies  -o $@
