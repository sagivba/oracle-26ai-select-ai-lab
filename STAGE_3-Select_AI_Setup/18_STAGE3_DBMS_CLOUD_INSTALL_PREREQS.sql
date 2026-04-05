PROMPT
PROMPT ================================================================
PROMPT Stage 3 - DBMS_CLOUD Installation Prerequisite Checks
PROMPT ================================================================
PROMPT

SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 200
SET LINESIZE 220
SET TRIMSPOOL ON
SET TAB OFF

COLUMN runtime_user_name           FORMAT A20
COLUMN con_name                    FORMAT A15
COLUMN open_mode                   FORMAT A12
COLUMN banner_full                 FORMAT A90
COLUMN username                    FORMAT A25
COLUMN account_status              FORMAT A18
COLUMN profile                     FORMAT A18
COLUMN granted_role                FORMAT A30
COLUMN privilege                   FORMAT A30
COLUMN owner                       FORMAT A25
COLUMN object_name                 FORMAT A40
COLUMN object_type                 FORMAT A20
COLUMN status                      FORMAT A10
COLUMN comp_name                   FORMAT A45
COLUMN version                     FORMAT A18
COLUMN parameter                   FORMAT A35
COLUMN value                       FORMAT A90
COLUMN tablespace_name             FORMAT A25
COLUMN contents                    FORMAT A12
COLUMN extent_management           FORMAT A16
COLUMN allocation_type             FORMAT A16
COLUMN directory_name              FORMAT A30
COLUMN directory_path              FORMAT A90
COLUMN host_name                   FORMAT A40
COLUMN instance_name               FORMAT A20
COLUMN check_name                  FORMAT A38
COLUMN details                     FORMAT A90
COLUMN pdb_name                    FORMAT A15
COLUMN default_tablespace          FORMAT A20
COLUMN temporary_tablespace        FORMAT A20
COLUMN oracle_maintained           FORMAT A5

DEFINE P_INSTALL_OWNER = 'C##CLOUD$SERVICE'
DEFINE P_RUNTIME_USER  = 'BUDGET'
DEFINE P_APP_SCHEMA    = 'BUDGET'

PROMPT Installation owner target ..: &P_INSTALL_OWNER
PROMPT Runtime user target ........: &P_RUNTIME_USER
PROMPT Application schema .........: &P_APP_SCHEMA
PROMPT

PROMPT 1. Session identity and platform
PROMPT
SELECT USER AS runtime_user_name,
       SYS_CONTEXT('USERENV','CON_NAME') AS con_name,
       (SELECT open_mode
          FROM v$pdbs
         WHERE name = SYS_CONTEXT('USERENV','CON_NAME')) AS open_mode
FROM   dual;

SELECT instance_name,
       host_name,
       version
FROM   v$instance;

SELECT banner_full
FROM   v$version
WHERE  banner_full LIKE 'Oracle%';

PROMPT
PROMPT 2. Basic privilege posture of current session
PROMPT
SELECT granted_role
FROM   user_role_privs
ORDER  BY granted_role;

SELECT privilege
FROM   user_sys_privs
ORDER  BY privilege;

PROMPT
PROMPT 3. Target users existence
PROMPT
SELECT username,
       account_status,
       default_tablespace,
       temporary_tablespace,
       profile,
       oracle_maintained,
       created
FROM   dba_users
WHERE  username IN (UPPER('&P_INSTALL_OWNER'), UPPER('&P_RUNTIME_USER'), UPPER('&P_APP_SCHEMA'))
ORDER  BY username;

PROMPT
PROMPT 4. Existing DBMS_CLOUD family objects (should normally be missing before install)
PROMPT
SELECT owner,
       object_name,
       object_type,
       status
FROM   dba_objects
WHERE  object_name IN ('DBMS_CLOUD','DBMS_CLOUD_AI')
ORDER  BY owner, object_name, object_type;

PROMPT
PROMPT 5. Installed database components snapshot
PROMPT
SELECT comp_name,
       version,
       status
FROM   dba_registry
ORDER  BY comp_name;

PROMPT
PROMPT 6. Java-related registry objects snapshot
PROMPT
SELECT comp_name,
       version,
       status
FROM   dba_registry
WHERE  UPPER(comp_name) LIKE '%JAVA%'
   OR  UPPER(comp_name) LIKE '%JVM%'
ORDER  BY comp_name;

PROMPT
PROMPT 7. Users with critical install privileges (visibility only)
PROMPT
SELECT grantee,
       privilege,
       admin_option
FROM   dba_sys_privs
WHERE  grantee IN (UPPER('&P_INSTALL_OWNER'), USER)
  AND  privilege IN (
         'CREATE SESSION',
         'CREATE USER',
         'ALTER USER',
         'DROP USER',
         'CREATE PROCEDURE',
         'CREATE TABLE',
         'CREATE VIEW',
         'CREATE SEQUENCE',
         'CREATE TYPE',
         'CREATE ANY DIRECTORY',
         'DROP ANY DIRECTORY',
         'EXECUTE ANY PROCEDURE',
         'SELECT ANY DICTIONARY',
         'GRANT ANY PRIVILEGE',
         'GRANT ANY ROLE'
       )
