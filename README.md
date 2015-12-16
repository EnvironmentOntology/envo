[![Build Status](https://travis-ci.org/EnvironmentOntology/envo.svg?branch=master)](https://travis-ci.org/EnvironmentOntology/envo)
[![DOI](https://zenodo.org/badge/13996/EnvironmentOntology/envo.svg)](https://zenodo.org/badge/latestdoi/13996/EnvironmentOntology/envo)

#The Environment Ontology


A description of the Environment Ontology (ENVO) is published in the Journal of Biomedical Semantics in an article by [Buttigieg et al.](http://dx.doi.org/10.1186/2041-1480-4-43).

More information and guides for using ENVO in annotation exercises are available at www.environmentontology.org

##Aim and Scope

ENVO is a domain ontology concerned with "environments" of all kinds and aims to promote standardisation and interoperability of diverse data sets through the concise, controlled description of environment types across several levels of granularity. It is primarily concerned with environments as encountered in ecological applications, but is able to accommodate alternative needs.

ENVO currently deals with 'environmental systems' (i.e. environments) particularly 'biomes' and environments determined by a material entity that assumes the role of an 'environmental feature' (e.g. a digestive tract environment). It also handles 'environmental materials' like soil, water, and so on. 

## Versions
###Stable release versions
ENVO's latest release version can be downloaded in OWL and OBO format from the following links:
http://purl.obolibrary.org/obo/envo.owl
http://purl.obolibrary.org/obo/envo.obo

Please note that the files above include all the imported classes from ontologies referenced by ENVO. If you would like a "simple" version with only ENVO classes, please download it from:
http://purl.obolibrary.org/obo/subsets/envo-basic.obo

###Subsets
Several subsets of ENVO classes are identified with the "in_subset" annotation property.
* environmental_hazards: concerned with environmental entities and processes associated with hazards.
* EnvO-Lite-GSC: a short list of classes used to annotate records of relevance to the Genomic Standards Consortium.
More subsets can be generated on request (please post such requests on our [issue tracker](https://github.com/EnvironmentOntology/envo/issues).

###Editors' version
The editors' version of ENVO, envo-edit.owl, can be downloaded here:
https://github.com/EnvironmentOntology/envo/blob/master/src/envo/envo-edit.owl
This version is subject to frequent change and should be used with caution.

##Contact
Please use this GitHub repository's [Issue tracker](https://github.com/EnvironmentOntology/envo/issues) to request new terms/classes or report errors or specific concerns related to the ontology.

If you would like to send a more general comment or question to the EnvO mailing list, please [subscribe and post a message](https://lists.sourceforge.net/lists/listinfo/obo-envo). This open mailing list is the best place to post general questions or comments for discussion in the wider EnvO community. Please note, your posts will be stored in [publicly accessible archives](http://sourceforge.net/mailarchive/forum.php?forum_name=obo-envo).


##History
The repository was moved to this location from https://code.google.com/p/envo/ in March 2015. The ENVO PURL will continue to point to the Google Code repository until the next release, at which point this message will be updated. 
