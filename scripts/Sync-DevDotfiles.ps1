param(
    [ValidateSet("Backup", "Restore")]
    [string]$Mode
)

Import-Module "$PSScriptRoot\..\src\DevKit.psm1" -Force

Sync-DevDotfiles -Mode $Mode
