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

 In the Metadata menu, select the ID manager option. You can set the ID range of any 
 profile you create here by clicking on the settings icon (cog wheels) next to the profile 
 name. In the window that appears, you can set the ID range by editing the default rule: 
 "ID:$sequence(<number of digits>,<minimum of range>,<maximum of range>)$"
 Thus, "ENVO:$sequence(8,2000000,2999999)$" will set a range of 8 digit IDs from 200000 
 to 2999999.  
 
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
