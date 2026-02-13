@echo off
setlocal

REM ================================
REM 1. SET INSTALL PATHS
REM ================================
set "APPDIR=%LOCALAPPDATA%\Guessing game"
set "JAVADIR=C:\Program Files\Games\java"

mkdir "%APPDIR%" 2>nul
mkdir "%JAVADIR%" 2>nul

REM ================================
REM 2. DOWNLOAD JAVA 21 ZIP
REM ================================
echo Downloading Java 21 ZIP...
powershell -Command "Invoke-WebRequest 'https://aka.ms/download-jdk/microsoft-jdk-21-windows-x64.zip' -OutFile '%APPDIR%\java.zip'"

REM ================================
REM 3. EXTRACT JAVA TO YOUR CUSTOM PATH
REM ================================
echo Extracting Java...
powershell -Command "Expand-Archive -Path '%APPDIR%\java.zip' -DestinationPath '%JAVADIR%' -Force"

REM Detect the extracted JDK folder (jdk-21.x.x)
for /d %%i in ("%JAVADIR%\jdk-*") do set "REALJAVA=%%i"

REM ================================
REM 4. DOWNLOAD YOUR JAR FILE
REM ================================
echo Downloading Guessing Game JAR...
powershell -Command "Invoke-WebRequest 'https://github.com/HTMLCSSJSPY/Guessing-game/raw/refs/heads/main/Math.jar' -OutFile '%APPDIR%\Math.jar'"

REM ================================
REM 5. CREATE LAUNCHER .BAT FILE
REM ================================
set "LAUNCHER=%APPDIR%\run-guessing-game.bat"

echo @echo off > "%LAUNCHER%"
echo "%REALJAVA%\bin\java.exe" -jar "%APPDIR%\Math.jar" >> "%LAUNCHER%"
echo pause >> "%LAUNCHER%"

echo Created launcher at %LAUNCHER%

REM ================================
REM 6. ADD SHORTCUT TO WINDOWS SEARCH
REM ================================
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"

powershell -Command ^
 "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%STARTMENU%\Guessing Game.lnk');" ^
 " $s.TargetPath='%LAUNCHER%';" ^
 " $s.Save()"

echo Added Start Menu shortcut.

REM ================================
REM DONE
REM ================================
echo Installation complete.
pause
