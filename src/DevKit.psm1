function Get-DevKitConfig {
    param([string]$Path = (Join-Path $PSScriptRoot "..\config\devkit.json"))

    $localPath = Join-Path $PSScriptRoot "..\config\devkit.local.json"

    if (Test-Path $localPath) {
        return Get-Content $localPath -Raw | ConvertFrom-Json
    }

    Get-Content $Path -Raw | ConvertFrom-Json
}

function Expand-DevPath {
    param([string]$Path)

    [Environment]::ExpandEnvironmentVariables($Path)
}

function Get-DevPackages {
    param(
        [string[]]$Groups = @("core", "languages"),
        [string]$ConfigPath = (Join-Path $PSScriptRoot "..\config\devkit.json")
    )

    $config = Get-DevKitConfig $ConfigPath
    $packages = New-Object System.Collections.Generic.List[string]

    if ($Groups -contains "all") {
        foreach ($group in $config.packageGroups.PSObject.Properties) {
            foreach ($package in $group.Value) {
                if (-not $packages.Contains($package)) {
                    $packages.Add($package)
                }
            }
        }

        return $packages
    }

    foreach ($groupName in $Groups) {
        $group = $config.packageGroups.PSObject.Properties[$groupName]

        if ($group) {
            foreach ($package in $group.Value) {
                if (-not $packages.Contains($package)) {
                    $packages.Add($package)
                }
            }
        }
    }

    $packages
}

function Install-DevPackages {
    param(
        [string[]]$Groups = @("core", "languages"),
        [string]$ConfigPath = (Join-Path $PSScriptRoot "..\config\devkit.json")
    )

    $packages = @(Get-DevPackages -Groups $Groups -ConfigPath $ConfigPath)

    if ($packages.Count -eq 0) {
        return
    }

    & choco install @packages -y --no-progress
}

function New-DevFolders {
    param([string]$ConfigPath = (Join-Path $PSScriptRoot "..\config\devkit.json"))

    $config = Get-DevKitConfig $ConfigPath
    $created = New-Object System.Collections.Generic.List[object]

    foreach ($group in $config.folderGroups.PSObject.Properties) {
        foreach ($folder in $group.Value) {
            $path = Expand-DevPath $folder
            New-Item -ItemType Directory -Force $path | Out-Null

            $created.Add([pscustomobject]@{
                Group = $group.Name
                Path = $path
                Exists = Test-Path $path
            })
        }
    }

    $created
}

function Test-DevTools {
    param([string]$ConfigPath = (Join-Path $PSScriptRoot "..\config\devkit.json"))

    $config = Get-DevKitConfig $ConfigPath
    $results = New-Object System.Collections.Generic.List[object]

    foreach ($tool in $config.tools) {
        $command = Get-Command $tool.command -ErrorAction SilentlyContinue

        if (-not $command) {
            $results.Add([pscustomobject]@{
                Name = $tool.name
                Command = $tool.command
                Installed = $false
                Version = $null
            })

            continue
        }

        $version = try {
            (& $command.Source @($tool.args) 2>&1 | Select-Object -First 1).ToString()
        } catch {
            $null
        }

        $results.Add([pscustomobject]@{
            Name = $tool.name
            Command = $tool.command
            Installed = $true
            Version = $version
        })
    }

    $results
}

