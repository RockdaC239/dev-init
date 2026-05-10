param(
    [switch]$SkipNpm
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Test-Command {
    param([string]$Name)
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

$Root = Split-Path -Parent $PSScriptRoot
$ConfigPath = Join-Path $Root "config\tools.json"
$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

Write-Step "Checking winget"
if (-not (Test-Command "winget")) {
    throw "winget is required. Install App Installer from Microsoft Store, then run this script again."
}

Write-Step "Installing Windows packages"
foreach ($Package in $Config.winget) {
    Write-Host "Installing $($Package.name) [$($Package.id)]"
    winget install --id $Package.id --exact --accept-package-agreements --accept-source-agreements
}

Write-Step "Refreshing PATH for this session"
$MachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = "$MachinePath;$UserPath"

if (-not $SkipNpm) {
    Write-Step "Installing global npm CLIs"
    if (-not (Test-Command "npm")) {
        Write-Warning "npm is not available in this session yet. Open a new terminal and run: npm install -g $($Config.npmGlobal -join ' ')"
    }
    else {
        npm install -g @($Config.npmGlobal)
    }
}

Write-Step "Manual login commands"
$Config.postInstall | ForEach-Object { Write-Host "  $_" }

Write-Host ""
Write-Host "Done. Restart the terminal if newly installed commands are not found." -ForegroundColor Green
