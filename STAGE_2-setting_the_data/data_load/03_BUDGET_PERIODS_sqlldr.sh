#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo 'Usage: ./03_BUDGET_PERIODS_sqlldr.sh username/password@//host:port/service [log_dir]'
  exit 1
fi

CONNECT_STRING="$1"
LOG_DIR="${2:-logs}"
mkdir -p "$LOG_DIR"

sqlldr "$CONNECT_STRING" control=03_BUDGET_PERIODS.ctl log="$LOG_DIR/budget_periods.log" bad="$LOG_DIR/budget_periods.bad" discard="$LOG_DIR/budget_periods.dsc"
