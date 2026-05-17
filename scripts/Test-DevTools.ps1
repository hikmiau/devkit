Import-Module "$PSScriptRoot\..\src\DevKit.psm1" -Force

Test-DevTools | Sort-Object Installed, Name | Format-Table -AutoSize
