-- 17_STAGE3_PREREQ_CHECKS_CLEAN.sql
-- Purpose:
--   Clean, read-only prerequisite checks for Stage 3 before DBMS_CLOUD / DBMS_CLOUD_AI installation.
-- Notes:
--   1. This script does not change anything.
--   2. It intentionally avoids dictionary columns/views that vary between environments.
--   3. It focuses on the application schema readiness and package availability.

SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 200
SET LINESIZE 220
SET TRIMSPOOL ON
SET TAB OFF
COLUMN runtime_user_name FORMAT A20
COLUMN application_schema FORMAT A20
COLUMN candidate_ai_view FORMAT A22
COLUMN provider_host FORMAT A20
COLUMN pdb_name FORMAT A12
COLUMN open_mode FORMAT A12
COLUMN banner_full FORMAT A86
COLUMN username FORMAT A20
COLUMN account_status FORMAT A18
COLUMN default_tablespace FORMAT A20
COLUMN profile FORMAT A12
COLUMN created FORMAT A20
COLUMN owner FORMAT A12
COLUMN object_name FORMAT A24
COLUMN object_type FORMAT A14
COLUMN status FORMAT A10
COLUMN object_count FORMAT 999999
COLUMN row_count FORMAT 999999
COLUMN check_name FORMAT A30
COLUMN details FORMAT A70

DEFINE P_RUNTIME_USER='BUDGET'
DEFINE P_APP_SCHEMA='BUDGET'
DEFINE P_AI_VIEW='VW_BUDGET_VS_ACTUAL'
DEFINE P_PROVIDER_HOST='api.openai.com'

PROMPT
SELECT '&P_RUNTIME_USER' AS runtime_user_name,
       '&P_APP_SCHEMA'  AS application_schema,
       '&P_AI_VIEW'     AS candidate_ai_view,
       '&P_PROVIDER_HOST' AS provider_host
FROM dual;

PROMPT
PROMPT ================================================================
PROMPT Stage 3 - Select AI Prerequisite Checks (Clean)
PROMPT ================================================================
PROMPT
PROMPT Runtime user ..........: &P_RUNTIME_USER
PROMPT Application schema ....: &P_APP_SCHEMA
PROMPT Candidate AI view .....: &P_AI_VIEW
PROMPT Provider host .........: &P_PROVIDER_HOST
PROMPT
PROMPT 1. Session and database identity
PROMPT

SELECT USER AS runtime_user_name,
       SYS_CONTEXT('USERENV','CON_NAME') AS pdb_name,
       open_mode
FROM   v$pdbs
WHERE  name = SYS_CONTEXT('USERENV','CON_NAME');

PROMPT
SELECT banner_full
FROM   v$version
WHERE  banner_full LIKE 'Oracle AI Database%';

PROMPT
PROMPT 2. Target user and schema existence
PROMPT

SELECT username,
       account_status,
       default_tablespace,
       profile,
       TO_CHAR(created,'YYYY-MM-DD HH24:MI:SS') AS created
FROM   dba_users
WHERE  username = UPPER('&P_APP_SCHEMA');

PROMPT
PROMPT 3. Package availability checks
PROMPT

SELECT owner,
       object_name,
       object_type,
       status
FROM   dba_objects
WHERE  owner = 'SYS'
AND    object_name IN ('DBMS_CLOUD','DBMS_CLOUD_AI')
ORDER  BY object_name;

PROMPT
PROMPT 4. Execute privilege checks for runtime user
PROMPT

SELECT owner,
       table_name AS object_name,
       privilege  AS object_type,
       grantee    AS status
FROM   dba_tab_privs
WHERE  owner = 'SYS'
AND    table_name IN ('DBMS_CLOUD','DBMS_CLOUD_AI')
AND    grantee = UPPER('&P_RUNTIME_USER')
ORDER  BY table_name, privilege;

PROMPT
PROMPT 5. Candidate schema object existence
PROMPT

SELECT owner,
       object_name,
       object_type,
       status
FROM   dba_objects
WHERE  owner = UPPER('&P_APP_SCHEMA')
AND    object_name IN (
         'ORG_UNITS',
         'COST_CENTERS',
         'BUDGET_PERIODS',
         'EXPENSE_CATEGORIES',
         'BUDGET_ALLOCATIONS',
         'ACTUAL_EXPENSES',
         'VW_BUDGET_VS_ACTUAL',
         'AI_BUDGET_OVERVIEW',
         'AI_BUDGET_SUMMARY'
       )
ORDER  BY DECODE(object_type,'TABLE',1,'VIEW',2,9), object_name;

PROMPT
PROMPT 6. Object count summary in application schema
PROMPT

SELECT object_type,
       COUNT(*) AS object_count
FROM   dba_objects
WHERE  owner = UPPER('&P_APP_SCHEMA')
AND    object_type IN ('TABLE','VIEW','INDEX','SYNONYM')
GROUP  BY object_type
ORDER  BY object_type;

PROMPT
PROMPT 7. Row count sanity checks for base tables
PROMPT

