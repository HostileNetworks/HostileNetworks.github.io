@echo off
cd /d "%~dp0\.."
echo [#] Updating root...
git pull
echo.
echo [#] Updating submodules...
git submodule update --init --recursive
cd modpacks\Reign\src
git checkout master
git pull
echo.
echo Done. Press any key to close.
pause > nul

