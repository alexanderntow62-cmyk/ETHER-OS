package com.ether.os

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "ether/system"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "openUrl" -> {
                    val url = call.argument<String>("url")

                    if (url.isNullOrBlank()) {
                        result.error(
                            "INVALID_URL",
                            "No URL was provided.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val intent = Intent(
                            Intent.ACTION_VIEW,
                            Uri.parse(url)
                        )

                        startActivity(intent)
                        result.success(true)

                    } catch (e: Exception) {
                        result.error(
                            "OPEN_URL_FAILED",
                            e.message,
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
