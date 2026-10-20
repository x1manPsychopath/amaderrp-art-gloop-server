# Deployment and operations

## Runtime truth

- Game: Minecraft Java Edition 26.2
- Required Java: 25 (declared by `server.jar/version.json`)
- Loader: Fabric 0.19.5
- Java listener: TCP 25565
- Bedrock listener: TCP/UDP 19132 using Geyser-Fabric
- Bedrock identity: Floodgate; Xbox/Microsoft identity validation remains enabled

There is no Java runtime named “Java 26.2.” Java 26 is a JDK release; Minecraft 26.2 explicitly declares Java 25.

## Safe deployment

1. In MC Server Manager, announce maintenance and stop `AmaDerrp Art Gloop` cleanly.
2. Confirm no Java process command line points at this server folder.
3. From PowerShell in the server root, preview changes:

   ```powershell
   .\scripts\deploy.ps1 -WhatIf -ApplyConfigs
   ```

4. Deploy the NPC pack and reviewed configs:

   ```powershell
   .\scripts\deploy.ps1 -ApplyConfigs
   ```

5. Start the server in MC Server Manager. Confirm the log reaches `Done` and shows Geyser listening on 19132.
6. In the manager console, place the NPC at the executing entity or use an in-game operator at the desired location:

   ```text
   function amaderrp_npcs:admin/summon_elder
   ```

7. Test an unmodified Java client and a Bedrock/Floodgate client. Approach within eight blocks, then right-click the NPC three times.

## Rollback

Stop the server, remove only `world/datapacks/amaderrp_npcs`, and restore the latest files from `backups/configuration-<timestamp>` if configs were applied. Restart and confirm normal Java and Bedrock joins.

## Audio boundary

The delivered NPC uses vanilla spatial sound events, which Geyser maps for Bedrock. OpenAudioMc is not installed because it does not support Fabric. Browser-based voice/TTS remains a separate integration requiring a compatible Fabric bridge and live device testing.

