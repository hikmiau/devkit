param(
    [Parameter(Mandatory)]
    [string]$Name,

    [ValidateSet("java", "csharp", "python", "lua", "powershell", "batch", "sql", "empty")]
    [string]$Language = "empty",

    [ValidateSet("public", "private")]
    [string]$Visibility = "public",

    [switch]$GitHub
)

Import-Module "$PSScriptRoot\..\src\DevKit.psm1" -Force

New-DevProject -Name $Name -Language $Language -Visibility $Visibility -GitHub:$GitHub
