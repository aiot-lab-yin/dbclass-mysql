# ==============================================
# stop.ps1 - MySQL コンテナを安全に停止（データ保持）
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
    Write-Host "  pwsh ./scripts/stop.ps1" -ForegroundColor Cyan
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
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir   = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $rootDir

# --- コンテナを停止 ---
Write-Host "🛑 MySQL コンテナを停止しています..." -ForegroundColor Cyan
docker compose down

Write-Host "✅ コンテナを停止しました。データは保持されています。" -ForegroundColor Green
Write-Host "📂 データディレクトリ: $rootDir\db_data"