function New-DevProject {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [ValidateSet("java", "csharp", "python", "lua", "powershell", "batch", "sql", "empty")]
        [string]$Language = "empty",

        [ValidateSet("public", "private")]
        [string]$Visibility = "public",

        [switch]$GitHub,

        [string]$ConfigPath = (Join-Path $PSScriptRoot "..\config\devkit.json")
    )

    $config = Get-DevKitConfig $ConfigPath
    $root = Join-Path (Expand-DevPath $config.projectRoot) $Name

    New-Item -ItemType Directory -Force $root | Out-Null
    Push-Location $root

    Set-Content README.md "# $Name`n`n$Language project.`n" -Encoding utf8

    switch ($Language) {
        "java" {
            New-Item -ItemType Directory -Force "src\main\java" | Out-Null
            Set-Content "src\main\java\Main.java" "public class Main { public static void main(String[] args) { } }" -Encoding utf8
            Set-Content ".gitignore" "target/`n*.class`n*.jar`nbuild/`n.gradle/`n" -Encoding utf8
        }
        "csharp" {
            Set-Content "$Name.csproj" "<Project Sdk=`"Microsoft.NET.Sdk`"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net8.0</TargetFramework><ImplicitUsings>enable</ImplicitUsings><Nullable>enable</Nullable></PropertyGroup></Project>" -Encoding utf8
            Set-Content "Program.cs" "namespace $Name; internal class Program { private static void Main(string[] args) { } }" -Encoding utf8
            Set-Content ".gitignore" "bin/`nobj/`n.vs/`n*.user`n" -Encoding utf8
        }
        "python" {
            Set-Content "main.py" "def main():`n    pass`n`nif __name__ == `"__main__`":`n    main()`n" -Encoding utf8
            Set-Content ".gitignore" "__pycache__/`n*.pyc`n.venv/`n.env`n" -Encoding utf8
        }
        "lua" {
            Set-Content "init.lua" "local M = {}`n`nreturn M`n" -Encoding utf8
            Set-Content ".gitignore" ".luarocks/`n" -Encoding utf8
        }
        "powershell" {
            Set-Content "main.ps1" "param()`n" -Encoding utf8
            Set-Content ".gitignore" "*.log`n*.tmp`n.env`n" -Encoding utf8
        }
        "batch" {
            Set-Content "main.bat" "@echo off`n" -Encoding ascii
            Set-Content ".gitignore" "*.log`n*.tmp`n" -Encoding utf8
        }
        "sql" {
            Set-Content "schema.sql" "CREATE TABLE IF NOT EXISTS example (`n    id INTEGER PRIMARY KEY`n);`n" -Encoding utf8
            Set-Content ".gitignore" "*.db`n*.sqlite`n*.sqlite3`n" -Encoding utf8
        }
        default {
            Set-Content ".gitignore" "*.log`n*.tmp`n.env`n" -Encoding utf8
        }
    }

    git init | Out-Null
    git add .
    git commit -m "Initial commit" | Out-Null

    if ($GitHub) {
        gh repo create $Name "--$Visibility" --source=. --remote=origin --push
    }

    Pop-Location
    Get-Item $root
}

function Sync-DevDotfiles {
    param(
        [ValidateSet("Backup", "Restore")]
        [string]$Mode,

        [string]$ConfigPath = (Join-Path $PSScriptRoot "..\config\devkit.json")
    )

    $config = Get-DevKitConfig $ConfigPath
    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $results = New-Object System.Collections.Generic.List[object]

    foreach ($item in $config.dotfiles) {
        $source = Expand-DevPath $item.source
        $target = Join-Path $repoRoot ("dotfiles\" + $item.target)

        if ($Mode -eq "Backup" -and (Test-Path $source)) {
            New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
            Copy-Item $source $target -Recurse -Force
        }

        if ($Mode -eq "Restore" -and (Test-Path $target)) {
            New-Item -ItemType Directory -Force (Split-Path $source) | Out-Null
            Copy-Item $target $source -Recurse -Force
        }

        $results.Add([pscustomobject]@{
            Mode = $Mode
            Source = $source
            Target = $target
        })
    }

    $results
}

function Invoke-GitSnapshot {
    param([string]$Message = "Update repository")

    git add .
    git diff --cached --quiet

    if ($LASTEXITCODE -eq 0) {
        return [pscustomobject]@{
            Committed = $false
            Pushed = $false
        }
    }

    git commit -m $Message
    git push

    [pscustomobject]@{
        Committed = $true
        Pushed = $true
    }
}

Export-ModuleMember -Function *
