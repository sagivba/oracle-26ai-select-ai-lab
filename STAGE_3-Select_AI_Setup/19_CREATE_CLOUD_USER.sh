#!/usr/bin/env bash
set -euo pipefail

# 19_CREATE_CLOUD_USER.sh
#
# Purpose:
#   Run Oracle's catclouduser.sql from the Oracle Home inside the Docker
#   container, to create the DBMS_CLOUD installation owner user.
#
# Default assumptions:
#   - Container name: oracle26ai
#   - Oracle Home    : /opt/oracle/product/26ai/dbhomeFree
#   - Install owner  : C##CLOUD$SERVICE password in the poc is Oracle123#@
#
# Important:
#   - This script must run from the host, not from inside the container.
#   - catclouduser.sql must run in CDB$ROOT, not in FREEPDB1.
#   - Therefore this script does NOT switch container to FREEPDB1.

CONTAINER_NAME="${CONTAINER_NAME:-oracle26ai}"
ORACLE_HOME_IN_CONTAINER="${ORACLE_HOME_IN_CONTAINER:-/opt/oracle/product/26ai/dbhomeFree}"
INSTALL_OWNER="${INSTALL_OWNER:-C##CLOUD\$SERVICE}"
ORACLE_INSTALL_SCRIPT="${ORACLE_INSTALL_SCRIPT:-${ORACLE_HOME_IN_CONTAINER}/rdbms/admin/catclouduser.sql}"

usage() {
  cat <<EOF
Usage:
  $(basename "$0") "<install_owner_password>"

Example:
  $(basename "$0") "StrongPasswordHere"

Optional environment overrides:
  CONTAINER_NAME
  ORACLE_HOME_IN_CONTAINER
  INSTALL_OWNER
  ORACLE_INSTALL_SCRIPT

Current defaults:
  CONTAINER_NAME=${CONTAINER_NAME}
  ORACLE_HOME_IN_CONTAINER=${ORACLE_HOME_IN_CONTAINER}
  INSTALL_OWNER=${INSTALL_OWNER}
  ORACLE_INSTALL_SCRIPT=${ORACLE_INSTALL_SCRIPT}
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
  fail "Missing required install owner password argument."
fi

INSTALL_PASSWORD="$1"

command -v docker >/dev/null 2>&1 || fail "docker command not found on the host."

log "Checking container availability: ${CONTAINER_NAME}"
docker inspect "${CONTAINER_NAME}" >/dev/null 2>&1 || fail "Container ${CONTAINER_NAME} was not found."

RUNNING_STATE="$(docker inspect -f '{{.State.Running}}' "${CONTAINER_NAME}")"
[[ "${RUNNING_STATE}" == "true" ]] || fail "Container ${CONTAINER_NAME} is not running."

log "Checking Oracle installation script inside container"
docker exec "${CONTAINER_NAME}" test -f "${ORACLE_INSTALL_SCRIPT}" || fail "Missing script: ${ORACLE_INSTALL_SCRIPT}"

log "About to run catclouduser.sql inside the container"
log "Container ..........: ${CONTAINER_NAME}"
log "Oracle Home ........: ${ORACLE_HOME_IN_CONTAINER}"
log "Install owner ......: ${INSTALL_OWNER}"
log "Install script .....: ${ORACLE_INSTALL_SCRIPT}"

docker exec \
  -e INSTALL_OWNER="${INSTALL_OWNER}" \
  -e INSTALL_PASSWORD="${INSTALL_PASSWORD}" \
  -e ORACLE_INSTALL_SCRIPT="${ORACLE_INSTALL_SCRIPT}" \
  "${CONTAINER_NAME}" \
  bash -lc '
set -euo pipefail

sqlplus -s / as sysdba <<SQL
WHENEVER SQLERROR EXIT SQL.SQLCODE

@${ORACLE_INSTALL_SCRIPT} ${INSTALL_OWNER} "${INSTALL_PASSWORD}"

EXIT
SQL
'

log "catclouduser.sql completed."
log "Next step: verify C##CLOUD\$SERVICE in CDB_USERS, then build 20_INSTALL_DBMS_CLOUD.sh"