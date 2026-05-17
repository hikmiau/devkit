@echo off
setlocal
cd /d "%~dp0"

set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if not exist "%PS%" (
    set "PS=%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
)

if not exist "%PS%" (
    echo PowerShell was not found.
    pause
    exit /b 1
)

:menu
cls
echo ==========================
echo        aira-devkit
echo ==========================
echo.
echo 1. Install core tools
echo 2. Install core + language tools
echo 3. Install everything
echo 4. Create development folders
echo 5. Check installed tools
echo 6. Create new project
echo 7. Backup dotfiles
echo 8. Restore dotfiles
echo 9. Git snapshot
echo Q. Quit
echo.

choice /C 123456789Q /N /M "Choose an option: "

if errorlevel 10 goto end
if errorlevel 9 goto snapshot
if errorlevel 8 goto restore
if errorlevel 7 goto backup
if errorlevel 6 goto new_project
if errorlevel 5 goto check
if errorlevel 4 goto folders
if errorlevel 3 goto install_all
if errorlevel 2 goto install_core_languages
if errorlevel 1 goto install_core

goto menu

:install_core
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-DevPackages.ps1" -Groups core
pause
goto menu

:install_core_languages
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-DevPackages.ps1" -Groups core languages
pause
goto menu

:install_all
choice /M "This will install every package group. Continue"
if errorlevel 2 goto menu
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-DevPackages.ps1" -Groups all
pause
goto menu

:folders
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\New-DevFolders.ps1"
pause
goto menu

:check
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Test-DevTools.ps1"
pause
goto menu

:new_project
set /p project_name="Project name: "
set /p project_language="Language java/csharp/python/lua/powershell/batch/sql/empty: "
set /p github_create="Create GitHub repo? y/n: "

if /i "%github_create%"=="y" (
    set /p visibility="Visibility public/private: "
    "%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\New-DevProject.ps1" -Name "%project_name%" -Language "%project_language%" -GitHub -Visibility "%visibility%"
) else (
    "%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\New-DevProject.ps1" -Name "%project_name%" -Language "%project_language%"
)

pause
goto menu

:backup
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Sync-DevDotfiles.ps1" -Mode Backup
pause
goto menu

:restore
choice /M "This will restore dotfiles to your system. Continue"
if errorlevel 2 goto menu
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Sync-DevDotfiles.ps1" -Mode Restore
pause
goto menu

:snapshot
set /p commit_message="Commit message: "
if "%commit_message%"=="" set "commit_message=Update toolkit"
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Invoke-GitSnapshot.ps1" -Message "%commit_message%"
pause
goto menu

:end
endlocal
exit /b
