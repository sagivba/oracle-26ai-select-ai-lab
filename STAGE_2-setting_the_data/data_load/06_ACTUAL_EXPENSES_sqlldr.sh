#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo 'Usage: ./06_ACTUAL_EXPENSES_sqlldr.sh username/password@//host:port/service [log_dir]'
  exit 1
fi

CONNECT_STRING="$1"
LOG_DIR="${2:-logs}"
mkdir -p "$LOG_DIR"

sqlldr "$CONNECT_STRING" control=06_ACTUAL_EXPENSES.ctl log="$LOG_DIR/actual_expenses.log" bad="$LOG_DIR/actual_expenses.bad" discard="$LOG_DIR/actual_expenses.dsc"
