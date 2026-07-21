Set-Location -Path $PSScriptRoot
"===== push start $(Get-Date) =====" | Set-Content push.log

function Log($msg) {
    $msg | Add-Content push.log
    Write-Host $msg
}

try {
    git add . 2>&1 | ForEach-Object { Log $_ }

    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        git commit -m "update" 2>&1 | ForEach-Object { Log $_ }
    } else {
        Log "no changes to commit"
    }

    git remote remove origin 2>&1 | ForEach-Object { Log $_ }
    git remote add origin https://github.com/SJli0525/scan.git 2>&1 | ForEach-Object { Log $_ }
    git push -u origin main 2>&1 | ForEach-Object { Log $_ }

    Log "exit_code=$LASTEXITCODE"
} catch {
    Log "ERROR: $_"
}

Write-Host "Done. If Git asks for credentials, enter your GitHub username and your token as the password."
Read-Host "Press Enter to exit"
