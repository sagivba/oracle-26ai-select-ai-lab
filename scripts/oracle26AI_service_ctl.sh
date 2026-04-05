#!/usr/bin/env bash

# Oracle Docker service control script
# This script starts, stops, restarts, and checks the status of an Oracle
# database container. It verifies container state, listener response, CDB
# status, and PDB open mode, then prints a short summary.

# Stop the script if an undefined variable is used.
set -u

###############################################################################
# Configuration
###############################################################################
CONTAINER_NAME="oracle26ai"
#CONTAINER_NAME="oracle-free"
PDB_NAME="FREEPDB1"
START_TIMEOUT=900
STOP_TIMEOUT=180
SLEEP_INTERVAL=10

###############################################################################
# Colors
###############################################################################
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

###############################################################################
# Helpers
###############################################################################
log() { echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*"; }
ok()  { echo -e "${GREEN}[OK]${NC} $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; }
err() { echo -e "${RED}[ERROR]${NC} $*"; }
die() { err "$*"; exit 1; }

usage() { cat <<EOF
Usage:
  $0 up
  $0 down
  $0 restart
  $0 status

Description:
  up       - Start Oracle container and wait until DB is usable
  down     - Stop Oracle container gracefully
  restart  - Restart container and validate status
  status   - Show Docker + Listener + DB + PDB status
EOF
}
command_exists()   { command -v "$1" >/dev/null 2>&1; }
container_exists() { docker ps -a --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; }
container_running(){ docker ps --format '{{.Names}}' | grep -Fxq "${CONTAINER_NAME}"; }
docker_health()    { docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' "${CONTAINER_NAME}" 2>/dev/null; }
container_status() { docker inspect --format '{{.State.Status}}' "${CONTAINER_NAME}" 2>/dev/null; }
run_sql()          {
  local sql_text="$1"
  docker exec -i "${CONTAINER_NAME}" bash -lc "sqlplus -s / as sysdba <<'SQL'
set pages 0 feedback off verify off heading off echo off lines 200 trimspool on
${sql_text}
exit
SQL" 2>/dev/null | sed '/^$/d'
}

listener_status() { docker exec -i "${CONTAINER_NAME}" bash -lc "lsnrctl status" 2>/dev/null; }

get_db_open_mode()   { run_sql 'select open_mode from v$database;'; }
get_db_role()        { run_sql 'select database_role from v$database;'; }
get_instance_status(){ run_sql 'select status from v$instance;'; }
get_version()        { run_sql 'select banner_full from v$version where rownum = 1;'; }
get_pdb_status()     { run_sql "select open_mode from v\$pdbs where name = upper('${PDB_NAME}');"; }

is_db_ready() {
  local instance_status db_open pdb_open
  instance_status="$(get_instance_status | tr -d $'\r' | xargs)"
  db_open="$(get_db_open_mode | tr -d $'\r' | xargs)"
  pdb_open="$(get_pdb_status | tr -d $'\r' | xargs)"
  [[ "${instance_status}" == "OPEN" && "${db_open}" == "READ WRITE" && "${pdb_open}" == "READ WRITE" ]]
}
print_summary() {
  local c_exists c_running c_status d_health version instance_status db_role db_open pdb_open

  if ! container_exists; then
    err "Container '${CONTAINER_NAME}' does not exist"
    return 1
  fi

  if container_running; then
    c_running="YES"
  else
    c_running="NO"
  fi

  c_status="$(container_status | tr -d $'\r' | xargs)"
  d_health="$(docker_health | tr -d $'\r' | xargs)"

  echo
  echo "==================== SUMMARY ===================="
  echo "Container Name  : ${CONTAINER_NAME}"
  echo "Container Exists: YES"
  echo "Container Up    : ${c_running}"
  echo "Docker Status   : ${c_status}"
  echo "Docker Health   : ${d_health}"

  if container_running; then
    version="$(get_version | head -n 1 | tr -d $'\r')"
    instance_status="$(get_instance_status | tr -d $'\r' | xargs)"
    db_role="$(get_db_role | tr -d $'\r' | xargs)"
    db_open="$(get_db_open_mode | tr -d $'\r' | xargs)"
    pdb_open="$(get_pdb_status | tr -d $'\r' | xargs)"

    echo "DB Version      : ${version}"
    echo "Instance Status : ${instance_status:-UNKNOWN}"
    echo "DB Role         : ${db_role:-UNKNOWN}"
    echo "CDB Open Mode   : ${db_open:-UNKNOWN}"
    echo "PDB ${PDB_NAME}       : ${pdb_open:-UNKNOWN}"

    if is_db_ready; then
      ok "Oracle service is UP and usable"
    else
      warn "Container is up, but database is not fully ready"
    fi
  else
    warn "Oracle service is DOWN"
  fi

  echo "================================================"
  echo
}
show_listener_check() {
  if ! container_running; then
    warn "Listener check skipped because container is not running"
    return 0
  fi

  echo
  echo "---------------- Listener Check ----------------"

  if listener_status | grep -qi "The command completed successfully"; then
    ok "Listener is responding"
  else
    warn "Could not verify listener cleanly"
  fi

  listener_status | grep -E "Alias|Version|Start Date|Uptime|Listening Endpoints Summary|Service" || true

  echo "------------------------------------------------"
  echo
}
do_up() {
  command_exists docker || die "docker command not found"
  container_exists || die "Container '${CONTAINER_NAME}' does not exist"

  if container_running; then
    warn "Container '${CONTAINER_NAME}' is already running"
  else
    log "Starting container '${CONTAINER_NAME}'"
    docker start "${CONTAINER_NAME}" >/dev/null || die "Failed to start container"
    ok "Container start command sent"
  fi

  log "Waiting for Oracle to become ready"
  local elapsed=0

  while (( elapsed < START_TIMEOUT )); do
    if is_db_ready; then
      ok "Database is fully open"
      show_listener_check
      print_summary
      return 0
    fi

    local d_status d_health
    d_status="$(container_status | tr -d $'\r' | xargs)"
    d_health="$(docker_health | tr -d $'\r' | xargs)"
    log "Current state: docker=${d_status}, health=${d_health}, waited=${elapsed}s/${START_TIMEOUT}s"

    sleep "${SLEEP_INTERVAL}"
    elapsed=$((elapsed + SLEEP_INTERVAL))
  done

  warn "Timeout reached before full readiness"
  show_listener_check
  print_summary
  return 1
}
do_down() {
  command_exists docker || die "docker command not found"
  container_exists || die "Container '${CONTAINER_NAME}' does not exist"

  if ! container_running; then
    warn "Container '${CONTAINER_NAME}' is already stopped"
    print_summary
    return 0
  fi

  log "Stopping container '${CONTAINER_NAME}' gracefully"
  docker stop -t "${STOP_TIMEOUT}" "${CONTAINER_NAME}" >/dev/null || die "Failed to stop container"
  ok "Container stopped"

  if container_running; then
    warn "Container still appears to be running"
    print_summary
    return 1
  fi

  print_summary
  return 0
}
do_status() {
  command_exists docker || die "docker command not found"

  if ! container_exists; then
    err "Container '${CONTAINER_NAME}' does not exist"
    exit 1
  fi

  show_listener_check
  print_summary
}
do_restart() {
  do_down || true
  do_up
}

###############################################################################
# Main
###############################################################################
ACTION="${1:-}"

case "${ACTION}" in
  up)      do_up ;;
  down)    do_down ;;
  restart) do_restart ;;
  status)  do_status ;;
  *)       usage; exit 1 ;;
esac
