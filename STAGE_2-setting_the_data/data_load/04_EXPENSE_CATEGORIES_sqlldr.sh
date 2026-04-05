#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo 'Usage: ./04_EXPENSE_CATEGORIES_sqlldr.sh username/password@//host:port/service [log_dir]'
  exit 1
fi

CONNECT_STRING="$1"
LOG_DIR="${2:-logs}"
mkdir -p "$LOG_DIR"

sqlldr "$CONNECT_STRING" control=04_EXPENSE_CATEGORIES.ctl log="$LOG_DIR/expense_categories.log" bad="$LOG_DIR/expense_categories.bad" discard="$LOG_DIR/expense_categories.dsc"