ORDER  BY grantee, privilege;

PROMPT
PROMPT 8. Roles granted to target install owner (if already created)
PROMPT
SELECT grantee,
       granted_role,
       admin_option,
       default_role
FROM   dba_role_privs
WHERE  grantee = UPPER('&P_INSTALL_OWNER')
ORDER  BY granted_role;

PROMPT
PROMPT 9. Tablespace snapshot relevant to installation planning
PROMPT
SELECT tablespace_name,
       contents,
       extent_management,
       allocation_type,
       status
FROM   dba_tablespaces
ORDER  BY tablespace_name;

PROMPT
PROMPT 10. Free space snapshot
PROMPT
SELECT tablespace_name,
       ROUND(SUM(bytes) / 1024 / 1024, 2) AS free_mb
FROM   dba_free_space
GROUP  BY tablespace_name
ORDER  BY tablespace_name;

PROMPT
PROMPT 11. Existing DIRECTORY objects
PROMPT
SELECT owner,
       directory_name,
       directory_path
FROM   dba_directories
ORDER  BY owner, directory_name;

PROMPT
PROMPT 12. Network ACL package visibility
PROMPT
SELECT owner,
       object_name,
       object_type,
       status
FROM   dba_objects
WHERE  object_name IN ('DBMS_NETWORK_ACL_ADMIN', 'UTL_HTTP')
ORDER  BY owner, object_name;

PROMPT
PROMPT 13. Application schema snapshot before DBMS_CLOUD installation
PROMPT
SELECT username,
       account_status,
       default_tablespace,
       temporary_tablespace,
       profile
FROM   dba_users
WHERE  username = UPPER('&P_APP_SCHEMA');

PROMPT
PROMPT 14. Final readiness summary
PROMPT
WITH checks AS (
  SELECT 'Current session has DBA role' AS check_name,
         CASE WHEN EXISTS (
                SELECT 1
                FROM   user_role_privs
                WHERE  granted_role = 'DBA'
              ) THEN 'OK' ELSE 'WARN' END AS status,
         'Recommended for prerequisite inspection and likely needed for installation execution' AS details
  FROM dual
  UNION ALL
  SELECT 'Install owner exists',
         CASE WHEN EXISTS (
                SELECT 1 FROM dba_users WHERE username = UPPER('&P_INSTALL_OWNER')
              ) THEN 'OK' ELSE 'INFO' END,
         'Typical owner for DBMS_CLOUD family is &P_INSTALL_OWNER; if missing, create during install phase' 
  FROM dual
  UNION ALL
  SELECT 'Runtime user exists',
         CASE WHEN EXISTS (
                SELECT 1 FROM dba_users WHERE username = UPPER('&P_RUNTIME_USER')
              ) THEN 'OK' ELSE 'FAIL' END,
         'Expected runtime user: &P_RUNTIME_USER'
  FROM dual
  UNION ALL
  SELECT 'Application schema exists',
         CASE WHEN EXISTS (
                SELECT 1 FROM dba_users WHERE username = UPPER('&P_APP_SCHEMA')
              ) THEN 'OK' ELSE 'FAIL' END,
         'Expected application schema: &P_APP_SCHEMA'
  FROM dual
  UNION ALL
  SELECT 'DBMS_CLOUD already installed',
         CASE WHEN EXISTS (
                SELECT 1 FROM dba_objects WHERE object_name = 'DBMS_CLOUD'
              ) THEN 'OK' ELSE 'PENDING' END,
         'If PENDING, proceed to installation phase later'
  FROM dual
  UNION ALL
  SELECT 'DBMS_CLOUD_AI already installed',
         CASE WHEN EXISTS (
                SELECT 1 FROM dba_objects WHERE object_name = 'DBMS_CLOUD_AI'
              ) THEN 'OK' ELSE 'PENDING' END,
         'If PENDING, proceed to installation phase later'
  FROM dual
  UNION ALL
  SELECT 'ACL administration package visible',
         CASE WHEN EXISTS (
                SELECT 1 FROM dba_objects WHERE object_name = 'DBMS_NETWORK_ACL_ADMIN'
              ) THEN 'OK' ELSE 'WARN' END,
         'Needed later for outbound access to provider endpoints'
  FROM dual
)
SELECT check_name,
       status,
       details
FROM   checks
ORDER  BY check_name;

PROMPT
PROMPT Notes:
PROMPT - This script is inspection-only and does not install DBMS_CLOUD.
PROMPT - Review the output before running the actual installation script.
PROMPT - Installation should be executed separately in the next step.
PROMPT
PROMPT ================================================================
PROMPT End of DBMS_CLOUD installation prerequisite checks
PROMPT ================================================================
