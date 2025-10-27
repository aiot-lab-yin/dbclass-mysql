# ==============================================
# reset.ps1 - 安全に MySQL データベースをリセット
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
    Write-Host "  pwsh ./scripts/reset.ps1" -ForegroundColor Cyan
    exit 1
}

# --- Reset confirmation ---
Write-Host "⚠️  リセットを実行します。これまでの実行結果（db_data 内のデータ）は完全に削除されます。" -ForegroundColor Yellow
$ans = Read-Host "本当に初期化しますか？ [y/N]"
if ($ans -notmatch '^(y|Y|yes|YES)$') {
    Write-Host "キャンセルしました。データは保持されています。" -ForegroundColor Yellow
    exit 0
}

# --- Prepare directories ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir   = Resolve-Path (Join-Path $scriptDir "..")

# --- Stop and remove containers ---
Write-Host "🗑️  データ削除中: $rootDir\db_data" -ForegroundColor Yellow
docker compose down -v

# 🕒 Wait for Docker to release volume (important!)
Start-Sleep -Seconds 3

# --- Delete db_data safely ---
if (Test-Path "$rootDir\db_data") {
    try {
        Remove-Item -Recurse -Force "$rootDir\db_data"
        Write-Host "✅ データディレクトリを削除しました。" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  削除に失敗。再試行します..." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Remove-Item -Recurse -Force "$rootDir\db_data"
    }
}

# --- Recreate directory ---
New-Item -ItemType Directory -Force -Path "$rootDir\db_data" | Out-Null

# --- Restart containers ---
Write-Host "🐳 Docker コンテナを再起動しています..." -ForegroundColor Cyan
docker compose up -d

# --- Wait until MySQL is healthy ---
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

Write-Host "📂 データディレクトリ: $rootDir\db_data"
