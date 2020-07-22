@echo off

rem  Inno Setup
rem  Copyright (C) 1997-2019 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Batch file to "compile" the files needed by QSP

setlocal

if exist compilesettings.bat goto compilesettingsfound
:compilesettingserror
echo compilesettings.bat is missing or incomplete. It needs to be created
echo with the following lines, adjusted for your system:
echo.
echo   set ISSRCROOT=c:\issrc         [Path to Inno Setup source code]
goto failed2

:compilesettingsfound
set ISSRCROOT=
call .\compilesettings.bat
if "%ISSRCROOT%"=="" goto compilesettingserror

echo - Copying license.txt and isdonateandmail.iss
copy %ISSRCROOT%\license.txt .
if errorlevel 1 goto failed
copy %ISSRCROOT%\isdonateandmail.iss .
if errorlevel 1 goto failed
copy %ISSRCROOT%\isdonate.bmp .
if errorlevel 1 goto failed
copy %ISSRCROOT%\ismail.bmp .
if errorlevel 1 goto failed

if "%VER%"=="" (
echo - Running mysetup.exe
%ISSRCROOT%\Output\mysetup.exe /silent /currentuser /portable=1 /dir=isfiles
) else (
echo - Running innosetup-%VER%.exe
%ISSRCROOT%\Output\innosetup-%VER%.exe /silent /currentuser /portable=1 /dir=isfiles 
)
if errorlevel 1 goto failed

echo Success!
cd ..
goto exit

:failed
echo *** FAILED ***
cd ..
:failed2
exit /b 1

:exit
