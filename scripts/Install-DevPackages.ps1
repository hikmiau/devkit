param(
    [string[]]$Groups = @("core", "languages")
)

Import-Module "$PSScriptRoot\..\src\DevKit.psm1" -Force

Install-DevPackages -Groups $Groups
