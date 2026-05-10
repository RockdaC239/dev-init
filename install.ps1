param(
    [string]$Repo = "https://github.com/RockdaC239/dev-init.git",
    [string]$Target = "$HOME\dev-init"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "Install winget or Git first, then run this installer again."
    }

    winget install --id Git.Git --exact --accept-package-agreements --accept-source-agreements
    $MachinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$MachinePath;$UserPath"
}

if (-not (Test-Path $Target)) {
    git clone $Repo $Target
}
else {
    git -C $Target pull --ff-only
}

& (Join-Path $Target "setup.ps1")
