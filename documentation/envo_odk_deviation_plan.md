
# Documenting ENVO's Deviations from Canonical ODK Build Process

This document outlines a proposed plan to compare the Environment Ontology (ENVO) build process against the canonical Ontology Development Kit (ODK) build system. It is based on a preliminary discussion about the absence of certain configuration files and lack of a canonical reference repository.

---

## 🔍 Current State of ENVO Build Process

- ENVO does **not** contain an `odk.yaml` configuration file.
- ENVO uses a **Makefile-driven build process**, with custom targets such as:
  - `all_modules`
  - `all_imports`
  - `envo.owl`
  - `envo.obo`, `envo.json`, `subsets/envo-basic.obo`
  - `test`, `release`, `clean`, etc.
- ENVO integrates **ROBOT**, **DOSDP-tools**, and likely **custom SPARQL QC checks**.
- The repository layout centers around `src/envo/`, `modules/`, `imports/`, `patterns/`, and `reports/`.

---

## ✅ What We Will Compare

The deviations will be assessed against a reference ODK baseline derived from:

- The official [ODK cookiecutter template](https://github.com/INCATools/ontology-development-kit/tree/main/src/odk)
- Generated example ODK-based ontologies using `odk init`

---

## 🔧 Suggested Comparison Topics

| Area                          | What We'll Compare                                                                 |
|-------------------------------|--------------------------------------------------------------------------------------|
| `Makefile` targets            | Are canonical targets like `prepare_release`, `robot_report` present or overridden? |
| Folder structure              | Does ENVO follow the standard `src/ontology/`, `imports/`, `modules/`, etc.?        |
| ODK configuration             | Absence of `odk.yaml` or alternative build configs                                  |
| ROBOT usage                   | Is ENVO using customized ROBOT commands over standard ODK macros?                   |
| Imports handling              | Are imports handled with `external_imports/` and `seed list.tsv` or custom logic?   |
| QC/report generation          | Use of ROBOT report and any extra SPARQL validations                                |
| Release artifacts             | Are all standard outputs (`.owl`, `.obo`, `.json`, `-base.owl`) being generated?    |
| Continuous Integration (CI)   | Does ENVO rely on GitHub Actions, and are workflows aligned with ODK standards?     |

---

## 🚧 Next Steps

1. Use the latest **ODK cookiecutter template** as the canonical baseline.
2. Compare file structure, Makefile targets, and outputs between ENVO and the ODK example.
3. Document all deviations as a Markdown report, suitable for onboarding and refactoring.

This document will evolve into a structured delta report as soon as the analysis is completed.
