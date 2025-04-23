package com.example.gatepilot

import android.os.Bundle
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import android.webkit.CookieManager

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val webView: WebView = findViewById(R.id.WebView)
        val webSettings: WebSettings = webView.settings

        webSettings.javaScriptEnabled = true
        webSettings.loadWithOverviewMode = true
        webSettings.useWideViewPort = true
        webSettings.setSupportZoom(true)
        webSettings.domStorageEnabled = true
        webSettings.databaseEnabled = true


        webSettings.userAgentString = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

        val cookieManager = CookieManager.getInstance()
        cookieManager.setAcceptCookie(true)
        cookieManager.setAcceptThirdPartyCookies(webView, true)

        webView.webViewClient = WebViewClient()
        webView.webChromeClient = android.webkit.WebChromeClient()

        webView.loadUrl("https://SET_URL_HERE.com") // <---- SET YOUR SERVER URL HERE
    }

    override fun onPause() {
        super.onPause()
        CookieManager.getInstance().flush()
    }
}
