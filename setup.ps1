$ErrorActionPreference = "Stop"

$Script = Join-Path $PSScriptRoot "windows\setup.ps1"
& $Script @args
