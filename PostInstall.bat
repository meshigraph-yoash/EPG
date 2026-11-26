@echo off
setlocal

REM Accept BASE folder as first argument
set "BASE=%~1"

REM Optional: fallback if no argument is passed
if "%BASE%"=="" (
    set "BASE=%LOCALAPPDATA%\WebGrab+Plus"
)

REM echo Using BASE folder: %BASE%
set "TEMP=%BASE%\.temp"
set "TYPEFILE=%TEMP%\versiontype.txt"

if not exist "%TYPEFILE%" (
    echo versiontype.txt not found!
    exit /b 1
)

set /p TYPE=<"%TYPEFILE%"
set TYPE=%TYPE:~0,10%
set TYPE=%TYPE: =%
set TYPE=%TYPE:"=%

echo Detected install type: %TYPE%

if /i "%TYPE%"=="normal" (
    call :copyconfigs
) else if /i "%TYPE%"=="beta" (
    call :copyconfigs
) else if /i "%TYPE%"=="eval" (
    if not exist "%BASE%\WebGrab++.config.xml" (
        echo Warning: eval needs a prior normal or beta installation!
    )
    echo No install actions required for install type: %TYPE%
) else (
    echo Unknown or missing install type: %TYPE%. No install actions performed.
)
goto :eof

:copyconfigs
if not exist "%BASE%\mdb\mdb.config.xml" if exist "%TEMP%\mdb.config.xml" (
    mkdir "%BASE%\mdb" 2>nul
    copy "%TEMP%\mdb.config.xml" "%BASE%\mdb\mdb.config.xml"
)
if not exist "%BASE%\rex\rex.config.xml" if exist "%TEMP%\rex.config.xml" (
    mkdir "%BASE%\rex" 2>nul
    copy "%TEMP%\rex.config.xml" "%BASE%\rex\rex.config.xml"
)
if not exist "%BASE%\WebGrab++.config.xml" if exist "%TEMP%\WebGrab++.config.xml" (
    copy "%TEMP%\WebGrab++.config.xml" "%BASE%\WebGrab++.config.xml"
)

REM echo ==> DONE

:: CLEANUP SECTION
echo Starting cleanup...

:: Remove .temp folder if it exists
if exist "%TEMP%" (
    echo Removing temp folder...
    rmdir /s /q "%TEMP%"
)

:: Remove .empty files in subfolders
for %%D in (mdb rex siteini.user) do (
    if exist "%BASE%\%%D\.empty" (
        echo Removing .empty from %%D...
        del /q "%BASE%\%%D\.empty"
    )
)

echo Cleanup complete.

goto :eof
