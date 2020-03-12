@echo off

rem  Inno Setup
rem  Copyright (C) 1997-2020 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Batch file to prepare an QuickStart Pack release
rem
rem  Run Inno Setup's build.bat before using
rem
rem  Calls setup-sign.bat if it exists, else creates setup.exe without signing
rem
rem  This batch files does the following things:
rem  -Compiling files: copy some base files to root and install IS into isfiles
rem  -Create Inno Setup QuickStart Pack installer
rem
rem  Once done the installer can be found in Output

setlocal

set VER=6.0.4

echo Building Inno Setup QuickStart Pack %VER%...
echo.

cd /d %~dp0

call .\compile.bat
if errorlevel 1 goto failed
echo Compiling files done
pause

echo - Setup.exe
if exist .\setup-sign.bat (
  call .\setup-sign.bat
) else (
  isfiles\iscc setup.iss
)
if errorlevel 1 goto failed
echo - Renaming files
cd output
if errorlevel 1 goto failed
move /y mysetup.exe innosetup-qsp-%VER%.exe
cd ..
if errorlevel 1 goto failed
echo Creating Inno Setup QuickStart Pack installer done

echo All done!
pause

goto exit

:failed
echo *** FAILED ***
cd ..
:failed2
exit /b 1

:exit
