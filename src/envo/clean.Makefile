.PHONY: clean

clean:
	# Remove common release artifacts
	rm -f ../../envo.{owl,obo,json}
	rm -f ../../envo-base.owl
	rm -f ../../imports/*_import.{owl,obo}
	rm -f ../../subsets/*.{owl,obo,json,tsv}
	rm -f imports/*_import.{owl,obo}
	rm -f envo.{owl,obo,json}
	rm -f envo-base.owl
	rm -f envo-simple.owl
	rm -f envo-edit.csv
	rm -f debug.owl

	# Remove module outputs
	rm -f modules/*.owl

	# Remove DOSDP outputs
	rm -f patterns/matches/logical/*.tsv
	rm -rf patterns/matches/annotations
	rm -f tmp/tags-dosdp.{tsv,owl}

	# Remove reports
	rm -f reports/envo-*.tsv
