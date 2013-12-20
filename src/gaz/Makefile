OBO = http://purl.obolibrary.org/obo
OTPATH =
OWLTOOLS = OWLTOOLS_MEMORY=10G $(OTPATH)owltools

all: gaz.owl gaz-as-classes.owl

src:
	mkdir $@

# https://www.dropbox.com/l/PUJtJW9k6HkbMo6VErsme8
src/gaz.obo: trigger src
	cd src && wget --no-check-certificate 'https://www.dropbox.com/s/h5njkvs6bfwsihc/gaz.obo%20copy' -O $@

gaz.obo: src/gaz.obo
	perl -np fix.pl $< > $@.tmp && ./gaz-swap-relations.pl $@.tmp gaz-relations.obo > $@

gaz-as-classes.owl: gaz.obo
	$(OWLTOOLS) $< --set-ontology-id $(OBO)/gaz/gaz-as-classes.owl -o $@

gaz-abox.owl: gaz.obo
	$(OWLTOOLS) $< --tbox-to-abox -p --set-ontology-id $(OBO)/$@ -o $@

gaz.owl: gaz-abox.owl
	$(OWLTOOLS) $< --add-imports-declarations  $(OBO)/envo.owl gaz-to-envo.ttl --merge-support-ontologies  -o $@
