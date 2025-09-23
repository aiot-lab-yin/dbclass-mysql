#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p db_data
docker compose up -d
echo "Started: MySQL on localhost:13306 (db=sampledb user=student). Data dir: $ROOT_DIR/db_data"
