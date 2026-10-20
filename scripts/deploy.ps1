[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$ApplyConfigs,
    [switch]$AllowRunningServer
)

$ErrorActionPreference = 'Stop'
$ServerRoot = Split-Path -Parent $PSScriptRoot
$ServerRootPattern = [regex]::Escape($ServerRoot)
$RunningServer = Get-CimInstance Win32_Process -Filter "Name='java.exe'" |
    Where-Object { $_.CommandLine -match $ServerRootPattern }

if ($RunningServer -and -not $AllowRunningServer) {
    throw "The server is running (PID $($RunningServer.ProcessId)). Stop it in MC Server Manager, then rerun this script."
}

$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$BackupRoot = Join-Path $ServerRoot "backups\configuration-$Stamp"
$SourcePack = Join-Path $ServerRoot 'datapacks\amaderrp_npcs'
$TargetPack = Join-Path $ServerRoot 'world\datapacks\amaderrp_npcs'

if (-not (Test-Path -LiteralPath $SourcePack)) {
    throw "NPC datapack source is missing: $SourcePack"
}

if (Test-Path -LiteralPath $TargetPack) {
    New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null
    Copy-Item -LiteralPath $TargetPack -Destination (Join-Path $BackupRoot 'amaderrp_npcs') -Recurse
}

New-Item -ItemType Directory -Path (Split-Path -Parent $TargetPack) -Force | Out-Null
if ($PSCmdlet.ShouldProcess($TargetPack, 'Deploy cross-play NPC datapack')) {
    Copy-Item -LiteralPath $SourcePack -Destination $TargetPack -Recurse -Force
}

if ($ApplyConfigs) {
    New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

    $ConfigMap = @(
        @{ Template = 'config-templates\Geyser-Fabric\config.yml'; Target = 'config\Geyser-Fabric\config.yml' },
        @{ Template = 'config-templates\floodgate\config.yml'; Target = 'config\floodgate\config.yml' }
    )

    foreach ($Item in $ConfigMap) {
        $TemplatePath = Join-Path $ServerRoot $Item.Template
        $TargetPath = Join-Path $ServerRoot $Item.Target
        if (Test-Path -LiteralPath $TargetPath) {
            $BackupName = ($Item.Target -replace '[\\/]', '_')
            Copy-Item -LiteralPath $TargetPath -Destination (Join-Path $BackupRoot $BackupName)
        }
        New-Item -ItemType Directory -Path (Split-Path -Parent $TargetPath) -Force | Out-Null
        if ($PSCmdlet.ShouldProcess($TargetPath, 'Apply reviewed configuration template')) {
            Copy-Item -LiteralPath $TemplatePath -Destination $TargetPath -Force
        }
    }

    $PropertiesPath = Join-Path $ServerRoot 'server.properties'
    $TemplateProperties = Get-Content -Raw -LiteralPath (Join-Path $ServerRoot 'config-templates\server.properties')
    $ExistingSecret = ''
    if (Test-Path -LiteralPath $PropertiesPath) {
        Copy-Item -LiteralPath $PropertiesPath -Destination (Join-Path $BackupRoot 'server.properties')
        $SecretLine = Get-Content -LiteralPath $PropertiesPath |
            Where-Object { $_ -like 'management-server-secret=*' } |
            Select-Object -First 1
        if ($SecretLine) { $ExistingSecret = $SecretLine.Substring('management-server-secret='.Length) }
    }
    $TemplateProperties = $TemplateProperties -replace '(?m)^management-server-secret=.*$', "management-server-secret=$ExistingSecret"
    if ($PSCmdlet.ShouldProcess($PropertiesPath, 'Apply server.properties while preserving the local management secret')) {
        Set-Content -LiteralPath $PropertiesPath -Value $TemplateProperties -Encoding utf8NoBOM
    }
}

Write-Host "Deployment staged. Start the server and run: function amaderrp_npcs:admin/summon_elder"
Write-Host "Backups, when required, are under: $BackupRoot"

