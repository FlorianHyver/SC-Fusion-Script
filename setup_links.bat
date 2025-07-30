@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: 0. Change this line depending on your installs
set "DIRS=LIVE EPTU PTU HOTFIX TECH-PREVIEW"

:: ─────────────────────────────────────────────────────────
:: 1. Run as Administrator ?
>nul 2>&1 net session || (
    echo.
    echo ERROR: Please run this script as Administrator.
    echo.
    pause
    exit /b 1
)

:: ─────────────────────────────────────────────────────────
:: 2. Preparations
cd /d "%~dp0"
for %%F in (Screenshots Mappings CustomCharacters Profiles) do (
    if not exist "_Backup\%%F" mkdir "_Backup\%%F"
)

echo.

:: ─────────────────────────────────────────────────────────
:: 3. Loop on each build
for %%B in (%DIRS%) do (
    if exist "%%B\" (
        echo == %%B ==
        pushd "%%B" >nul

            call :Process "Screenshots"                     "..\_Backup\Screenshots"
            call :Process "user\client\0\Controls\Mappings" "..\..\..\..\..\_Backup\Mappings"
            call :Process "user\client\0\CustomCharacters"  "..\..\..\..\_Backup\CustomCharacters"
            call :Process "user\client\0\Profiles" "..\..\..\..\_Backup\Profiles"

        popd >nul
        echo.
    ) else (
        echo == %%B ==  
        echo SKIP - folder not found
        echo.
    )
)

echo All done.
echo.
pause
exit /b 0

:: ─────────────────────────────────────────────────────────
:Process <TargetPath> <LinkDestination>
::     Shows BKP:OK/SKIP/ERR  +  LNK:OK/SKIP/ERR
setlocal EnableDelayedExpansion
set "TARGET=%~1"
set "DEST=%~2"

:: Short name for display
for %%Z in ("!TARGET!") do (
    set "NAME=%%~nxZ"
    set "PARENT=%%~dpZ"
)

set "BKP=SKIP"
set "LNK=SKIP"

:: Is TARGET a real folder?
if exist "!TARGET!\" (
    dir /AL "!PARENT!" 2>nul | find /i "<SYMLINKD>" | find /i "!NAME!" >nul
    if errorlevel 1 (
        rem ── Real folder: back it up
        xcopy "!TARGET!\*" "..\_Backup\!NAME!\" /E /H /I /Y /Q >nul 2>&1
        rd /s /q "!TARGET!" 2>nul
        set "BKP=OK"
    ) else (
        rem Already a symlink → nothing to do
        goto :print
    )
)

:: Ensure container tree exists (for new link)
if not exist "!PARENT!" mkdir "!PARENT!" >nul 2>&1

:: Create (or recreate) symlink
mklink /D "!TARGET!" "!DEST!" >nul 2>&1
if errorlevel 1 (
    if "!LNK!"=="SKIP" (set "LNK=ERR") else set "LNK=ERR"
) else (
    set "LNK=OK"
)

:print
set "dots=..............."
call echo !NAME! !dots:~0,15! BKP:!BKP!  LNK:!LNK!
endlocal & exit /b
