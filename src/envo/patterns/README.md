# Design Patterns

This folder contains design patterns for groupings of classes in the ontology.

The design patterns are specified in YAML, and follow the [dead_simple_design_patterns](https://github.com/dosumis/dead_simple_owl_design_patterns/) specification

Consult each yaml file for details on the specific pattern.

# Implementation

The design patterns act as templates, with template values coming from the TSVs in the [src/ontology/modules](../modules) directory. [pattern2owl](https://github.com/cmungall/pattern2owl) is used to translate the TSVs to OWL. See the [Makefile](../Makefile) for more details


