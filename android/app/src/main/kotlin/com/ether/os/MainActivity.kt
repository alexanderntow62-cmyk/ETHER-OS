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

                "launchApp" -> {
                    val appName = call.argument<String>("appName")?.trim()

                    if (appName.isNullOrBlank()) {
                        result.error(
                            "INVALID_APP_NAME",
                            "No app name was provided.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val packageManager = packageManager
                        val packages = packageManager.getInstalledPackages(0)

                        val target = appName.lowercase()

                        val matchingPackage = packages.firstOrNull { packageInfo ->
                            val label = packageInfo.applicationInfo?.loadLabel(packageManager)
                                .toString()
                                .lowercase()

                            label == target
                        } ?: packages.firstOrNull { packageInfo ->
                            val label = packageInfo.applicationInfo?.loadLabel(packageManager)
                                .toString()
                                .lowercase()

                            label.contains(target)
                        }

                        if (matchingPackage == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        val launchIntent = packageManager.getLaunchIntentForPackage(
                            matchingPackage.packageName
                        )

                        if (launchIntent == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(launchIntent)

                        result.success(true)

                    } catch (e: Exception) {
                        result.error(
                            "LAUNCH_APP_FAILED",
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
