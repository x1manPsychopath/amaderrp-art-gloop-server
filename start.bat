@echo off
setlocal EnableExtensions
cd /d "%~dp0"

rem Minecraft Java Edition 26.2 declares Java 25 in server.jar/version.json.
rem Override JAVA_EXE or SERVER_RAM_GB before launch when needed.
if not defined JAVA_EXE set "JAVA_EXE=java"
if not defined SERVER_RAM_GB set "SERVER_RAM_GB=8"

"%JAVA_EXE%" -version
if errorlevel 1 (
  echo ERROR: Java was not found. Install a 64-bit Java 25 runtime or set JAVA_EXE.
  exit /b 1
)

"%JAVA_EXE%" ^
  -Xms1G -Xmx%SERVER_RAM_GB%G ^
  -Dfile.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 ^
  --enable-native-access=ALL-UNNAMED ^
  -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 ^
  -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC ^
  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 ^
  -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 ^
  -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 ^
  -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 ^
  -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 ^
  -jar fabric-server-launch.jar nogui

set "SERVER_EXIT=%ERRORLEVEL%"
echo Server exited with code %SERVER_EXIT%.
exit /b %SERVER_EXIT%

