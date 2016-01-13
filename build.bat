@echo off

rem  Inno Setup
rem  Copyright (C) 1997-2013 Jordan Russell
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
rem  -Install ANSI IS into isfiles
rem  -Install Unicode IS into isfiles-unicode
rem  -Create ANSI Inno Setup QuickStart Pack installer
rem  -Create Unicode Inno Setup QuickStart Pack installer
rem
rem  Once done the 2 installers can be found in Output

setlocal

set VER=5.5.7

echo Building Inno Setup QuickStart Pack %VER%...
echo.

cd /d %~dp0

if exist buildsettings.bat goto buildsettingsfound
:buildsettingserror
echo buildsettings.bat is missing or incomplete. It needs to be created
echo with the following lines, adjusted for your system:
echo.
echo   set ISSRCROOT=c:\issrc         [Path to Inno Setup source code]
goto failed2

:buildsettingsfound
set ISSRCROOT=
call .\buildsettings.bat
if "%ISSRCROOT%"=="" goto buildsettingserror

echo - Running isetup-%VER%.exe
%ISSRCROOT%\Output\isetup-%VER%.exe /silent /ispp=1 /portable=1 /dir=isfiles 
if errorlevel 1 goto failed
echo - Setup.exe
if exist .\setup-sign.bat (
  call .\setup-sign.bat isfiles
) else (
  isfiles\iscc setup.iss /qp /DNOSIGNTOOL
)
if errorlevel 1 goto failed
echo - Renaming files
cd output
if errorlevel 1 goto failed
move /y setup.exe ispack-%VER%.exe
cd ..
if errorlevel 1 goto failed
echo ANSI setup done
pause

echo - Running isetup-%VER%-unicode.exe
%ISSRCROOT%\Output\isetup-%VER%-unicode.exe /silent /ispp=1 /portable=1 /dir=isfiles-unicode
if errorlevel 1 goto failed
echo - Setup.exe
if exist .\setup-sign.bat (
  call .\setup-sign.bat isfiles-unicode
) else (
  isfiles-unicode\iscc setup.iss /qp /DNOSIGNTOOL
)
if errorlevel 1 goto failed
echo - Renaming files
cd output
if errorlevel 1 goto failed
move /y setup.exe ispack-%VER%-unicode.exe
cd ..
if errorlevel 1 goto failed
echo Unicode setup done
pause

echo All done!
pause

goto exit

:failed
echo *** FAILED ***
cd ..
:failed2
exit /b 1

:exit
