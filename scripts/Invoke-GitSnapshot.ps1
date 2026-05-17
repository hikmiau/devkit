param(
    [string]$Message = "Update repository"
)

Import-Module "$PSScriptRoot\..\src\DevKit.psm1" -Force

Invoke-GitSnapshot -Message $Message
