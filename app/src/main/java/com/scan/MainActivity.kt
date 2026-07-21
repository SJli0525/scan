package com.scan

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Toast

class MainActivity : Activity() {

    private lateinit var webView: WebView
    private var filePathCallback: ValueCallback<Array<Uri>>? = null
    private val REQ_FILE = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        webView = findViewById(R.id.webView)

        webView.settings.apply {
            javaScriptEnabled = true
            allowFileAccess = true
            allowContentAccess = true
            allowFileAccessFromFileURLs = true
            allowUniversalAccessFromFileURLs = true
            domStorageEnabled = true
            cacheMode = WebSettings.LOAD_NO_CACHE
        }

        // 拦截 OpenCV.js 的 CDN 请求，改读本地的离线文件
        webView.webViewClient = object : WebViewClient() {
            override fun shouldInterceptRequest(
                view: WebView?,
                request: WebResourceRequest?
            ): WebResourceResponse? {
                val url = request?.url.toString()
                return when {
                    url.contains("opencv_js.wasm") -> {
                        try {
                            val s = assets.open("opencv_js.wasm")
                            WebResourceResponse("application/wasm", "UTF-8", s)
                        } catch (e: Exception) { null }
                    }
                    url.contains("opencv.js") -> {
                        try {
                            val s = assets.open("opencv.js")
                            WebResourceResponse("application/javascript", "UTF-8", s)
                        } catch (e: Exception) { null }
                    }
                    else -> null
                }
            }
        }

        // 处理 <input type="file"> 选图
        webView.webChromeClient = object : WebChromeClient() {
            override fun onShowFileChooser(
                webView: WebView?,
                callback: ValueCallback<Array<Uri>>?,
                params: WebChromeClient.FileChooserParams?
            ): Boolean {
                filePathCallback?.onReceiveValue(null)
                filePathCallback = callback
                val intent = params?.createIntent()
                if (intent == null) {
                    callback?.onReceiveValue(null)
                    return false
                }
                return try {
                    startActivityForResult(intent, REQ_FILE)
                    true
                } catch (e: Exception) {
                    Toast.makeText(this@MainActivity, "无法打开文件选择器", Toast.LENGTH_SHORT).show()
                    false
                }
            }
        }

        webView.loadUrl("file:///android_asset/scan.html")
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQ_FILE) {
            filePathCallback?.onReceiveValue(
                WebChromeClient.FileChooserParams.parseResult(resultCode, data)
            )
            filePathCallback = null
        }
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) webView.goBack() else super.onBackPressed()
    }
}
