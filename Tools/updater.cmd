@echo off
IF "%MODPACK%"=="" (
    echo [!] You cannot run this file manually.
    echo     Please run one of the update_*.cmd scripts instead.
    echo.
    echo [i] Press any key to exit.
    pause>nul
    GOTO :END
)

IF NOT EXIST "date.exe" (
    echo [!] Error - 'date.exe' not found! Please get it from UnxUtils:
    echo     https://sourceforge.net/projects/unxutils/files/unxutils/current/
    echo.
    echo [i] Press any key to exit.
    pause>nul
    GOTO :END
)
for /f "tokens=1,2,3,4,5,6* delims=," %%i in ('%~dp0\date.exe +"%%Y,%%m,%%d,%%H,%%M,%%S"') do set yy=%%i& set mo=%%j& set dd=%%k& set hh=%%l& set mm=%%m& set ss=%%n
SET VERSION=%yy%.%mo%.%dd%-%hh%.%mm%.%ss%

IF NOT EXIST "%~dp0\..\modpacks\%MODPACK%\distrib" (
    echo [!] The folder '..\modpacks\%MODPACK%\distrib' was not found. Bad MODPACK variable?
    echo.
    echo [i] Press any key to exit.
    pause>nul
    GOTO :END
)

echo This script will build the modpack from modpacks\%MODPACK%\src folder to it's distrib folder, 
echo ready for you to upload to the server. Make sure that all files in the src folder are tested
echo and desirable for distribution.
echo.
echo Note that the old objects (previous modpack version) will be deleted - this is to save
echo space on the server.
echo.
echo First step is to pull any remote updates. If there are no errors/conflicts, you can then
echo continue with (re)building the modpack.
echo.
echo [?] Press any key to begin.
pause > nul
echo.
echo [#] Pulling...
git pull
echo.
echo [?] If all is well, press any key to regenerate the modpack.
pause > nul
echo.
echo [#] Deleting old objects...
del /Q "%~dp0\..\modpacks\%MODPACK%\distrib\%MODPACK%.json" >nul 2>&1
rmdir /Q /S "%~dp0\..\modpacks\%MODPACK%\distrib\objects" >nul 2>&1
echo [#] Building new modpack...
java -jar "%~dp0\launcher-builder-1.0.0-all.jar" --version "%VERSION%" --input "%~dp0\..\modpacks\%MODPACK%" --output "%~dp0\..\modpacks\%MODPACK%\distrib" --manifest-dest "%~dp0\..\modpacks\%MODPACK%\distrib\%MODPACK%.json"

echo.
echo.
echo [?] Done! Now you can commit and push all changes in this repo to update the Hostile Launcher.
echo.
echo [!] Don't forget to update the server via PuTTY too!
echo.
echo.
echo [i] Press any key to close.
pause>nul

:END
ENDLOCAL