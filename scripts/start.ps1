# ==============================================
# start.ps1 - クロスプラットフォーム対応 PowerShell スクリプト
# MySQL コンテナの起動（Windows / mac 共通 docker-compose.yml）
# ==============================================

# --- PowerShell version check (English) ---
$psVer = $PSVersionTable.PSVersion.Major
if ($psVer -lt 7) {
    Write-Host "⚠️  Your current PowerShell version is $psVer." -ForegroundColor Yellow
    Write-Host "💡  PowerShell 7 or later is recommended for full UTF-8 and cross-platform support." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install or upgrade PowerShell 7 using one of the following options:" -ForegroundColor Cyan
    Write-Host "  1. Microsoft official site: https://aka.ms/powershell" -ForegroundColor Cyan
    Write-Host "  2. Microsoft Store → Search for 'PowerShell 7' and install" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "If PowerShell 7 is already installed, run this script again using:" -ForegroundColor Cyan
    Write-Host "  pwsh ./scripts/start.ps1" -ForegroundColor Cyan
    exit 1
}

# --- Docker Desktop の起動状態を確認 ---
Write-Host "🔍 Docker Desktop の状態を確認しています..." -ForegroundColor Cyan
docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️ Docker Desktop が起動していません。手動で起動してください。" -ForegroundColor Yellow
    Write-Host "   スタートメニューから「Docker Desktop」を検索して起動し、" -ForegroundColor Yellow
    Write-Host "   ステータスが『Docker Desktop is running』になるまでお待ちください。" -ForegroundColor Yellow
    Write-Host "   その後、このスクリプトを再実行してください。" -ForegroundColor Yellow
    exit 1
}

# --- プロジェクトルートディレクトリへ移動 ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir   = Resolve-Path (Join-Path $ScriptDir "..")
Set-Location $RootDir

# --- データディレクトリを作成（存在しない場合） ---
New-Item -ItemType Directory -Force -Path (Join-Path $RootDir "db_data") | Out-Null

# --- MySQL コンテナを起動 ---
Write-Host "🚀 MySQL コンテナを起動しています..." -ForegroundColor Cyan
docker compose up -d

# --- MySQL が正常に起動するまで待機 ---
Write-Host "⌛ MySQL の起動を待機しています..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
$healthy = $false

while ($attempt -lt $maxAttempts) {
    $status = docker inspect --format='{{.State.Health.Status}}' dbclass-mysql-db-1 2>$null
    if ($status -eq "healthy") {
        $healthy = $true
        break
    }
    Start-Sleep -Seconds 2
    $attempt++
}

if ($healthy) {
    Write-Host "✅ MySQL が正常に起動しました！" -ForegroundColor Green
} else {
    Write-Host "⚠️ MySQL の起動がタイムアウトしました（約60秒経過）。" -ForegroundColor Red
    Write-Host "   docker ps または docker logs dbclass-mysql-db-1 で状態を確認してください。" -ForegroundColor Yellow
}

Write-Host "✅ 起動完了: MySQL (ホスト: localhost:13306, DB: sampledb, ユーザー: student)" -ForegroundColor Green
Write-Host "📂 データディレクトリ: $RootDir\db_data"
