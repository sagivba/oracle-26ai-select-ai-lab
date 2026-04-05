#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo 'Usage: ./02_COST_CENTERS_sqlldr.sh username/password@//host:port/service [log_dir]'
  exit 1
fi

CONNECT_STRING="$1"
LOG_DIR="${2:-logs}"
mkdir -p "$LOG_DIR"

sqlldr "$CONNECT_STRING" control=02_COST_CENTERS.ctl log="$LOG_DIR/cost_centers.log" bad="$LOG_DIR/cost_centers.bad" discard="$LOG_DIR/cost_centers.dsc"
