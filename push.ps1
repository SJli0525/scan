# Push the Android project to GitHub.
# Before running, set your token: $env:GITHUB_TOKEN = "ghp_..."
Set-Location -Path $PSScriptRoot
Write-Host "===== push start $(Get-Date) ====="

if (-not $env:GITHUB_TOKEN) {
    Write-Host "ERROR: GITHUB_TOKEN environment variable is not set." -ForegroundColor Red
    Write-Host "Set it with: `$env:GITHUB_TOKEN = 'ghp_...'" -ForegroundColor Yellow
    exit 1
}

git add .
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "update"
} else {
    Write-Host "no changes to commit"
}

git push "https://SJli0525:$env:GITHUB_TOKEN@github.com/SJli0525/scan.git" master:main
Write-Host "exit_code=$LASTEXITCODE"
Write-Host "===== push done ====="
Read-Host "Press Enter to exit"
