# devkit

Windows development environment scripts for tools, folders, project templates, dotfiles, and Git workflow.

## Features

- Chocolatey package groups
- Folder generation
- Tool/version checks
- Project template generation
- GitHub repo creation
- Dotfile backup and restore
- Git snapshot helper
- Local config support

## Scripts

| Script                            | Purpose                             |
| --------------------------------- | ----------------------------------- |
| `scripts/Install-DevPackages.ps1` | Installs Chocolatey package groups  |
| `scripts/New-DevFolders.ps1`      | Creates development folders         |
| `scripts/Test-DevTools.ps1`       | Checks installed command-line tools |
| `scripts/New-DevProject.ps1`      | Creates project templates           |
| `scripts/Sync-DevDotfiles.ps1`    | Backs up or restores dotfiles       |
| `scripts/Invoke-GitSnapshot.ps1`  | Adds, commits, and pushes changes   |

## Usage

Clone the repository:

```powershell
git clone https://github.com/hikmiau/aira-devkit.git
cd aira-devkit
```

Install the core tools:

```powershell
.\scripts\Install-DevPackages.ps1 -Groups core
```

Install core tools and programming language tools:

```powershell
.\scripts\Install-DevPackages.ps1 -Groups core,languages
```

Install everything:

```powershell
.\scripts\Install-DevPackages.ps1 -Groups all
```

Create the folder structure:

```powershell
.\scripts\New-DevFolders.ps1
```

Check installed tools:

```powershell
.\scripts\Test-DevTools.ps1
```

Generate a new Java project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-java -Language java
```

Generate a new C# project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-csharp -Language csharp
```

Generate a new Python project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-python -Language python
```

Generate a new Lua project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-lua -Language lua
```

Generate a new PowerShell project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-powershell -Language powershell
```

Generate a new Batch project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-batch -Language batch
```

Generate a new SQL project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-sql -Language sql
```

Create a GitHub repository with the generated project:

```powershell
.\scripts\New-DevProject.ps1 -Name demo-java -Language java -GitHub -Visibility public
```

Backup dotfiles:

```powershell
.\scripts\Sync-DevDotfiles.ps1 -Mode Backup
```

Restore dotfiles:

```powershell
.\scripts\Sync-DevDotfiles.ps1 -Mode Restore
```

Commit and push changes:

```powershell
.\scripts\Invoke-GitSnapshot.ps1 "Update toolkit"
```

## Package groups

| Group       | Description                              |
| ----------- | ---------------------------------------- |
| `core`      | Main terminal and development tools      |
| `languages` | Programming language tools and compilers |
| `ides`      | IDEs and editors                         |
| `design`    | Design and image editing tools           |
| `devops`    | DevOps tools                             |
| `social`    | Social/communication tools               |
| `all`       | Installs every package group             |

## Configuration

Main config file:

```text
config/devkit.json
```

Local private config file:

```text
config/devkit.local.json
```

The local config file is ignored by Git, so it can be used for private paths or personal changes.

## Tools

- Neovim
- IntelliJ IDEA
- Visual Studio
- Git
- GitHub CLI
- LazyGit
- Kubernetes CLI
- Figma
- GIMP
- npm
- Zig
- Discord
- Java
- C#
- MySQL
- SQLite
- Python
- Lua
- PowerShell
- Batch

## Project structure

```text
aira-devkit
├── config
│   └── devkit.json
├── dotfiles
│   └── .gitkeep
├── scripts
│   ├── Install-DevPackages.ps1
│   ├── Invoke-GitSnapshot.ps1
│   ├── New-DevFolders.ps1
│   ├── New-DevProject.ps1
│   ├── Sync-DevDotfiles.ps1
│   └── Test-DevTools.ps1
├── src
│   └── DevKit.psm1
├── .gitignore
└── README.md
```

## Notes

This repository uses `%USERPROFILE%` instead of a hardcoded Windows user path.

Dotfiles are ignored by default to avoid uploading private configuration files.
