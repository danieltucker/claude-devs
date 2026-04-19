# install.ps1 — installs or syncs claude-devs to ~/.claude/devs/ and ~/.claude/commands/
#
# Run from PowerShell:
#   .\install.ps1
#
# If you get an execution policy error, run once as admin:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DevsSource = Join-Path $RepoDir "devs"
$DevsTarget = Join-Path $env:USERPROFILE ".claude\devs"
$CommandsSource = Join-Path $RepoDir "commands"
$CommandsTarget = Join-Path $env:USERPROFILE ".claude\commands"

Write-Host "claude-devs install"
Write-Host ""

# Install dev files
Write-Host "Dev files: $DevsSource -> $DevsTarget"
New-Item -ItemType Directory -Force -Path $DevsTarget | Out-Null
Copy-Item "$DevsSource\*.md" -Destination $DevsTarget -Force
Get-ChildItem "$DevsSource\*.md" | ForEach-Object { Write-Host "  + $($_.Name)" }

Write-Host ""

# Install slash commands
Write-Host "Slash commands: $CommandsSource -> $CommandsTarget"
New-Item -ItemType Directory -Force -Path $CommandsTarget | Out-Null
Copy-Item "$CommandsSource\*.md" -Destination $CommandsTarget -Force
Get-ChildItem "$CommandsSource\*.md" | ForEach-Object { Write-Host "  + /$($_.BaseName)" }

Write-Host ""
Write-Host "Done."
Write-Host ""
Write-Host "Usage in Claude Code:"
Write-Host "  /pm                  <- start here if unsure"
Write-Host "  /senior-dev          <- guide active development"
Write-Host "  /code-review         <- audit existing code"
Write-Host "  /security            <- threat modeling"
Write-Host "  /ui                  <- design and UI review"
Write-Host "  /qa                  <- tests and coverage"
Write-Host "  /devops              <- CI/CD and infrastructure"
Write-Host "  /database            <- schema and queries"
Write-Host "  /api                 <- API design"
Write-Host "  /docs                <- documentation and writing"
Write-Host ""
Write-Host "Pass your request as an argument: /pm I want to build a task app"
