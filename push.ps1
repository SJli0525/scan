# Push the Android project to GitHub.
# You can either:
#   1) Set env var: $env:GITHUB_TOKEN = "ghp_..."
#   2) Run this script directly and paste the token when prompted (input is masked)
Set-Location -Path $PSScriptRoot
Write-Host "===== push start $(Get-Date) ====="

$token = $env:GITHUB_TOKEN
if (-not $token) {
    Write-Host "GITHUB_TOKEN environment variable not set." -ForegroundColor Yellow
    $secureToken = Read-Host "Please paste your GitHub token (ghp_...)" -AsSecureString
    $token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
    )
    if (-not $token) {
        Write-Host "ERROR: No token provided." -ForegroundColor Red
        exit 1
    }
}

git add .
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "update"
} else {
    Write-Host "no changes to commit"
}

git push "https://SJli0525:$token@github.com/SJli0525/scan.git" master:main
Write-Host "exit_code=$LASTEXITCODE"
Write-Host "===== push done ====="
Read-Host "Press Enter to exit"
