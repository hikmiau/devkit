> [!NOTE]
> This is a legacy Windows development environment setup repository.
>
> It reflects my previous Windows workflow. My current daily development environment is Arch Linux with dwm.

# devkit

Windows development environment scripts for tools, folders, project templates, dotfiles, and Git workflow.

## Personal setup notice

This repository is based on my personal Windows development setup.

The tools listed here are the ones I use for my own workflow, including Neovim, IntelliJ IDEA, Visual Studio, Git, Java, C#, Python, Lua, PowerShell, SQL, Kubernetes, Figma, GIMP, Discord, and other development utilities.

Before running the install script, check the configuration file and remove anything you do not want to install.

Main config file:

```text
config/devkit.json
```

The install script does not choose tools automatically. It installs the package groups listed in the config file.

## Customizing the tools

To change what gets installed, edit:

```text
config/devkit.json
```

Inside the file, change the `packageGroups` section.

Example:

```json
"packageGroups": {
  "core": [
    "neovim",
    "git",
    "gh",
    "lazygit"
  ],
  "languages": [
    "python",
    "openjdk",
    "dotnet-sdk"
  ]
}
```

Then run only the group you want:

```powershell
.\scripts\Install-DevPackages.ps1 -Groups core
```

Or run multiple groups:

```powershell
.\scripts\Install-DevPackages.ps1 -Groups core,languages
```

Running this installs everything listed in every group:

```powershell
.\scripts\Install-DevPackages.ps1 -Groups all
```

Review the config before using `-Groups all`.

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

> This setup is personal. Review `config/devkit.json` before running the install commands.

Clone the repository:

```powershell
git clone https://github.com/hikmiau/devkit.git
cd devkit
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

## Project structure

```text
devkit
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
