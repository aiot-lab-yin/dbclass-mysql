$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $rootDir

docker compose down
Write-Host "Stopped containers. Data preserved at: $rootDir\db_data"
