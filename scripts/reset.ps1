$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $rootDir

Write-Host "⚠️  リセットします。これまでの実行結果（db_data 内のデータ）は削除されます。" -ForegroundColor Yellow
$ans = Read-Host "本当に初期化しますか？ [y/N]"
if ($ans -match '^(y|Y|yes|YES)$') {
  Write-Host "データ削除中: $rootDir\db_data"
  if (Test-Path (Join-Path $rootDir "db_data")) {
    Remove-Item -Recurse -Force (Join-Path $rootDir "db_data")
  }
  New-Item -ItemType Directory -Force -Path (Join-Path $rootDir "db_data") | Out-Null
  docker compose down
  docker compose up -d
  Write-Host "✅ 初期化完了: 空のデータベースが起動しました（localhost:13306）。" -ForegroundColor Green
} else {
  Write-Host "キャンセルしました。データは保持されています。"
}
