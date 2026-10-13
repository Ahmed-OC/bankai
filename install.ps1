# bankai installer (Windows) — copies the canon (master + children) next to your agent's other skills.
# Two ways to run it:
#   1) from a clone:   powershell -File install.ps1 [-Target <dir>]
#   2) one-liner (no git, no node):
#      powershell -Command "irm https://raw.githubusercontent.com/Ahmed-OC/bankai/main/install.ps1 | iex"
#      (optional: set $env:BANKAI_TARGET first to choose the destination)
param(
  [string]$Target = ""
)
$ErrorActionPreference = "Stop"
$Repo = "Ahmed-OC/bankai"
$Branch = "main"

# Resolve repo root: local clone if available, otherwise download the zip
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "bankai/SKILL.md"))) {
  $Root = $PSScriptRoot
} else {
  Write-Host "Downloading bankai..."
  $tmp = New-Item -ItemType Directory -Force -Path (Join-Path $env:TEMP "bankai-install-$(Get-Random)")
  $zip = Join-Path $tmp "bankai.zip"
  Invoke-WebRequest -Uri "https://github.com/$Repo/archive/refs/heads/$Branch.zip" -OutFile $zip -UseBasicParsing
  Expand-Archive -Path $zip -DestinationPath $tmp -Force
  $Root = Join-Path $tmp "bankai-$Branch"
}

if (-not $Target) { $Target = $env:BANKAI_TARGET }
if (-not $Target) {
  $candidates = @(
    ".agents/skills", ".claude/skills", ".codex/skills", ".cursor/skills",
    "$env:USERPROFILE/.agents/skills", "$env:USERPROFILE/.claude/skills",
    "$env:USERPROFILE/.codex/skills", "$env:USERPROFILE/.cursor/skills"
  )
  foreach ($c in $candidates) {
    if (Test-Path $c) { $Target = $c; break }
  }
  if (-not $Target) {
    Write-Host "No skills directory found (.agents/skills, .claude/skills, ...)."
    Write-Host "Create one (mkdir .agents/skills), set `$env:BANKAI_TARGET, or use the -Target parameter."
    exit 1
  }
}

New-Item -ItemType Directory -Force -Path $Target | Out-Null
$count = 0
function Install-One([string]$srcDir) {
  $dest = Join-Path $Script:Target (Split-Path $srcDir -Leaf)
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item -Recurse $srcDir $dest
  $Script:count++
}
Install-One (Join-Path $Root "bankai")   # the entry point + its 106 sub-skills (children travel inside)
Write-Host "Installed $count skills into: $Target"
Write-Host "Start with: bankai (it routes to the children automatically)."
