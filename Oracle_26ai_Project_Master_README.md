# Oracle AI Database 26ai Hands-On Project

## Table of Contents

1. [Stage 1 - Creating the Docker Database](#stage-1---creating-the-docker-database)
2. [Stage 2 - Setting the Data Foundation](#stage-2---setting-the-data-foundation)
3. [Stage 3 - Select AI Setup](#stage-3---select-ai-setup)
4. [Stage 4 - NL2SQL Experiments](#stage-4---nl2sql-experiments)
5. [Stage 5 - Model Refinement and Accuracy Improvement](#stage-5---model-refinement-and-accuracy-improvement)
6. [Stage 6 - Optional Extensions](#stage-6---optional-extensions)
7. [Success Criteria](#success-criteria)
8. [Current Project Status](#current-project-status)

---

## Stage 1 - Creating the Docker Database

### Goal

Set up a local Oracle AI Database 26ai environment that can be started, stopped, backed up, restored, and used as the foundation for all following stages.

### Objectives

- Run Oracle 26ai locally in Docker
- Connect successfully to `FREEPDB1`
- Validate the installation
- Prepare backup and restore procedures
- Prepare service control scripts for day-to-day work

### Main Activities

- Create and run the Docker container
- Create and persist the Oracle data volume
- Connect to the database and verify the environment
- Validate the version and PDB status
- Prepare a full backup script
- Prepare a restore script
- Prepare a service control script for start, stop, and status

### Key Files

- `STAGE_1-creating_docker_DB/oracle_26ai_docker_setup.md`
- `scripts/backup_all.sh`
- `scripts/restore_all.sh`
- `scripts/oracle26AI_service_ctl.sh`

### Expected Output

- A working local Oracle AI Database 26ai environment
- A repeatable operational process for startup, shutdown, backup, and restore

### Status

Completed.

---

## Stage 2 - Setting the Data Foundation

### Goal

Create a budget-oriented data model that is suitable for Select AI and NL2SQL experiments.

### Objectives

- Create a dedicated schema for the budget domain
- Create the base tables
- Load demo or synthetic data
- Validate the data after loading
- Add business metadata
- Add semantic annotations to improve AI understanding
- Create AI-friendly views for the first proof of concept
- Generate technical and semantic documentation

### Main Activities

#### 2.1 Schema and Table Creation

Create the `BUDGET` schema and define the core business tables:

- `ORG_UNITS`
- `COST_CENTERS`
- `BUDGET_PERIODS`
- `EXPENSE_CATEGORIES`
- `BUDGET_ALLOCATIONS`
- `ACTUAL_EXPENSES`

#### 2.2 Core View Creation

Create the main business view used for early AI experiments:

- `VW_BUDGET_VS_ACTUAL`

#### 2.3 Data Load Preparation and Execution

Prepare CSV files, SQL*Loader control files, and loader scripts, then load the data into the tables.

#### 2.4 Validation and Baseline Checks

Run SQL validation checks to confirm:

- Data exists in all tables
- Primary key columns do not contain `NULL`
- Business keys are unique where expected
- No logical orphan rows exist
- The main view returns valid data

#### 2.5 Business Metadata and Semantic Layer

Add:

- Table comments
- Column comments
- Schema annotations
- Missing annotations where needed

#### 2.6 AI-Friendly Objects

Create simplified views intended for early NL2SQL experiments:

- `AI_BUDGET_OVERVIEW`
- `AI_BUDGET_SUMMARY`

#### 2.7 Documentation and Exports

Generate:

- Semantic HTML data dictionary
- Constraints report in Markdown
- PK/FK and business relationship documentation

### Key Files

#### Core SQL Files

- `STAGE_2-setting_the_data/00_CREATE_BUDGET_USER.sql`
- `STAGE_2-setting_the_data/01_ORG_UNITS.sql`
- `STAGE_2-setting_the_data/02_COST_CENTERS.sql`
- `STAGE_2-setting_the_data/03_BUDGET_PERIODS.sql`
- `STAGE_2-setting_the_data/04_EXPENSE_CATEGORIES.sql`
- `STAGE_2-setting_the_data/05_BUDGET_ALLOCATIONS.sql`
- `STAGE_2-setting_the_data/06_ACTUAL_EXPENSES.sql`
- `STAGE_2-setting_the_data/07_VW_BUDGET_VS_ACTUAL.sql`
- `STAGE_2-setting_the_data/08_CREATE_SYNONYM.sql`
- `STAGE_2-setting_the_data/10_CREATE_ALL.sql`
- `STAGE_2-setting_the_data/11_BUSINESS_METADATA.sql`
- `STAGE_2-setting_the_data/12_AI_FRIENDLY_VIEWS.sql`
- `STAGE_2-setting_the_data/13_SCHEMA_ANNOTATIONS.sql`
- `STAGE_2-setting_the_data/13B_SCHEMA_ANNOTATIONS_COMPLETE.sql`
- `STAGE_2-setting_the_data/13C_SCHEMA_ANNOTATIONS_ADD_MISSING.sql`
- `STAGE_2-setting_the_data/14_export_data_dictionary_html_semantic.sql`
- `STAGE_2-setting_the_data/15_export_constraints_markdown.sql`
- `STAGE_2-setting_the_data/16_STAGE2_SQL_CHECKLIST.sql`

#### Data Load Files

Located under `STAGE_2-setting_the_data/data_load/`:

- One CSV file per table
- One SQL*Loader control file per table
- One shell loader script per table

#### Supporting Files

- `STAGE_2-setting_the_data/data_load_validation.sql`
- `STAGE_2-setting_the_data/data_load_validation_output.txt`
- `STAGE_2-setting_the_data/generate_budget_files.py`
- `STAGE_2-setting_the_data/constraints_report.md`
- `STAGE_2-setting_the_data/data_dictionary.html`
- `docs/BUDGET_PK_FK_relationships.md`
- `docs/constraints_report.md`
- `docs/data_dictionary.html`

### Execution Order

Recommended execution order:

1. Create the schema user
2. Create all base tables
3. Create the main business view
4. Load the data
5. Validate the data load
6. Add business metadata
7. Add schema annotations
8. Create AI-friendly views
9. Export the semantic data dictionary
10. Export the constraints report
11. Run the Stage 2 SQL checklist

### Stage 2 Results

The following outcomes were already achieved:

- The `BUDGET` schema was created
- Base tables were created successfully
- Demo data was loaded
- Comments were added to tables and columns
- Semantic annotations were added to key schema objects
- Semantic HTML data dictionary was generated
- Business relationship documentation was produced
- Technical constraints report was produced
- SQL validation checklist was executed
- The main business view works and returns data
- Initial AI-oriented views were created

### Important Findings

- There is data in all core tables
- No `NULL` values were found in primary key columns
- No business key duplicates were identified in the current validation scope
- No orphan rows were detected in the logical checks
- `VW_BUDGET_VS_ACTUAL` works correctly
- `AI_BUDGET_OVERVIEW` and `AI_BUDGET_SUMMARY` are available for the next stage
- Physical renaming of tables and columns is not required for the first proof of concept
- Some constraints are currently disabled or not validated, but this does not block the first Select AI experiment

### Expected Output

- A complete and usable budget dataset for AI experiments
- A semantic layer that improves NL2SQL quality
- Documentation that supports both technical and business interpretation

### Status

Completed in practice and ready for the next stage.

---

## Stage 3 - Select AI Setup

### Goal

Connect Oracle AI Database to an external LLM provider and enable the first controlled NL2SQL proof of concept.

### Objectives

- Check the required prerequisites
- Create network access to the provider endpoint
- Create the OpenAI credential
- Create an AI profile
- Restrict the first experiment to a small and safe object set
- Validate the setup with `SHOWSQL` before running live SQL

### Main Activities

#### 3.1 Prerequisite Checks

Verify:

- The runtime user is known
- `DBMS_CLOUD_AI` is available
- The database host can reach the external provider endpoint
- An OpenAI API key is available
- The target view returns stable and valid results

#### 3.2 Security and Access Setup

- Grant `EXECUTE` on `DBMS_CLOUD_AI`
- Configure the required network ACL for the OpenAI endpoint

#### 3.3 Credential Setup

Create a database credential for the OpenAI API key.

#### 3.4 AI Profile Setup

Create the first AI profile with a narrow `object_list`, preferably starting with:

- `BUDGET.VW_BUDGET_VS_ACTUAL`

Optional second step:

- add `BUDGET.AI_BUDGET_SUMMARY`

#### 3.5 Profile Activation

Set the AI profile for the session and verify it.

#### 3.6 First Safe Experiments

Use:

- `SELECT AI SHOWSQL ...`
- `SELECT AI EXPLAINSQL ...`

Only after the generated SQL looks correct, continue with:

- `SELECT AI ...`

### Recommended Starting Point

Start with `VW_BUDGET_VS_ACTUAL` only.

Do not start with all base tables.

Do not widen the object list too early.

### Expected Output

- A working Select AI setup
- A controlled NL2SQL proof of concept over the budget domain

### Status

Planned and ready to implement.

---

## Stage 4 - NL2SQL Experiments

### Goal

Evaluate how well Select AI translates business-language questions into correct SQL over the budget model.

### Objectives

- Build a set of representative business questions
- Test SQL generation quality
- Compare generated SQL with expected business meaning
- Identify ambiguity, gaps, and naming issues

### Main Activities

- Prepare a list of business prompts
- Run prompts with `SHOWSQL`
- Review the generated SQL
- Run selected prompts with live execution
- Compare results with manual SQL where needed
- Record findings and improvement opportunities

### Example Question Areas

- Budget versus actual by organizational unit
- Cost centers over budget
- Variance by budget period
- Budget consumption by category
- Comparison across periods

### Expected Output

- A first quality assessment of NL2SQL behavior
- A list of successful and failed prompt patterns

### Status

Planned.

---

## Stage 5 - Model Refinement and Accuracy Improvement

### Goal

Improve NL2SQL quality based on findings from the first experiments.

### Objectives

- Refine metadata and semantics
- Reduce ambiguity
- Improve naming where needed
- Add or adjust AI-friendly views
- Decide whether stronger constraints or additional semantic structures are worth adding

### Main Activities

- Improve comments and annotations
- Add or refine simplified views
- Add synonyms if they help prompt interpretation
- Revisit object naming only if experiments prove it is necessary
- Optionally improve constraints for better semantic clarity

### Expected Output

- Better SQL generation quality
- More stable and predictable prompt behavior

### Status

Planned.

---

## Stage 6 - Optional Extensions

### Goal

Expand the proof of concept into additional architecture or product directions after the core NL2SQL experiment is stable.

### Possible Directions

- ORDS or REST exposure
- APEX integration
- ERP-oriented integration patterns
- Vector search or RAG-based extensions
- Additional business domains beyond budget

### Expected Output

- A broader applied architecture around Oracle AI Database 26ai

### Status

Optional future work.

---

## Success Criteria

The first project milestone is considered successful when the following conditions are met:

- Oracle AI Database 26ai runs locally in Docker
- The budget schema is available and populated
- The OpenAI connection is configured successfully
- Select AI is enabled for a controlled object set
- At least 5 to 10 business prompts generate valid SQL
- Initial NL2SQL quality can be evaluated in a structured way

---

## Current Project Status

### Completed

- Stage 1
- Stage 2

### Next Step

- Stage 3 - Select AI Setup

### Recommended Immediate Focus

Implement the smallest safe Select AI proof of concept first:

1. OpenAI credential
2. AI profile
3. `VW_BUDGET_VS_ACTUAL` as the first object
4. `SHOWSQL` validation
5. Controlled live execution

