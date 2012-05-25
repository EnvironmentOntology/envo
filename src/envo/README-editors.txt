These notes are for the EDITORS of envo

== Editors Version ==

The editors version is envo-edit.obo

** DO NOT EDIT envo.obo OR envo.owl **

envo.obo is the release version

== ID Ranges ==

These are stored in the file

  src/envo/envo-idranges.owl

** ONLY USE IDs WITHIN YOUR RANGE!! **

=== Setting ID ranges in OBO-Edit ===

TODO

== Derived Files ==

== Subversion Guide ==

=== PC users ===

 * http://mzaher.wordpress.com/2009/03/02/how-to-use-svn-with-google-code/

== Release Manager notes ==

to release:
 $ svn copy -m "Creating release branch" https://envo.googlecode.com/svn/trunk/src/ontology https://envo.googlecode.com/svn/releases/envo/YYYY-MM-DD

Chris Mungall is the acting release manager for now, but this role should be taken over by someone in the RCN project

== Jenkins Continuous Integration System ==

Contact Chris Mungall for access to the Jenkins CI system
