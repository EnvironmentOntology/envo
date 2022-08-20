These notes are for the EDITORS of envo

For more details on ontology management, please see the OBO tutorial:

 * https://github.com/jamesaoverton/obo-tutorial
 
## Editing software

Currently, we edit envo-edit.owl with Protege 5.5.0 - please make sure you're synced!

## Editors Version

Do you have an ID range in the idranges file (envo-idranges.owl),
in this directory). If not, get one from the head curator. 

The editors version is [envo-edit.owl](envo-edit.owl)

** DO NOT EDIT envo.obo OR envo.owl **

The editors version can be edited using Protege

## ID Ranges

TODO - these are not set up

These are stored in the file

 * [envo-idranges.owl](envo-idranges.owl)

** ONLY USE IDs WITHIN YOUR RANGE!! **
** NOTE THAT ENVO USES 8 DIGITS, NOT 7 LIKE OTHER ONTOLOGIES **

## Editing Template CSVs

We use both robot and dosdp templates.

Both use the CSVs in the [modules](modules/) directory.

** REMEMBER TO SAVE CSVs USING LF (NOT CRLF) AS NEWLINES **
If you forget you should be able to convert using dos2unix.
Pier uses Notepad++ which can save as either
 
## Git Quick Guide

TODO add instructions here

## Release Manager notes

You should only attempt to make a release AFTER the edit version is
committed and pushed, and the travis build passes.

to release:

    cd src/ontology
    make

If this looks good type:

    make release

This generates derived files such as envo.owl and envo.obo and places
them in the top level (../..). The versionIRI will be added.

Commit and push these files.

    git commit -a

And type a brief description of the release in the editor window

IMMEDIATELY AFTERWARDS (do *not* make further modifications) go here:

 * https://github.com/EnvironmentOntology/envo/releases
 * https://github.com/EnvironmentOntology/envo/releases/new

The value of the "Tag version" field MUST be

    vYYYY-MM-DD

The initial lowercase "v" is REQUIRED. The YYYY-MM-DD *must* match
what is in the versionIRI of the derived envo.owl (data-version in
envo.obo).

Release title should be YYYY-MM-DD, optionally followed by a title (e.g. "january release")

Then click "publish release"

__IMPORTANT__: NO MORE THAN ONE RELEASE PER DAY.

The PURLs are already configured to pull from github. This means that
BOTH ontology purls and versioned ontology purls will resolve to the
correct ontologies. Try it!

 * http://purl.obolibrary.org/obo/envo.owl <-- current ontology PURL
 * http://purl.obolibrary.org/obo/envo/releases/YYYY-MM-DD.owl <-- change to the release you just made

For questions on this contact Chris Mungall or email obo-admin AT obofoundry.org

# Travis Continuous Integration System

Check the build status here: [![Build Status](https://travis-ci.org/EnvironmentOntology/envo.svg?branch=master)](https://travis-ci.org/EnvironmentOntology/envo)

This replaces Jenkins for this ontology

## General Guidelines

See:
http://wiki.geneontology.org/index.php/Curator_Guide:_General_Conventions

