
# Building ENVO with the Makefile – Overview and Guide

The Environment Ontology (ENVO) repository uses a Makefile-driven build system to automate assembling the ontology from source files. By invoking Makefile targets, contributors can generate the ontology’s various outputs (OWL, OBO, JSON) and run quality control checks. This guide explains how to use the Makefile to build ENVO, describes key targets, outlines required tools, and reviews the input/output structure of the repository.

## Required Tools and Setup

Building ENVO requires certain command-line tools (generally Java-based) to be installed or available in your environment:

- **ROBOT** – An OBO toolkit used for tasks like merging ontologies, reasoning, converting formats, and running validation queries.
- **DOSDP-tools** – The Dead Simple Ontology Design Pattern tool, used to generate ontology axioms from design pattern templates.
- **OWLTools/OORT** – *Historical:* The Ontology Release Tool (OORT) from OWLTools was originally listed as a requirement. Modern setups may use ROBOT instead.
- **Java** – Required to run ROBOT and DOSDP-tools.
- **Make** – A Unix-like make utility is required. On Windows, WSL or Git Bash is recommended.

You can either install these tools individually or use the **Ontology Development Kit (ODK)** Docker image. The ENVO repository includes a `run.sh` script to wrap commands inside Docker using ODK.

```bash
# Run build inside ODK container
./run.sh make test
```

## Repository Structure: Source Files and Directories

- **`src/envo/envo-edit.owl`** – The main editor's OWL file. All manual edits should be made here.
- **`src/envo/modules/`** – CSV/TSV files listing term rows for DOSDP processing.
- **`src/envo/patterns/`** – DOSDP YAML templates defining logical axioms.
- **`src/envo/imports/`** – Imports from external ontologies, managed via ROBOT.
- **`src/envo/subsets/`** – Definitions and metadata for slimmed subsets.
- **`reports/`, `build/`, etc.** – Intermediate and report outputs from builds.

## Key Makefile Targets

- `make all` – Builds the ontology by running modules, imports, and final OWL.
- `make all_modules` – Generates OWL axioms from DOSDP templates and CSVs.
- `make all_imports` – Refreshes external ontology imports using ROBOT.
- `make envo.owl` – Produces merged ontology with all imports.
- `make envo-base.owl` – Produces ontology with ENVO-native terms only.
- `make envo.obo` – Converts ENVO to OBO format.
- `make envo.json` – Outputs OBO Graph JSON.
- `make subsets/envo-basic.obo` – Slimmed-down version in OBO.
- `make all_reports` – Runs ROBOT reports and QC checks.
- `make validate-dl-profile` – Ensures OWL DL conformance.
- `make test` – Full build and QC check (used in CI).
- `make release` – Final release outputs for distribution.
- `make clean` – Removes build artifacts and intermediate files.

## Example Usage

```bash
# Compile and merge full ontology
make all

# Run quality checks and SPARQL constraints
make test

# Generate release files
make release

# Clean up temporary files
make clean
```

## Output Files

- `envo.owl` – Full OWL file (includes imports).
- `envo-base.owl` – ENVO-native classes only.
- `envo.obo`, `envo.json` – Alternative formats.
- `subsets/envo-basic.obo` – Lightweight OBO version.
- `reports/*.tsv` – Validation and QC outputs.

## Summary

ENVO's Makefile allows automated, repeatable builds of the ontology from modular CSV templates, imported terms, and curated OWL source. It integrates with quality control tools and supports both development and release workflows.
