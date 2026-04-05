#!/usr/bin/env bash
set -euo pipefail

# 20_INSTALL_DBMS_CLOUD.sh
#
# Simple version:
# - Hardcoded install owner check: C##CLOUD$SERVICE
# - No awk parsing tricks
# - Run from host against container oracle26ai

CONTAINER_NAME="${CONTAINER_NAME:-oracle26ai}"
ORACLE_HOME_IN_CONTAINER="${ORACLE_HOME_IN_CONTAINER:-/opt/oracle/product/26ai/dbhomeFree}"
CATCON_PL="${CATCON_PL:-${ORACLE_HOME_IN_CONTAINER}/rdbms/admin/catcon.pl}"
INSTALL_SQL="${INSTALL_SQL:-${ORACLE_HOME_IN_CONTAINER}/rdbms/admin/dbms_cloud_install.sql}"
PERL_BIN="${PERL_BIN:-${ORACLE_HOME_IN_CONTAINER}/perl/bin/perl}"
LOG_DIR_IN_CONTAINER="${LOG_DIR_IN_CONTAINER:-/tmp/dbms_cloud_install}"
LOG_BASENAME="${LOG_BASENAME:-dbms_cloud_install}"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") "<sys_password>"

Example:
  $(basename "$0") "StrongSysPasswordHere"
EOF
}

log() {
  printf '[INFO] %s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 1 ]]; then
  usage
  fail "Missing required SYS password argument."
fi

SYS_PASSWORD="$1"

command -v docker >/dev/null 2>&1 || fail "docker command not found on the host."

log "Checking container availability: ${CONTAINER_NAME}"
docker inspect "${CONTAINER_NAME}" >/dev/null 2>&1 || fail "Container ${CONTAINER_NAME} was not found."

RUNNING_STATE="$(docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}")"
[[ "${RUNNING_STATE}" == "true" ]] || fail "Container ${CONTAINER_NAME} is not running."

log "Checking required files inside container"
docker exec "${CONTAINER_NAME}" test -f "${CATCON_PL}" || fail "Missing catcon.pl: ${CATCON_PL}"
docker exec "${CONTAINER_NAME}" test -f "${INSTALL_SQL}" || fail "Missing install script: ${INSTALL_SQL}"
docker exec "${CONTAINER_NAME}" test -x "${PERL_BIN}" || fail "Missing perl binary: ${PERL_BIN}"

log "Checking that HARDCODED user C##CLOUD\$SERVICE exists in CDB\$ROOT"
docker exec "${CONTAINER_NAME}" bash -lc "sqlplus -s / as sysdba <<'SQL'
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 200
SET TRIMSPOOL ON
ALTER SESSION SET CONTAINER = CDB\$ROOT;
SELECT 'FOUND'
FROM   CDB_USERS
WHERE  USERNAME = 'C##CLOUD\$SERVICE'
AND    COMMON = 'YES';
EXIT
SQL" | grep -q '^FOUND$' || fail "HARDCODED user C##CLOUD\$SERVICE was not found in CDB\$ROOT. Run 19_CREATE_CLOUD_USER.sh first."

log "Preparing log directory inside container"
docker exec "${CONTAINER_NAME}" mkdir -p "${LOG_DIR_IN_CONTAINER}"

log "About to run dbms_cloud_install.sql via catcon.pl"
log "Container ..........: ${CONTAINER_NAME}"
log "Oracle Home ........: ${ORACLE_HOME_IN_CONTAINER}"
log "catcon.pl ..........: ${CATCON_PL}"
log "Install script .....: ${INSTALL_SQL}"
log "Perl binary ........: ${PERL_BIN}"
log "Log dir ............: ${LOG_DIR_IN_CONTAINER}"
log "Log basename .......: ${LOG_BASENAME}"

docker exec   -e CATCON_PL="${CATCON_PL}"   -e INSTALL_SQL="${INSTALL_SQL}"   -e PERL_BIN="${PERL_BIN}"   -e LOG_DIR_IN_CONTAINER="${LOG_DIR_IN_CONTAINER}"   -e LOG_BASENAME="${LOG_BASENAME}"   -e SYS_PASSWORD="${SYS_PASSWORD}"   "${CONTAINER_NAME}"   bash -lc '
set -euo pipefail

"${PERL_BIN}" "${CATCON_PL}"   -u "sys/${SYS_PASSWORD}"   -force_pdb_mode "READ WRITE"   -b "${LOG_BASENAME}"   -d "$(dirname "${INSTALL_SQL}")"   -l "${LOG_DIR_IN_CONTAINER}"   "$(basename "${INSTALL_SQL}")"
'

log "dbms_cloud_install.sql completed."
log "Next step: review catcon logs in ${LOG_DIR_IN_CONTAINER} and run verification SQL."
