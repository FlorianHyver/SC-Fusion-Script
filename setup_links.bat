@echo off
setlocal

:: Define directories to link
set DIRS=LIVE EPTU PTU TECH-PREVIEW

:: Change to the directory where the script is located
cd /d %~dp0

:: Ensure _Backup directory and its subdirectories exist
if not exist "_Backup\Screenshots" mkdir "_Backup\Screenshots"
if not exist "_Backup\Mappings" mkdir "_Backup\Mappings"
if not exist "_Backup\CustomCharacters" mkdir "_Backup\CustomCharacters"

:: Iterate over each directory
for %%d in (%DIRS%) do (
    echo %%d
    :: Check if directory exists, if not create it
    if not exist "%%d" mkdir "%%d"

    :: Change to the target directory
    cd "%%d"

    :: Check and handle Screenshots directory
    if exist "Screenshots" (
        dir | find /i "<SYMLINKD>" | find /i "Screenshots" >nul
        if errorlevel 1 (
            REM The folder is not a symbolic link.
            echo Moving contents of Screenshots from %%d to _Backup\Screenshots...
            xcopy "Screenshots\*" "..\_Backup\Screenshots\" /S /I /Y
            rd /s /q "Screenshots"
            echo Creating symbolic link in %%d pointing to ..\_Backup\Screenshots...
            mklink /D "screenshots" "..\_Backup\Screenshots"
        ) else (
            REM The folder is a symbolic link. Do nothing
        )
    ) else (
        echo Creating symbolic link in %%d pointing to ..\_Backup\Screenshots...
        mklink /D "screenshots" "..\_Backup\Screenshots"
    )
    
    :: Check and handle Mappings directory
    if exist "user\client\0\Controls\Mappings" (
        dir "user\client\0\Controls" | find /i "<SYMLINKD>" | find /i "Mappings" >nul
        if errorlevel 1 (
            REM The folder is not a symbolic link.
            echo Moving contents of Mappings from %%d to _Backup\Mappings...
            xcopy "user\client\0\Controls\Mappings\*" "..\_Backup\Mappings\" /S /I /Y
            rd /s /q "user\client\0\Controls\Mappings"
            echo Creating symbolic link in %%d pointing to ..\_Backup\Mappings...
            mklink /D "user\client\0\Controls\Mappings" "..\..\..\..\..\_Backup\Mappings"
        ) else (
            REM The folder is a symbolic link. Do nothing
        )
    ) else (
        echo Creating directory structure for Mappings in %%d...
        mkdir "user\client\0\Controls"
        echo Creating symbolic link in %%d pointing to ..\_Backup\Mappings...
        mklink /D "user\client\0\Controls\Mappings" "..\..\..\..\..\_Backup\Mappings"
    )
    
    :: Check and handle Custom Characters directory
    if exist "user\client\0\CustomCharacters" (
        dir "user\client\0" | find /i "<SYMLINKD>" | find /i "CustomCharacters" >nul
        if errorlevel 1 (
            REM The folder is not a symbolic link.
            echo Moving contents of CustomCharacters from %%d to _Backup\CustomCharacters...
            xcopy "user\client\0\CustomCharacters\*" "..\_Backup\CustomCharacters\" /S /I /Y
            rd /s /q "user\client\0\CustomCharacters"
            echo Creating symbolic link in %%d pointing to ..\_Backup\CustomCharacters...
            mklink /D "user\client\0\CustomCharacters" "..\..\..\..\_Backup\CustomCharacters"
        ) else (
            REM The folder is a symbolic link. Do nothing
        )
    ) else (
        echo Creating directory structure for CustomCharacters in %%d...
        mkdir "user\client\0"
        echo Creating symbolic link in %%d pointing to ..\_Backup\CustomCharacters...
        mklink /D "user\client\0\CustomCharacters" "..\..\..\..\_Backup\CustomCharacters"
    )

    :: Go back to the _Backup directory
    cd ".."
)

echo All symbolic links have been created successfully.
pause
