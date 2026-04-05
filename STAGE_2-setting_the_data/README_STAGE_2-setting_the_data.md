# STAGE 2 - Setting the Data

## Purpose

Stage 2 establishes the data foundation for the Oracle AI Database 26ai hands-on project.

The goal of this stage is to create a compact but business-relevant budget model, load demo data, add business metadata, and prepare the schema for the first Select AI / NL2SQL proof of concept.

This stage is intentionally focused on:

- building a clean budget-oriented schema
- loading consistent demo data
- validating logical integrity
- documenting the schema semantically
- preparing AI-friendly objects without changing the physical model more than necessary

---

## Current Status

Stage 2 is completed for the first PoC.

Completed items:

- BUDGET schema created
- Base tables created
- Demo data loaded
- Core reporting view created
- AI-friendly views created
- Table and column comments added
- Semantic annotations added
- Semantic HTML data dictionary exported
- Technical constraints report exported
- SQL checklist executed
- Basic data quality and relationship checks completed

Decisions already made:

- no physical rename of tables or columns at this stage
- existing views are sufficient for the first PoC
- some constraints are still DISABLED / NOT VALIDATED
- constraint hardening was deferred to a later stage because it does not block the first Select AI experiment

---

## Directory Structure

Main working directory for this stage:

```text
STAGE_2-setting_the_data/
```

Key contents include:

- schema creation scripts
- table DDL scripts
- business metadata scripts
- annotation scripts
- AI-friendly view scripts
- semantic export scripts
- constraints export script
- SQL checklist script
- CSV source data
- SQL*Loader control files
- SQL*Loader shell scripts
- validation output
- logs

---

## Main Objects Created

### Base tables

- ORG_UNITS
- COST_CENTERS
- BUDGET_PERIODS
- EXPENSE_CATEGORIES
- BUDGET_ALLOCATIONS
- ACTUAL_EXPENSES

### Reporting and AI-facing views

- VW_BUDGET_VS_ACTUAL
- AI_BUDGET_OVERVIEW
- AI_BUDGET_SUMMARY

---

## Main Scripts

### Core schema and table creation

- `00_CREATE_BUDGET_USER.sql`
- `01_ORG_UNITS.sql`
- `02_COST_CENTERS.sql`
- `03_BUDGET_PERIODS.sql`
- `04_EXPENSE_CATEGORIES.sql`
- `05_BUDGET_ALLOCATIONS.sql`
- `06_ACTUAL_EXPENSES.sql`
- `07_VW_BUDGET_VS_ACTUAL.sql`
- `08_CREATE_SYNONYM.sql`
- `10_CREATE_ALL.sql`

### Metadata and AI preparation

- `11_BUSINESS_METADATA.sql`
- `12_AI_FRIENDLY_VIEWS.sql`
- `13_SCHEMA_ANNOTATIONS.sql`
- `13B_SCHEMA_ANNOTATIONS_COMPLETE.sql`
- `13C_SCHEMA_ANNOTATIONS_ADD_MISSING.sql`

### Documentation and validation

- `14_export_data_dictionary_html_semantic.sql`
- `15_export_constraints_markdown.sql`
- `16_STAGE2_SQL_CHECKLIST.sql`
- `data_load_validation.sql`

### Data generation / loading assets

- `generate_budget_files.py`
- `data_load/*.csv`
- `data_load/*.ctl`
- `data_load/*_sqlldr.sh`

---

## Recommended Execution Order

If rebuilding Stage 2 from scratch, use this order.

### 1. Create schema and base objects

Run:

1. `00_CREATE_BUDGET_USER.sql`
2. `01_ORG_UNITS.sql`
3. `02_COST_CENTERS.sql`
4. `03_BUDGET_PERIODS.sql`
5. `04_EXPENSE_CATEGORIES.sql`
6. `05_BUDGET_ALLOCATIONS.sql`
7. `06_ACTUAL_EXPENSES.sql`
8. `07_VW_BUDGET_VS_ACTUAL.sql`
9. `08_CREATE_SYNONYM.sql`

Alternative:

- run `10_CREATE_ALL.sql` if it reflects the current script set you want to apply

