# Download offline OpenCV.js (and wasm if available) for Android assets
$base = "https://docs.opencv.org/4.8.0"
$out  = "app/src/main/assets"
New-Item -ItemType Directory -Force -Path $out | Out-Null

Write-Host "Downloading opencv.js ..."
curl.exe -L -o "$out/opencv.js" "$base/opencv.js"

Write-Host "Downloading opencv_js.wasm ..."
curl.exe -L -o "$out/opencv_js.wasm" "$base/opencv_js.wasm"

$wasmPath = "$out/opencv_js.wasm"
$wasmBytes = Get-Content -Path $wasmPath -Encoding Byte -TotalCount 4
# Real wasm files start with the magic bytes 0x00 0x61 0x73 0x6D ("\0asm")
$isWasm = ($wasmBytes.Count -ge 4) -and
          ($wasmBytes[0] -eq 0) -and
          ($wasmBytes[1] -eq 97) -and
          ($wasmBytes[2] -eq 115) -and
          ($wasmBytes[3] -eq 109)

if (-not $isWasm) {
    Write-Host "opencv_js.wasm is not a real wasm file (likely a 404 page). Removing it - this version of opencv.js has wasm inlined." -ForegroundColor Yellow
    Remove-Item $wasmPath
}

Write-Host "Done. Files are in $out" -ForegroundColor Green
Write-Host "Please ensure scan.html is also present in $out." -ForegroundColor Green