SELECT 'ORG_UNITS' AS check_name, COUNT(*) AS row_count FROM BUDGET.ORG_UNITS
UNION ALL
SELECT 'COST_CENTERS', COUNT(*) FROM BUDGET.COST_CENTERS
UNION ALL
SELECT 'BUDGET_PERIODS', COUNT(*) FROM BUDGET.BUDGET_PERIODS
UNION ALL
SELECT 'EXPENSE_CATEGORIES', COUNT(*) FROM BUDGET.EXPENSE_CATEGORIES
UNION ALL
SELECT 'BUDGET_ALLOCATIONS', COUNT(*) FROM BUDGET.BUDGET_ALLOCATIONS
UNION ALL
SELECT 'ACTUAL_EXPENSES', COUNT(*) FROM BUDGET.ACTUAL_EXPENSES;

PROMPT
PROMPT 8. Candidate AI view row count
PROMPT

SELECT '&P_AI_VIEW' AS check_name,
       COUNT(*) AS row_count
FROM   BUDGET.VW_BUDGET_VS_ACTUAL;

PROMPT
PROMPT 9. Candidate AI view sample rows
PROMPT

SELECT *
FROM   BUDGET.VW_BUDGET_VS_ACTUAL
FETCH FIRST 10 ROWS ONLY;

PROMPT
PROMPT 10. Comments readiness indicators
PROMPT

SELECT 'TABLE COMMENTS' AS check_name,
       CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'WARN' END AS status,
       'Number of table comments in application schema: ' || COUNT(*) AS details
FROM   dba_tab_comments
WHERE  owner = UPPER('&P_APP_SCHEMA')
AND    comments IS NOT NULL
UNION ALL
SELECT 'COLUMN COMMENTS' AS check_name,
       CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'WARN' END AS status,
       'Number of column comments in application schema: ' || COUNT(*) AS details
FROM   dba_col_comments
WHERE  owner = UPPER('&P_APP_SCHEMA')
AND    comments IS NOT NULL;

PROMPT
PROMPT 11. Existing network ACL entries for provider host (safe check)
PROMPT

SELECT host,
       lower_port,
       upper_port,
       acl,
       acl_owner
FROM   dba_host_acls
WHERE  LOWER(host) = LOWER('&P_PROVIDER_HOST')
ORDER  BY host, lower_port, upper_port;

PROMPT
PROMPT 12. Existing host ACE principals for provider host
PROMPT

SELECT host,
       lower_port,
       upper_port,
       principal,
       privilege,
       principal_type,
       inverted_principal,
       start_date,
       end_date
FROM   dba_host_aces
WHERE  LOWER(host) = LOWER('&P_PROVIDER_HOST')
ORDER  BY host, principal, privilege;

PROMPT
PROMPT 13. Manual external prerequisites checklist
PROMPT
PROMPT - Confirm that the database host or container has outbound internet access.
PROMPT - Confirm that an OpenAI API key is available and approved for this PoC.
PROMPT - Confirm that the runtime user for Stage 3 will be BUDGET.
PROMPT - Confirm that the first profile should start with BUDGET.VW_BUDGET_VS_ACTUAL only.
PROMPT - If DBMS_CLOUD and DBMS_CLOUD_AI are missing, install DBMS_CLOUD family packages before Stage 3 setup.

PROMPT
PROMPT 14. Final quick status summary
PROMPT

SELECT 'Application schema exists' AS check_name,
       CASE WHEN COUNT(*) = 1 THEN 'OK' ELSE 'FAIL' END AS status,
       'Expected schema: &P_APP_SCHEMA' AS details
FROM   dba_users
WHERE  username = UPPER('&P_APP_SCHEMA')
UNION ALL
SELECT 'Candidate AI view exists',
       CASE WHEN COUNT(*) = 1 THEN 'OK' ELSE 'FAIL' END,
       'Expected object: &P_APP_SCHEMA..&P_AI_VIEW'
FROM   dba_objects
WHERE  owner = UPPER('&P_APP_SCHEMA')
AND    object_name = UPPER('&P_AI_VIEW')
AND    object_type = 'VIEW'
UNION ALL
SELECT 'DBMS_CLOUD package exists',
       CASE WHEN COUNT(*) = 1 THEN 'OK' ELSE 'FAIL' END,
       'Package required for credential creation and cloud access'
FROM   dba_objects
WHERE  owner = 'SYS'
AND    object_name = 'DBMS_CLOUD'
AND    object_type = 'PACKAGE'
UNION ALL
SELECT 'DBMS_CLOUD_AI package exists',
       CASE WHEN COUNT(*) = 1 THEN 'OK' ELSE 'FAIL' END,
       'Package required for Select AI setup'
FROM   dba_objects
WHERE  owner = 'SYS'
AND    object_name = 'DBMS_CLOUD_AI'
AND    object_type = 'PACKAGE'
UNION ALL
SELECT 'Runtime user exists',
       CASE WHEN COUNT(*) = 1 THEN 'OK' ELSE 'FAIL' END,
       'Expected user: &P_RUNTIME_USER'
FROM   dba_users
WHERE  username = UPPER('&P_RUNTIME_USER');

PROMPT
PROMPT ================================================================
PROMPT End of Stage 3 prerequisite checks
PROMPT ================================================================
