OBO = http://purl.obolibrary.org/obo
OTPATH =
OWLTOOLS = OWLTOOLS_MEMORY=8G $(OTPATH)owltools

all: gaz.owl gaz-as-classes.owl

gaz.obo:
	wget -N --no-check-certificate https://dl.dropboxusercontent.com/s/orj1bonmvfjj61e/$@

gaz-fixed.obo: gaz.obo
	perl -pne fix.pl $< > $@

gaz-as-classes.owl: gaz-fixed.obo
	$(OWLTOOLS) $< --set-ontology-id $(OBO)/gaz/gaz-as-classes.owl -o $@

gaz-abox.owl: gaz-fixed.obo
	$(OWLTOOLS) gaz-fixed.obo --tbox-to-abox -p --set-ontology-id $(OBO)/$@ -o $@

gaz.owl: gaz-abox.owl
	$(OWLTOOLS) $< gaz-to-envo.ttl --merge-support-ontologies --add-imports-declarations $(OBO)/envo.owl -o $@
