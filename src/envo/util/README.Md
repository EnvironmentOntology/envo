## newTermReport.bash

A little util for generating informative tables for release notes. **Run the script before starting the release process** and it will create content for you to add to your release notes.
* This script assumes a rigid folder structure. 
* It will compare the release version of an ontology to the editors' version and generate a report of new terms in Md format
* It will also look at the imports folder and tabulate any terms imported from other ontologies since the last release.
* Optionally, it will append the commit log starting from the last release up until the current state of the repo.
