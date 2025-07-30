@echo off
setlocal

:: Change to the directory where the script is located
cd /d %~dp0

:: Define directories to link
set DIRS=LIVE EPTU PTU TECH-PREVIEW

:: Ensure _Backup directory and its subdirectories exist
if not exist "_Backup\Screenshots" mkdir "_Backup\Screenshots"
if not exist "_Backup\Mappings" mkdir "_Backup\Mappings"

:: Iterate over each directory
for %%d in (%DIRS%) do (
    :: Check if directory exists, if not create it
    if not exist "%%d" mkdir "%%d"

    :: Change to the target directory
    cd "%%d"

    :: Check and handle Screenshots directory
    if exist "Screenshots" (
        echo Moving contents of Screenshots from %%d to _Backup\Screenshots...
        xcopy "Screenshots\*" "..\_Backup\Screenshots\" /S /I /Y
        rd /s /q "Screenshots"
    )
    echo Creating symbolic link in %%d pointing to ..\_Backup\Screenshots...
    mklink /D "screenshots" "..\_Backup\Screenshots"

    :: Check and handle Mappings directory
    if exist "user\client\0\Controls\Mappings" (
        echo Moving contents of Mappings from %%d to _Backup\Mappings...
        xcopy "user\client\0\Controls\Mappings\*" "..\_Backup\Mappings\" /S /I /Y
        rd /s /q "user\client\0\Controls\Mappings"
    ) else (
        echo Creating directory structure for Mappings in %%d...
        mkdir "user\client\0\Controls"
    )
    echo Creating symbolic link in %%d pointing to ..\_Backup\Mappings...
    mklink /D "user\client\0\Controls\Mappings" "..\..\..\..\..\_Backup\Mappings"

    :: Go back to the _Backup directory
    cd ".."
)

echo All symbolic links have been created successfully.
pause
