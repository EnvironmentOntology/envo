These notes are for the EDITORS of envo

== Preliminary ==

Make sure you are using Protege 4 or Protege 5

More docs will be added here later. For now, crib from:
https://github.com/Planteome/plant-trait-ontology/blob/master/README-editors.txt


=== Plugins ===

http://wiki.geneontology.org/index.php/Ontology_editor_plugins

Elk and the obsoletion plugins are a must

== Editors Version ==

NOTE: we have switched to OWL as the edit version

The editors version is envo-edit.obo

** DO NOT EDIT envo.obo OR envo.owl **

envo.obo is the release version

== Checklist: Read this before starting ==

Do you have an ID range in the idranges file (hp-idranges.owl), in
the src/ontology/ directory)? If not, Chris can add one for you.

Ensure that you have Protege configured to generate new URIs in your
own range. Note that if you edit multiple files, you need to check this every time to ensure that the proper settings are in place. 
Do a test to ensure that the ID generator is working properly.

A word of caution about protege auto-id functionality. Protege will allow reuse of a URI in your range according to the numbering scheme. It will keep track of what you did during last session, but *does not check* for use of the URI before assigning it (doh!!). Therefore, if you added any IDs in your range prior to the switch to OWL, protege will not know not to start from the beginning. Some tips to check to see where you are in your range: Go to the view menu, click "render by label (rdf:id)", and then use the search box to search for things starting within your range, such as HP_04 for Melissa's range. If you have IDs in your range already, you may wish to set Protege at the next unused ID in your range rather than the beginning of the range. It should then remember it for next time, though you should double check.


== ID Ranges ==

These are stored in the file

  src/envo/envo-idranges.owl

** ONLY USE IDs WITHIN YOUR RANGE!! **

Note: you may want to have a 2nd range if you plan to edit an
experimental ENVO module that doesn't sit within the main file, e.g. envo-process.owl

=== Setting ID ranges in Protege ===
 
== Derived Files ==

== Subversion Guide ==

=== PC users ===

 * http://mzaher.wordpress.com/2009/03/02/how-to-use-svn-with-google-code/

== Release Manager notes ==

to release:
 $ svn copy -m "Creating release branch" https://envo.googlecode.com/svn/trunk/src/ontology https://envo.googlecode.com/svn/releases/envo/YYYY-MM-DD

Chris Mungall is the acting release manager for now, but this role should be taken over by someone in the RCN project

== Jenkins Continuous Integration System ==

Check:

http://build.berkeleybop.org/job/build-envo/

after committing

Contact Chris Mungall for access to the Jenkins CI system

== General Guidelines ==

See:
http://wiki.geneontology.org/index.php/Curator_Guide:_General_Conventions
