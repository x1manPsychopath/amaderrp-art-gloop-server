#!/usr/bin/env sh
set -eu

cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

# Minecraft Java Edition 26.2 declares Java 25 in server.jar/version.json.
# Override JAVA_BIN or SERVER_RAM_GB in the environment when needed.
JAVA_BIN="${JAVA_BIN:-java}"
SERVER_RAM_GB="${SERVER_RAM_GB:-8}"

"$JAVA_BIN" -version

exec "$JAVA_BIN" \
  -Xms1G "-Xmx${SERVER_RAM_GB}G" \
  -Dfile.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 \
  --enable-native-access=ALL-UNNAMED \
  -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC \
  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 \
  -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 \
  -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 \
  -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 \
  -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
  -jar fabric-server-launch.jar nogui

