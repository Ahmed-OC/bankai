# bankai installer (Windows) — copies the canon next to your agent's other skills.
# Two ways to run it:
#   1) from a clone:   powershell -File install.ps1 [-Target <dir>]
#   2) one-liner (no git, no node):
#      powershell -Command "irm https://raw.githubusercontent.com/Ahmed-OC/bankai/main/install.ps1 | iex"  [-Target as env var BANKAI_TARGET]
param(
  [string]$Target = ""
)
$ErrorActionPreference = "Stop"
$Repo = "Ahmed-OC/bankai"
$Branch = "main"

# Resolve skills source: local clone if available, otherwise download the zip
$localSkills = if ($PSScriptRoot) { Join-Path $PSScriptRoot "skills" } else { "" }
if ($localSkills -and (Test-Path (Join-Path $localSkills "bankai/SKILL.md"))) {
  $Src = $localSkills
} else {
  Write-Host "Downloading bankai..."
  $tmp = New-Item -ItemType Directory -Force -Path (Join-Path $env:TEMP "bankai-install-$(Get-Random)")
  $zip = Join-Path $tmp "bankai.zip"
  Invoke-WebRequest -Uri "https://github.com/$Repo/archive/refs/heads/$Branch.zip" -OutFile $zip -UseBasicParsing
  Expand-Archive -Path $zip -DestinationPath $tmp -Force
  $Src = Join-Path $tmp "bankai-$Branch/skills"
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
Get-ChildItem -Directory $Src | ForEach-Object {
  $dest = Join-Path $Target $_.Name
  if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
  Copy-Item -Recurse $_.FullName $dest
  $count++
}
$conventions = Join-Path $Src "_CONVENTIONS.md"
if (Test-Path $conventions) { Copy-Item $conventions $Target -Force }
Write-Host "Installed $count skills into: $Target"
Write-Host "Start with: bankai (it routes to the children automatically)."
