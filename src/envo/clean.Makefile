# prototype from ChatGPT

.PHONY: clean

clean:
	# Remove temporary and intermediate files
	rm -rf $(TMPDIR)/
	rm -rf tmp/
	cp reports/report_profile_edit.txt report_profile_edit.txt
	rm -rf reports/* # need to keep reports/report_profile_edit.txt
	cp report_profile_edit.txt reports/report_profile_edit.txt
	rm -rf modules/*.tmp.owl
	rm -rf modules/*.obo
	#rm -rf modules/*.owl # how are these recreated?
	rm -rf mirror/*.owl
	#rm -rf imports/*.owl # how are these recreated?
	rm -rf imports/*.obo
	rm -rf patterns/matches/logical/
	rm -rf patterns/matches/annotations/

	# Remove generated ontology files
	rm -f $(ONT).owl $(ONT).obo $(ONT).json
	rm -f $(ONT)-full.owl $(ONT)-full.obo $(ONT)-full.json
	rm -f $(ONT)-base.owl $(ONT)-base.obo $(ONT)-base.json
	#rm -f $(SRC) $(PRE_SRC) # $(SRC) = ??? ; $(PRE_SRC) = ???

	# Remove subset files
	rm -f subsets/*.owl subsets/*.obo subsets/*.json subsets/*.tsv

	# Remove downloaded or mirrored external ontologies
	rm -rf mirror/
	rm -f GO.xrf_abbs

	# Remove any temporary downloads or caches
	rm -rf diffs/
	rm -f *.tmp
	rm -f *.log

	# Optional: Remove release artifacts if generated
	rm -rf $(RELEASEDIR)/$(ONT).owl $(RELEASEDIR)/$(ONT).obo $(RELEASEDIR)/$(ONT).json
	rm -rf $(RELEASEDIR)/subsets/
	rm -rf $(RELEASEDIR)/mappings/
	rm -rf $(RELEASEDIR)/imports/
