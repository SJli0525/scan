# 下载离线所需的 OpenCV.js 与 wasm 到 assets 目录
$base = "https://docs.opencv.org/4.8.0"
$out  = "app/src/main/assets"
New-Item -ItemType Directory -Force -Path $out | Out-Null

Write-Host "下载 opencv.js ..."
Invoke-WebRequest -Uri "$base/opencv.js" -OutFile "$out/opencv.js"

Write-Host "下载 opencv_js.wasm ..."
try {
    Invoke-WebRequest -Uri "$base/opencv_js.wasm" -OutFile "$out/opencv_js.wasm"
} catch {
    Write-Host "opencv_js.wasm 下载失败（部分版本把 wasm 内联进了 opencv.js，可忽略）" -ForegroundColor Yellow
}

Write-Host "完成：文件已放入 $out" -ForegroundColor Green
Write-Host "请再把 d:\scan\scan.html 复制到 $out\scan.html"