### 2. Load data

Load the CSV files using the SQL*Loader control files and shell wrappers under:

```text
data_load/
```

### 3. Validate the loaded data

Run:

- `data_load_validation.sql`
- `16_STAGE2_SQL_CHECKLIST.sql`

### 4. Add business metadata

Run:

- `11_BUSINESS_METADATA.sql`

### 5. Add AI-friendly logical layer

Run:

- `12_AI_FRIENDLY_VIEWS.sql`

### 6. Add semantic annotations

Run the relevant annotation script set:

- `13_SCHEMA_ANNOTATIONS.sql`
- `13B_SCHEMA_ANNOTATIONS_COMPLETE.sql`
- `13C_SCHEMA_ANNOTATIONS_ADD_MISSING.sql`

Note:
Use the latest / corrected annotation flow that matches the current state of the schema. Avoid rerunning older versions blindly if objects were already annotated.

### 7. Export documentation

Run:

- `14_export_data_dictionary_html_semantic.sql`
- `15_export_constraints_markdown.sql`

---

## Outputs and Deliverables

### In stage directory

- `data_dictionary.html`
- `constraints_report.md`
- `data_load_validation_output.txt`

### In docs directory

Related exported documentation exists under:

```text
docs/
```

Including:

- `BUDGET_PK_FK_relationships.md`
- `constraints_report.md`
- `data_dictionary.html`

### In logs directory

Execution logs exist under:

```text
logs/
```

Including load logs and validation output.

---

## Validation Summary

The following findings were confirmed during Stage 2 validation:

- data exists in all core tables
- no NULL values in primary key columns
- no duplicates in business key checks
- no orphan rows found in the logical validation checks
- the main reporting view works and returns data
- AI-facing views were created successfully

This means the schema is in a good enough state for the first Select AI proof of concept.

---

## What Was Intentionally Deferred

The following items were deliberately not treated as blockers for Stage 3:

- full constraint hardening
- converting all disabled constraints to enabled / validated
- physical renaming of tables
- physical renaming of columns
- deeper model refactoring

These may improve future NL2SQL quality, but they are not required for the first PoC.

---

## Known Caveats

- some constraints are still disabled or not validated
- annotation scripts evolved during the work, so not every older script version should be treated as the final source of truth
- the project currently contains both stage-local outputs and copies under `docs/`
- `10_CREATE_ALL.sql` should be reviewed before reuse to ensure it matches the latest preferred script order

---

## Suggested Baseline Before Stage 3

Before starting Select AI setup, the recommended baseline is:

- Stage 1 environment is up and stable
- BUDGET schema exists
- core data is loaded
- `VW_BUDGET_VS_ACTUAL` returns correct data
- AI-friendly views exist
- comments and annotations exist on the important objects
- semantic data dictionary was exported successfully
- validation results are clean enough for a first PoC

---

## Recommended Starting Object for Stage 3

For the first Select AI / NL2SQL experiment, start with:

- `VW_BUDGET_VS_ACTUAL`

Only after that, consider expanding to:

- `AI_BUDGET_SUMMARY`
- `AI_BUDGET_OVERVIEW`

Do not start with the full physical schema unless there is a specific reason to test a broader object set.

---

## Related Project Context

This stage follows:

- `STAGE_1-creating_docker_DB`

And prepares the ground for:

- `STAGE_3-select_ai_setup`

---

## Quick Rebuild Checklist

If you need to rebuild this stage quickly:

1. create / verify BUDGET user
2. create all base tables
3. create main reporting view
4. load CSV data
5. validate row counts and relationships
6. add comments and business metadata
7. create AI-friendly views
8. add semantic annotations
9. export HTML data dictionary
10. export constraints report
11. run SQL checklist
12. confirm `VW_BUDGET_VS_ACTUAL` is ready for Select AI

---

## Owner Notes

This stage is not just a data load stage.
It is the semantic preparation layer for the first Oracle Select AI experiments.

The main success criterion is not perfect modeling.
The main success criterion is having a clean, understandable, documented business object set that is good enough for a first NL2SQL PoC.
