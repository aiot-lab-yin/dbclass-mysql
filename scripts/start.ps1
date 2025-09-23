$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Resolve-Path (Join-Path $scriptDir "..")
Set-Location $rootDir

New-Item -ItemType Directory -Force -Path (Join-Path $rootDir "db_data") | Out-Null
docker compose up -d
Write-Host "Started: MySQL on localhost:13306 (db=sampledb user=student). Data dir: $rootDir\db_data"
