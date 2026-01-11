param([string]$Mode="--plan")

$Root = git rev-parse --show-toplevel
$Prompts = Join-Path $Root "prompts"

switch ($Mode) {
  "--plan" { $Sys = Join-Path $Prompts "PLANNER_AGENT.md" }
  "--impl" { $Sys = Join-Path $Prompts "IMPLEMENTER_MINIMAL_DIFF.md" }
  "--review" { $Sys = Join-Path $Prompts "REVIEWER_STRICT.md" }
  default { Write-Host "Usage: scripts/ask.ps1 [--plan|--impl|--review]"; exit 1 }
}

$Changed = git diff --name-only --diff-filter=ACMRTUXB origin/main...HEAD | Select-String -Pattern '^(src|tests)/'
if (-not $Changed) { $Changed = git diff --name-only HEAD~1 | Select-String -Pattern '^(src|tests)/' }

$Files = @("src","tests")
$Files += $Changed | ForEach-Object { $_.ToString() }

$System = Get-Content $Sys -Raw
$InputText = [Console]::In.ReadToEnd()

claude --system $System --input $InputText $(foreach ($f in $Files) { "-a"; $f })