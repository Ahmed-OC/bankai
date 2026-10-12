# ui-ux-canon installer (Windows) — copies the canon next to your agent's other skills.
# Usage: powershell -File install.ps1 [-Target <dir>]
param(
  [string]$Target = ""
)
$ErrorActionPreference = "Stop"
$Src = Join-Path $PSScriptRoot "skills"

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
    Write-Host "Create one (mkdir .agents/skills) or pass a target: powershell -File install.ps1 -Target <dir>"
    exit 1
  }
}

New-Item -ItemType Directory -Force -Path $Target | Out-Null
$count = 0
Get-ChildItem -Directory $Src | ForEach-Object {
  $dest = Join-Path $Target $_.Name
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item -Recurse $_.FullName $dest
  $count++
}
$conventions = Join-Path $Src "_CONVENTIONS.md"
if (Test-Path $conventions) { Copy-Item $conventions $Target -Force }
Write-Host "Installed $count skills into: $Target"
Write-Host "Start with: desengs-ui-ux-master (it routes to the children automatically)."
