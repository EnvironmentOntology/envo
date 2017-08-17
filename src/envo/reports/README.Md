#  What are ENVO reports?

Our reports directory is a fairly diverse collection of exports that we derive from the full envo.owl file using SPARQL queries. 

We create these to create easy-to-parse documents that help users get to key content. There's quite a lot of overlap between some reports, but each has its role. We're happy to cook up new reports on request and integrate their generation into our standard release cycle.

# Existing reports

### envo-basicReport.tsv

A very simple mapping of each class' PURL (webresolvable URI) and textual definition.

### envo-edges.tsv

This file is a tabular summary of the relationships between classes in ENVO. It has the following structure:

?x |	?xl |	?p |	?pl |	?y |	?yl
--|--|--|--|--|--
The 'subject' class' PURL | The 'subject' class' label | The relationship between the subject and object classes |  The 'object' class' PURL | The 'object' class' label

This can be used to build a table-based representation of the linkages in ENVO. 


### envo-stats.tsv

We use this file to output basic stats about the ontology. Currently, this only reports the number of classes present in the envo.owl file, including imported classes from other ontologies.

### envo-subsetTable.tsv

This report is a tsv summary of all terms that have been assigned to [subsets](https://github.com/EnvironmentOntology/envo/wiki/Subsets) requested by our users.
It has the following columns:

?label | ?subset	| ?definition |	?URI
--|--|--|--
The label is the preferred name of the class | This is the subset which the class belongs to. See [this wiki page](https://github.com/EnvironmentOntology/envo/wiki/Subsets) for more on subsets | The textual definition of the class | The unique, web-resolvable IRI of the class.

### envo-tags.tsv

This report contains the class label and synonyms in the "long" data format. This information is useful for text mining exercises. Many of our synonyms require revision, and feedback via our tracker is always appreciated.

?label	| ?exact |	?broad |	?narrow |	?related |	?subset |	?uri
--|--|--|--|--|--|--
The label is the preferred name of the class |  An exact synonym of the class, usually very semantically close |	A broad synonym of the class; we try to make these superclasses when possible, but sometimes semantic ambiguity prevents this  |	A narrow synonym of the class; we try to make these subclasses when possible, but sometimes semantic ambiguity prevents this |	A related synonym of the class, with a fuzzy association |	A note indicating if the class is in a  subset  |	The class' webresolvable URI

### envo-termTable.tsv

A spreadsheet-friendly representation of ENVO's labels, synonyms, and URIs.

?label | ?definition |	?exactSynonym |	?broadSynonym |	?narrowSynonym |	?relatedSynonym |	?subsetType |	?uri
The label is the preferred name of the class |  A pipe (|) separated list of exact synonyms | A pipe (|) separated list of broad synonyms | A pipe (|) separated list of narrow synonyms | A pipe (|) separated list of related synonyms | The class' webresolvable URI

