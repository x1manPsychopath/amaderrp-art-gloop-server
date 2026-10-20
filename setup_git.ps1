[CmdletBinding()]
param(
    [string]$RepositoryName = 'amaderrp-art-gloop-server',
    [ValidateSet('public', 'private')]
    [string]$Visibility = 'public'
)

$ErrorActionPreference = 'Stop'
$ServerRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $ServerRoot

git init
git add .

$Forbidden = git diff --cached --name-only | Where-Object {
    $_ -match '(^|/)(world|logs|backups|libraries|versions)/|key\.pem$|\.jar$|^(ops|whitelist|banned-|usercache)'
}
if ($Forbidden) {
    throw "Refusing to commit sensitive/runtime files: $($Forbidden -join ', ')"
}

git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m 'Initial commit: Minecraft 26.2 Geyser NPC server setup'
}

gh auth status
if (-not (git remote get-url origin 2>$null)) {
    gh repo create $RepositoryName "--$Visibility" --source=. --remote=origin --push
} else {
    git push -u origin HEAD
}

