
** ENVO editors please read README-editors.txt

== Summary ==

 src/
  envo/
    envo-edit.obo  <-- for use by ENVO editors only
    envo.obo       <-- release version, COMPLETE - includes MIREOTed ontologies
    envo-basic.obo <-- release version, BASIC - no MIREOTed ontologies

== Details ==

Complete Version (envo.obo):

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
ENVO:[0-9]{7,8}
In other words, the string "ENVO:" followed by a numeric identifier either 7 or 8 characters long.




