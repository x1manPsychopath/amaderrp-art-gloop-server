# ADR-001: Preserve Fabric and use a server-side NPC datapack

Status: Accepted on 2026-10-20.

## Context

The production server is Minecraft 26.2 on Fabric Loader 0.19.5. Citizens2, Denizen, Sentinel, Geyser-Spigot, Floodgate-Spigot, and OpenAudioMc are Bukkit-family plugins and cannot be loaded by Fabric. Replacing Fabric with Paper would also remove or require replacements for the existing Fabric mod set and would put the current world at unnecessary migration risk.

## Decision

Keep Fabric, Geyser-Fabric, and Floodgate-Fabric. Implement community NPC behavior as a server-side data pack using a tagged invulnerable villager, proximity checks, a right-click advancement trigger, `tellraw`, and vanilla `playsound` events.

This design is clientless. Java and Bedrock players receive the same dialogue and mapped vanilla audio through Geyser. It does not claim synthesized speech or browser voice chat.

## Consequences

- Bedrock and unmodified Java clients remain supported.
- No third-party account, API key, client mod, or recurring audio service is required.
- Dialogue is deterministic and version-controlled.
- Voice acting or TTS would need a separately tested Fabric integration or a deliberately planned Paper migration.

## Rejected alternatives

- Citizens2/Denizen/Sentinel: incompatible with the active Fabric loader.
- OpenAudioMc: officially supports Spigot, Paper, BungeeCord, and Velocity, not Fabric.
- Client-required NPC mods: Bedrock clients cannot install Fabric client mods.
- Disabling Bedrock login validation: permits identity spoofing and disables Floodgate identity/skin behavior.

