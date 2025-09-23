#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

echo "⚠️  リセットします。これまでの実行結果（db_data 内のデータ）は削除されます。"
read -r -p "本当に初期化しますか？ [y/N]: " yn
case "$yn" in
  [yY]|[yY][eE][sS])
    echo "データ削除中: $ROOT_DIR/db_data"
    rm -rf "$ROOT_DIR/db_data"
    mkdir -p "$ROOT_DIR/db_data"
    docker compose down
    docker compose up -d
    echo "✅ 初期化完了: 空のデータベースが起動しました（localhost:13306）。"
    ;;
  *)
    echo "キャンセルしました。データは保持されています。"
    ;;
esac
