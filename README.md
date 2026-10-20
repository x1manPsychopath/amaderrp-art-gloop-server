# AmaDerrp Art Gloop server kit

This repository is the reviewable configuration and automation layer for the live Minecraft 26.2 Fabric server. It preserves the existing world and modded Fabric architecture while supporting unmodified Java and Bedrock players through Geyser-Fabric and Floodgate-Fabric.

## Delivered

- Java 25 startup scripts with the currently proven G1 tuning profile
- safe server, Geyser-Fabric, and Floodgate configuration templates
- a clientless cross-play community NPC data pack
- guarded deployment, static verification, rollback, and GitHub publication scripts
- a deny-by-default Git policy that excludes the world, player data, logs, private Floodgate key, generated configs, and binary JARs

## Quick verification

```powershell
.\scripts\verify.ps1
```

Read `docs/DEPLOYMENT.md` before applying config templates or restarting the server.

## NPC behavior

`Elder Gloop` greets a player inside an eight-block radius, emits a vanilla positional sound, and cycles through three dialogue lines when right-clicked. The behavior is entirely server-side and therefore remains available to Bedrock players through Geyser.

