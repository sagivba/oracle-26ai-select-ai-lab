#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo 'Usage: ./01_ORG_UNITS_sqlldr.sh username/password@//host:port/service [log_dir]'
  exit 1
fi

CONNECT_STRING="$1"
LOG_DIR="${2:-logs}"
mkdir -p "$LOG_DIR"

sqlldr "$CONNECT_STRING" control=01_ORG_UNITS.ctl log="$LOG_DIR/org_units.log" bad="$LOG_DIR/org_units.bad" discard="$LOG_DIR/org_units.dsc"
