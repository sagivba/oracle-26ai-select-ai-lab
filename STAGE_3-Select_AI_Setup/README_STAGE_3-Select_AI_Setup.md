# README - Stage 3: Select AI Setup

## Table of Contents

- [README - Stage 3: Select AI Setup](#readme---stage-3-select-ai-setup)
  - [Table of Contents](#table-of-contents)
  - [1. Stage Goal](#1-stage-goal)
  - [2. Current Starting Point](#2-current-starting-point)
  - [3. Updated Stage Logic](#3-updated-stage-logic)
  - [4. Scope and Guiding Principles](#4-scope-and-guiding-principles)
  - [5. Target Outcome for This Stage](#5-target-outcome-for-this-stage)
  - [6. Step 1 - Run Prerequisite Checks](#6-step-1---run-prerequisite-checks)
  - [7. Step 2 - Create the Cloud Service User](#7-step-2---create-the-cloud-service-user)
  - [8. Step 3 - Install DBMS_CLOUD and DBMS_CLOUD_AI](#8-step-3---install-dbms_cloud-and-dbms_cloud_ai)
  - [9. Step 4 - Validate the Installation](#9-step-4---validate-the-installation)
  - [10. Step 5 - Prepare Required Privileges and Network Access](#10-step-5---prepare-required-privileges-and-network-access)
  - [11. Step 6 - Create the OpenAI Credential](#11-step-6---create-the-openai-credential)
  - [12. Step 7 - Create the First AI Profile](#12-step-7---create-the-first-ai-profile)
  - [13. Step 8 - Activate the Profile](#13-step-8---activate-the-profile)
  - [14. Step 9 - Run the First NL2SQL Trial Safely](#14-step-9---run-the-first-nl2sql-trial-safely)
  - [15. Step 10 - Validate the Results](#15-step-10---validate-the-results)
  - [16. Step 11 - Expand Carefully After the First Success](#16-step-11---expand-carefully-after-the-first-success)
  - [17. Recommended Object Selection for the First PoC](#17-recommended-object-selection-for-the-first-poc)
  - [18. What Not to Change Yet](#18-what-not-to-change-yet)
  - [19. Common Pitfalls](#19-common-pitfalls)
  - [20. Deliverables of Stage 3](#20-deliverables-of-stage-3)
  - [21. Exit Criteria](#21-exit-criteria)
  - [22. Appendix A - Planned Scripts for This Stage](#22-appendix-a---planned-scripts-for-this-stage)
    - [Script: 17_STAGE3_PREREQ_CHECKS.sql](#script-17_stage3_prereq_checkssql)
    - [Script: 18_STAGE3_DBMS_CLOUD_INSTALL_PREREQS.sql](#script-18_stage3_dbms_cloud_install_prereqssql)
    - [Script: 19_CREATE_CLOUD_USER.sh](#script-19_create_cloud_usersh)
    - [Script: 20_INSTALL_DBMS_CLOUD.sh](#script-20_install_dbms_cloudsh)
    - [Script: 21_STAGE3_SECURITY_AND_NETWORK_SETUP.sql](#script-21_stage3_security_and_network_setupsql)
    - [Script: 22_STAGE3_CREATE_OPENAI_CREDENTIAL.sql](#script-22_stage3_create_openai_credentialsql)
    - [Script: 23_STAGE3_CREATE_AI_PROFILE.sql](#script-23_stage3_create_ai_profilesql)
    - [Script: 24_STAGE3_SET_ACTIVE_PROFILE.sql](#script-24_stage3_set_active_profilesql)
    - [Script: 25_STAGE3_FIRST_NL2SQL_PROMPTS.sql](#script-25_stage3_first_nl2sql_promptssql)
    - [Script: 26_STAGE3_VALIDATE_RESULTS.sql](#script-26_stage3_validate_resultssql)
    - [Script: 27_STAGE3_EXPAND_PROFILE_SCOPE.sql](#script-27_stage3_expand_profile_scopesql)

---

## 1. Stage Goal

The goal of Stage 3 is to enable a practical and controlled first Select AI proof of concept on the local Oracle AI Database 26ai environment.

This stage no longer starts directly with OpenAI credential creation. Based on the prerequisite checks already performed, the immediate objective is first to install the required `DBMS_CLOUD` family components and only then continue with the Select AI configuration path.

The priority is not to build a production-ready framework yet. The priority is to achieve a short, safe, understandable, and repeatable first success.

---

## 2. Current Starting Point

At the current point in Stage 3, the project already includes the following completed items:

- Oracle AI Database 26ai is running locally in Docker.
- Work is performed against `FREEPDB1`.
- The actual container name is `oracle26ai`.
- Backup and restore scripts already exist.
- Service control scripts already exist.
- A `BUDGET` schema already exists and is open.
- Core budget tables are already created and loaded.
- Business comments and semantic annotations were already added.
- A semantic data dictionary was already generated.
- Relationship documentation, a constraints report, and a SQL checklist were already produced.
- Initial AI-oriented views were already created.
- Basic SQL validation of the model was already completed.

Stage 3 prerequisite checks were already run:

- `17_STAGE3_PREREQ_CHECKS.sql`
- `18_STAGE3_DBMS_CLOUD_INSTALL_PREREQS.sql`

The main findings were:

- `BUDGET` exists and the required objects are present.
- The first candidate view is ready for an initial PoC.
- `DBMS_CLOUD` is not installed.
- `DBMS_CLOUD_AI` is not installed.
- Java/JVM components exist and are valid.
- `DBMS_NETWORK_ACL_ADMIN` and `UTL_HTTP` exist and are valid.
- No additional blocker was identified beyond the missing `DBMS_CLOUD` family.
- `C##CLOUD$SERVICE` does not yet exist, which is expected before installation.

This means Stage 3 is currently blocked by infrastructure setup, not by the data model.

---

## 3. Updated Stage Logic

The original Stage 3 flow assumed that Select AI setup could start directly with security, credential creation, and profile definition.

That is no longer accurate for this project state.

The correct Stage 3 sequence is now:

1. Run prerequisite validation.
2. Create `C##CLOUD$SERVICE`.
3. Install `DBMS_CLOUD` and `DBMS_CLOUD_AI`.
4. Validate that the installation succeeded.
5. Configure grants and network ACL.
6. Create the OpenAI credential.
7. Create the first AI profile.
8. Activate the profile.
9. Run the first `SELECT AI SHOWSQL` and controlled execution tests.
10. Validate the generated SQL and returned business results.

This adjustment is important because OpenAI credential setup, AI profile creation, and Select AI testing should not be attempted before the required cloud packages are installed successfully.

---

## 4. Scope and Guiding Principles

This stage should remain intentionally narrow.

Guiding principles:

- Start with a short PoC path.
- Resolve infrastructure blockers before configuration blockers.
- Use the smallest practical object scope.
- Prefer views over base tables for the first experiment.
- Validate generated SQL before running it.
- Avoid structural schema changes unless they are truly required.
- Defer optimization topics to later stages.

This is a setup and validation stage, not a redesign stage.

---

## 5. Target Outcome for This Stage

By the end of Stage 3, the environment should support the following workflow:

1. `DBMS_CLOUD` and `DBMS_CLOUD_AI` are installed and valid.
2. Oracle can authenticate to OpenAI.
3. A valid Select AI profile exists.
4. The profile is limited to a small and relevant object set.
5. The profile can be activated for the session.
6. The first `SELECT AI SHOWSQL` tests produce meaningful SQL.
7. At least one or two controlled `SELECT AI` executions return sensible business results.

---

## 6. Step 1 - Run Prerequisite Checks

Before creating any Select AI objects, run a compact set of checks to confirm that the environment is ready for cloud package installation and later Select AI setup.

Checks should include at least:

- Confirm that the target user is known and consistent.
- Confirm that the target schema objects exist.
- Confirm that the first candidate view returns data.
- Confirm whether `DBMS_CLOUD` exists.
- Confirm whether `DBMS_CLOUD_AI` exists.
- Confirm that supporting Java and network-related components are valid.
- Confirm whether `C##CLOUD$SERVICE` already exists.

Recommended first object for later validation:

- `BUDGET.VW_BUDGET_VS_ACTUAL`

Scripts for this step:

- [17_STAGE3_PREREQ_CHECKS.sql](#script-17_stage3_prereq_checkssql)
- [18_STAGE3_DBMS_CLOUD_INSTALL_PREREQS.sql](#script-18_stage3_dbms_cloud_install_prereqssql)

These scripts centralize the readiness checks so that Stage 3 can be repeated consistently.

---

## 7. Step 2 - Create the Cloud Service User

Before installing the cloud package family, create the common user required by the Oracle installation scripts.

This step should:

- Run from the host.
- Execute inside the Docker container `oracle26ai`.
- Connect as `sqlplus / as sysdba` inside the container.
- Switch explicitly to `FREEPDB1`.
- Run Oracle's original `catclouduser.sql` from `ORACLE_HOME`.
- Create the user `C##CLOUD$SERVICE`.

Important note about the password parameter:

- The password passed to the wrapper script is the password for the new user `C##CLOUD$SERVICE`.
- It is not the password of `SYSTEM`.
- The script does not request the `SYSTEM` password because it uses OS authentication as SYSDBA inside the container.

Planned script for this step:

- [19_CREATE_CLOUD_USER.sh](#script-19_create_cloud_usersh)

This script is already created and is the preferred wrapper name.

---

## 8. Step 3 - Install DBMS_CLOUD and DBMS_CLOUD_AI

After `C##CLOUD$SERVICE` is created successfully, install the cloud package family.

This step should:

- Run from the host through Docker.
- Execute against the same container `oracle26ai`.
- Use the Oracle-supplied installation files from `ORACLE_HOME`.
- Avoid copying Oracle installation files into the project tree unless there is a later operational reason to do so.
- Keep the installation path explicit and repeatable.

The relevant Oracle Home files already identified are:

- `/opt/oracle/product/26ai/dbhomeFree/rdbms/admin/catclouduser.sql`
- `/opt/oracle/product/26ai/dbhomeFree/rdbms/admin/dbms_cloud_install.sql`
- `/opt/oracle/product/26ai/dbhomeFree/rdbms/admin/catcon.pl`

Planned script for this step:

- [20_INSTALL_DBMS_CLOUD.sh](#script-20_install_dbms_cloudsh)

This script should become the installation wrapper for the `DBMS_CLOUD` family.

---

## 9. Step 4 - Validate the Installation

Immediately after the installation, validate that the cloud package family is present and usable.

Validation should include at least:

- Confirm that `C##CLOUD$SERVICE` exists.
- Confirm that `DBMS_CLOUD` exists.
- Confirm that `DBMS_CLOUD_AI` exists.
- Confirm that the relevant objects are `VALID`.
- Confirm that there are no critical compile errors blocking further work.

This validation must happen before any network ACL, credential, or profile configuration.

This validation can be added either to the end of the installation wrapper or to a small follow-up SQL verification block.

---

## 10. Step 5 - Prepare Required Privileges and Network Access

Only after the cloud package family is installed and validated should the runtime access configuration begin.

This step should include:

- Granting `EXECUTE` on the required AI-related package(s) to the working user.
- Ensuring that any supporting cloud package privileges are available if needed.
- Configuring the network ACL for outbound HTTPS access to the OpenAI endpoint.
- Verifying that the correct database user is the one receiving the access.

This step should be kept explicit and documented because environment access problems are one of the most common setup failures.

Planned script for this step:

- [21_STAGE3_SECURITY_AND_NETWORK_SETUP.sql](#script-21_stage3_security_and_network_setupsql)

---

## 11. Step 6 - Create the OpenAI Credential

Once the runtime prerequisites are ready, create the database credential that stores the OpenAI authentication details.

This step should:

- Create a named credential in the database.
- Use a stable naming convention.
- Avoid hard-coding sensitive values in shared documentation.
- Keep the credential name simple and easy to reference from the profile.

Suggested credential naming convention:

- `OPENAI_CRED`

Planned script for this step:

- [22_STAGE3_CREATE_OPENAI_CREDENTIAL.sql](#script-22_stage3_create_openai_credentialsql)

---

## 12. Step 7 - Create the First AI Profile

After the credential exists, create the first AI profile.

For the initial PoC, the profile should be deliberately narrow:

- Use provider `openai`.
- Reference the previously created credential.
- Restrict the profile to a very small `object_list`.
- Enable semantic metadata support where useful.
- Keep the setup readable and easy to troubleshoot.

Recommended first object list:

- `BUDGET.VW_BUDGET_VS_ACTUAL`

Optional second object after first success:

- `BUDGET.AI_BUDGET_SUMMARY`

Do not begin with all tables or all views in the schema.

Planned script for this step:

- [23_STAGE3_CREATE_AI_PROFILE.sql](#script-23_stage3_create_ai_profilesql)

---

## 13. Step 8 - Activate the Profile

After creating the profile, activate it for the session and verify that the intended profile is the one currently in use.

This step should include:

- Setting the active profile.
- Querying the current profile.
- Confirming that the working session is aligned with the expected test context.

This is a small step, but it prevents confusion during testing.

Planned script for this step:

- [24_STAGE3_SET_ACTIVE_PROFILE.sql](#script-24_stage3_set_active_profilesql)

---

## 14. Step 9 - Run the First NL2SQL Trial Safely

The first trial should not start with unrestricted execution.

The safest path is:

1. Start with `SELECT AI SHOWSQL`.
2. Review the generated SQL.
3. Use `EXPLAINSQL` if needed.
4. Only then execute a controlled `SELECT AI` prompt.

Suggested first business questions:

- Show budget versus actual by cost center.
- Which cost centers are over budget?
- Show variance amount by budget period.

This sequence is important because it separates prompt interpretation from SQL execution.

Planned script for this step:

- [25_STAGE3_FIRST_NL2SQL_PROMPTS.sql](#script-25_stage3_first_nl2sql_promptssql)

---

## 15. Step 10 - Validate the Results

After the first generated SQL appears, validate both the SQL and the returned data.

Validation should include:

- The generated SQL is syntactically valid.
- The generated SQL uses the intended object(s).
- The business logic appears reasonable.
- The grouping and filtering behavior match the prompt intent.
- Returned values are consistent with manual SQL checks.
- No hallucinated tables or columns are introduced.

Validation at this stage is mandatory. A successful answer must be understandable, not just executable.

Planned script for this step:

- [26_STAGE3_VALIDATE_RESULTS.sql](#script-26_stage3_validate_resultssql)

---

## 16. Step 11 - Expand Carefully After the First Success

Only after the first PoC works should the scope be expanded.

Possible next moves:

- Add `AI_BUDGET_SUMMARY` to the object list.
- Try more complex prompts.
- Compare behavior between views.
- Assess whether additional annotations or object reshaping are needed.

At this point, the goal is still controlled expansion, not full-scale coverage.

Planned script for this step:

- [27_STAGE3_EXPAND_PROFILE_SCOPE.sql](#script-27_stage3_expand_profile_scopesql)

---

## 17. Recommended Object Selection for the First PoC

The best starting object is:

- `VW_BUDGET_VS_ACTUAL`

Reasoning:

- It already encapsulates business logic.
- It reduces join complexity.
- It is easier for NL2SQL to interpret than a full normalized base model.
- It is directly aligned with core budget questions.

Second optional object:

- `AI_BUDGET_SUMMARY`

Objects that should not be the starting point:

- All base tables together
- The full schema at once
- All AI views at once

A narrow semantic entry point is the safest strategy for a first Select AI setup.

---

## 18. What Not to Change Yet

The following items should not be treated as blockers for Stage 3 unless testing proves otherwise:

- Full constraint hardening
- Constraint validation cleanup
- Physical renaming of tables
- Physical renaming of columns
- Large model restructuring
- Broad synonym redesign

These may improve later stages, but they are not required to obtain a valid first Select AI PoC.

---

## 19. Common Pitfalls

Common failure patterns at this stage include:

- Trying to create credentials before `DBMS_CLOUD` is installed
- Trying to create AI profiles before `DBMS_CLOUD_AI` is installed
- Missing package privileges
- Missing or incorrect network ACL entries
- Invalid or expired OpenAI credentials
- Creating a profile with too many objects too early
- Running `SELECT AI` before reviewing `SHOWSQL`
- Assuming an answer is correct because it executed successfully
- Expanding the semantic scope before validating the first narrow use case

These issues should be considered normal early-stage risks and handled methodically.

---

## 20. Deliverables of Stage 3

Expected deliverables:

- A created `C##CLOUD$SERVICE` user
- A working installation of `DBMS_CLOUD`
- A working installation of `DBMS_CLOUD_AI`
- A working OpenAI credential
- A first Select AI profile
- A repeatable setup process documented through scripts
- A controlled first NL2SQL prompt set
- A validation script for generated SQL and results
- A short record of findings and next recommendations

---

## 21. Exit Criteria

Stage 3 can be considered complete when all of the following are true:

- `C##CLOUD$SERVICE` was created successfully.
- The required cloud package family was installed successfully.
- The profile can be activated without ambiguity.
- `SELECT AI SHOWSQL` returns meaningful SQL for several basic prompts.
- At least one executed prompt returns correct and explainable results.
- The setup is documented well enough to repeat it later using scripts only.

---

## 22. Appendix A - Planned Scripts for This Stage

| Script | Description |
|---|---|
| [17_STAGE3_PREREQ_CHECKS.sql](#script-17_stage3_prereq_checkssql) | Runs the first prerequisite checks for Stage 3, including object existence, data presence, and first-view readiness. |
| [18_STAGE3_DBMS_CLOUD_INSTALL_PREREQS.sql](#script-18_stage3_dbms_cloud_install_prereqssql) | Verifies installation prerequisites for the `DBMS_CLOUD` family, including supporting components and blockers. |
| [19_CREATE_CLOUD_USER.sh](#script-19_create_cloud_usersh) | Runs Oracle's `catclouduser.sql` inside the `oracle26ai` container and creates `C##CLOUD$SERVICE` in `FREEPDB1`. |
| [20_INSTALL_DBMS_CLOUD.sh](#script-20_install_dbms_cloudsh) | Installs `DBMS_CLOUD` and related cloud package components using Oracle-supplied files from `ORACLE_HOME`. |
| [21_STAGE3_SECURITY_AND_NETWORK_SETUP.sql](#script-21_stage3_security_and_network_setupsql) | Applies the main security preparation for the PoC, including grants and outbound network ACL configuration required for OpenAI access. |
| [22_STAGE3_CREATE_OPENAI_CREDENTIAL.sql](#script-22_stage3_create_openai_credentialsql) | Creates the database credential that stores the OpenAI authentication reference used by Select AI. |
| [23_STAGE3_CREATE_AI_PROFILE.sql](#script-23_stage3_create_ai_profilesql) | Creates the first focused Select AI profile, restricted to the initial object scope for the budget PoC. |
| [24_STAGE3_SET_ACTIVE_PROFILE.sql](#script-24_stage3_set_active_profilesql) | Activates the intended AI profile for the current session and verifies that the correct profile is in use. |
| [25_STAGE3_FIRST_NL2SQL_PROMPTS.sql](#script-25_stage3_first_nl2sql_promptssql) | Contains the first controlled Select AI prompt set, starting with `SHOWSQL` and then moving to limited execution tests. |
| [26_STAGE3_VALIDATE_RESULTS.sql](#script-26_stage3_validate_resultssql) | Compares AI-generated SQL behavior and output against manual validation queries to confirm correctness and business alignment. |
| [27_STAGE3_EXPAND_PROFILE_SCOPE.sql](#script-27_stage3_expand_profile_scopesql) | Expands the object scope after the first successful PoC, allowing a second phase of broader but still controlled testing. |

---

### Script: 17_STAGE3_PREREQ_CHECKS.sql
<a id="script-17_stage3_prereq_checkssql"></a>

Planned location: same directory as this README.

---

### Script: 18_STAGE3_DBMS_CLOUD_INSTALL_PREREQS.sql
<a id="script-18_stage3_dbms_cloud_install_prereqssql"></a>

Planned location: same directory as this README.

---

### Script: 19_CREATE_CLOUD_USER.sh
<a id="script-19_create_cloud_usersh"></a>

Planned location: same directory as this README.

---

### Script: 20_INSTALL_DBMS_CLOUD.sh
<a id="script-20_install_dbms_cloudsh"></a>

Planned location: same directory as this README.

---

### Script: 21_STAGE3_SECURITY_AND_NETWORK_SETUP.sql
<a id="script-21_stage3_security_and_network_setupsql"></a>

Planned location: same directory as this README.

---

### Script: 22_STAGE3_CREATE_OPENAI_CREDENTIAL.sql
<a id="script-22_stage3_create_openai_credentialsql"></a>

Planned location: same directory as this README.

---

### Script: 23_STAGE3_CREATE_AI_PROFILE.sql
<a id="script-23_stage3_create_ai_profilesql"></a>

Planned location: same directory as this README.

---

### Script: 24_STAGE3_SET_ACTIVE_PROFILE.sql
<a id="script-24_stage3_set_active_profilesql"></a>

Planned location: same directory as this README.

---

### Script: 25_STAGE3_FIRST_NL2SQL_PROMPTS.sql
<a id="script-25_stage3_first_nl2sql_promptssql"></a>

Planned location: same directory as this README.

---

### Script: 26_STAGE3_VALIDATE_RESULTS.sql
<a id="script-26_stage3_validate_resultssql"></a>

Planned location: same directory as this README.

---

### Script: 27_STAGE3_EXPAND_PROFILE_SCOPE.sql
<a id="script-27_stage3_expand_profile_scopesql"></a>

Planned location: same directory as this README.
