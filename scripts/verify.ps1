[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ServerRoot = Split-Path -Parent $PSScriptRoot
$Failures = [System.Collections.Generic.List[string]]::new()

function Assert-Condition {
    param([bool]$Condition, [string]$Message)
    if ($Condition) { Write-Host "PASS: $Message" -ForegroundColor Green }
    else { Write-Host "FAIL: $Message" -ForegroundColor Red; $Failures.Add($Message) }
}

$JavaText = (& java -version 2>&1 | Out-String)
Assert-Condition ($JavaText -match 'version "25[\.]') 'Java 25 is active for Minecraft 26.2'
Assert-Condition (Test-Path -LiteralPath (Join-Path $ServerRoot 'fabric-server-launch.jar')) 'Fabric launcher exists'
Assert-Condition ((Get-ChildItem -LiteralPath (Join-Path $ServerRoot 'mods') -Filter 'Geyser-Fabric-*.jar').Count -eq 1) 'Exactly one Geyser Fabric jar is installed'
Assert-Condition ((Get-ChildItem -LiteralPath (Join-Path $ServerRoot 'mods') -Filter 'Floodgate-Fabric-*.jar').Count -eq 1) 'Exactly one Floodgate Fabric jar is installed'

$GeyserConfig = Get-Content -Raw -LiteralPath (Join-Path $ServerRoot 'config\Geyser-Fabric\config.yml')
Assert-Condition ($GeyserConfig -match '(?m)^\s*auth-type:\s*floodgate\s*$') 'Geyser uses Floodgate authentication'
Assert-Condition ($GeyserConfig -match '(?m)^\s*validate-bedrock-login:\s*true\s*$') 'Bedrock Xbox identity validation remains enabled'
Assert-Condition ($GeyserConfig -match '(?m)^\s*port:\s*19132\s*$') 'Bedrock listener is configured on port 19132'

$PackRoot = Join-Path $ServerRoot 'datapacks\amaderrp_npcs'
Assert-Condition (Test-Path -LiteralPath (Join-Path $PackRoot 'pack.mcmeta')) 'NPC datapack metadata exists'
Assert-Condition (Test-Path -LiteralPath (Join-Path $PackRoot 'data\amaderrp_npcs\function\tick.mcfunction')) 'NPC proximity function exists'
Assert-Condition (Test-Path -LiteralPath (Join-Path $PackRoot 'data\amaderrp_npcs\advancement\talk_to_elder.json')) 'NPC interaction advancement exists'

$Tracked = git -C $ServerRoot ls-files 2>$null
$Forbidden = $Tracked | Where-Object { $_ -match '(^|/)(world|logs|backups|libraries|versions)/|key\.pem$|\.jar$|^(ops|whitelist|banned-|usercache)' }
Assert-Condition (-not $Forbidden) 'Git contains no world data, player data, keys, logs, libraries, or jars'

if ($Failures.Count -gt 0) {
    throw "$($Failures.Count) verification check(s) failed."
}

Write-Host 'All static server-kit checks passed.' -ForegroundColor Cyan

