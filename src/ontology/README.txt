
** ENVO editors please read README-editors.txt

== Summary ==

This repo contains a number of files intended for either general or editorial use. It's generally a better option to use PURLs to access the version of ENVO you want. Please see environmentontology.org/downloads.

Some interesting files in this repo include:

envo/
  envo.obo <-- the current release version of ENVO in OBO format 
  envo.owl <-- the current release version of ENVO in OWL format 
  subsets/
   envo-basic.obo <-- the current release version of ENVO in OBO format, with no MIREOTed classes
   EnvO-Lite-GSC.obo <-- A subset of ENVO generated for GSC use in OBO format 
   EnvO-Lite-GSC.owl <-- A subset of ENVO generated for GSC use in OWL format 
  src/
   envo/
    envo-edit.owl  <-- for use by ENVO editors only! Pre-release version!
    reports/
     envo-edges.csv <-- A CSV representation of ENVO's class hiearchy

== Details ==

Complete Version (envo.obo, envo.owl):

The complete version of the ontology includes "MIREOT"ed subsets of
other ontologies such as CHEBI required in order to complete logical
definitions.

Basic Version (envo-basic.obo):

The basic version of the ontology EXCLUDES any external ontology terms
and any relationships that link to them.

Which version should you use?

Use of the complete version is encouraged; however, some systems have
expectations of ontologies that are broken by the complete version
(e.g. OLS does not allow mixed IDs), so envo-basic.obo may be more
appropriate in some contexts.


== Identifiers ==
Each ENVO class has a unique identifier matching the regular expression:
"ENVO:[0-9]{7,8}$"
In other words, the string "ENVO:" followed by a numeric identifier either 7 or 8 characters long and stopped by end of line in this example.




