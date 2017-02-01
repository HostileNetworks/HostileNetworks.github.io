@echo off
SETLOCAL
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
SET MODPACK=Reign



echo This script will build the %MODPACK% modpack from the src folder, ready for you to upload
echo to the server. Make sure that the %MODPACK%\src\ repo contains the modpack you wish to
echo distribute.
echo.
echo Note that the old objects (previous modpack version) will be deleted - this is to save
echo space on the server.
echo.
echo First step is to pull any remote updates. If there are no errors/conflicts, you can then
echo continue with rebuilding the modpack.
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
del /Q "%~dp0\%MODPACK%\distrib\%MODPACK%.json" >nul 2>&1
rmdir /Q /S "%~dp0\%MODPACK%\distrib\objects" >nul 2>&1
echo [#] Building new modpack...
java -jar "%~dp0\launcher-builder-1.0.0-all.jar" --version "%VERSION%" --input "%~dp0\%MODPACK%" --output "%~dp0\%MODPACK%\distrib" --manifest-dest "%~dp0\%MODPACK%\distrib\%MODPACK%.json"

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