# 纸张测距 · 离线安卓版

把网页版 `scan.html`（OpenCV.js）封装成**完全离线**的安卓 App。

## 目录结构
```
android/
├─ app/src/main/assets/        # 放 scan.html + opencv.js + opencv_js.wasm
├─ app/src/main/java/com/scan/MainActivity.kt   # WebView 封装
├─ app/src/main/res/layout/activity_main.xml
├─ app/src/main/AndroidManifest.xml
├─ app/build.gradle
├─ build.gradle
├─ settings.gradle
└─ 下载opencv.ps1              # 拉取离线的 opencv 文件
```

## 构建步骤
1. 安装 **Android Studio**（含 Android SDK 34）。
2. 在本目录运行 `下载opencv.ps1`（PowerShell），得到 `assets/opencv.js` 与 `opencv_js.wasm`。
3. 把 `d:\scan\scan.html` 复制到 `app/src/main/assets/scan.html`。
4. 用 Android Studio 打开 `android/` 目录，等待 Gradle 同步完成。
5. 手机开启「USB 调试」连上电脑，或新建模拟器，点击 ▶ Run 安装到设备。

## 原理
- `MainActivity` 用 `WebView` 加载 `file:///android_asset/scan.html`。
- `shouldInterceptRequest` 拦截对 `docs.opencv.org` 的请求，改读本地的
  `opencv.js` / `opencv_js.wasm`，因此**无需联网**。
- `onShowFileChooser` 让页面里的「选择文件」按钮能调用系统相册/文件管理器。
- Manifest 未申请任何网络权限，纯离线运行。

## 备注
- 若 `opencv_js.wasm` 下载 404（某些版本把 wasm 内联进 opencv.js），可忽略，
  仅 `opencv.js` 也能工作。
- 若仍加载不出 OpenCV，打开 App 后状态栏会停在「正在加载 OpenCV.js…」，
  此时确认 `assets` 下三个文件齐全、文件名大小写一致。
