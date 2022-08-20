#!/bin/bash


# This script assumes a rigid folder structure.
# It will compare the release version of an ontology to the editors'
# version and generate a report of new terms in Md format
# It will also look at the imports folder and tabulate any terms 
# imported from other ontologies since the last release.
# Optionally, it will append the commit log starting from the last 
# release up until the current state of the repo.

# set variables

OLDTERMS='scratchOldTerms.txt'
NEWTERMS='scratchNewTerms.txt'
LABELTERMS='scratchLabelTerms.txt'
MINTEDTERMS='scratchMintedTerms.txt'

IMPORTEDTXT='src/envo/imports/*_terms.txt'
IMPORTEDOWL='src/envo/imports/*_seed.owl'

RELEASENOTES='./src/envo/util/scratchReleaseNewTerms.Md'

ONT='envo.owl'
ONTEDIT='./src/envo/envo-edit.owl'
PURLSTR='http://purl.obolibrary.org/obo/ENVO_[0-9]*'

TAG="$(git tag | tail -n1)"

# jump out of util to release folder
cd ../../../




# get cooking...

grep -o $PURLSTR $ONT | sort | uniq > $OLDTERMS
grep -o $PURLSTR  $ONTEDIT| sort | uniq > $NEWTERMS

sort <(cat $NEWTERMS) <(cat $OLDTERMS) | uniq -u > $MINTEDTERMS

grep "Class: <$PURLSTR> ([^]]*)" $ONTEDIT| sort | uniq | sed -e 's/[<>#]//g' -e 's/ Class: //g' > $LABELTERMS

echo "## New Terms" > $RELEASENOTES

grep -F -f $MINTEDTERMS $LABELTERMS | sed -r 's/ \(/\t\[/' | sed -r 's/\)$/]/'| awk -F $'\t' ' { t = $1; $1 = $2; $2 = t; print; } ' OFS=$'\t' | sed -r -e 's/\t/\(/' -e 's/$/\)/' | sort >> $RELEASENOTES

# list new imports...
echo "## New imported classes" >> $RELEASENOTES
echo "PURL | label" >> $RELEASENOTES
echo "----|----" >> $RELEASENOTES

git diff  $TAG..HEAD $IMPORTEDTXT | grep "^+[^+]" | sed -e 's/^+//' -e 's/#//g' -e 's/ / |/' >> $RELEASENOTES
git diff  $TAG..HEAD $IMPORTEDOWL  | grep "^+[^+]" | sed -e 's/[^<]*<//' -e 's/>[^#]*#/|/' >> $RELEASENOTES

# Enable if you want the commit log leading up to this release from the last one
# appended
#
#echo "## Commit log" >> $RELEASENOTES
#git log $TAG..HEAD  | sed 's/[ANY_EMAIL_ADDRESSES_TO_SUPPRESS]//' >> $RELEASENOTES

rm $NEWTERMS $OLDTERMS $LABELTERMS $MINTEDTERMS

