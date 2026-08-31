package com.ether.os

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

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
                    val packageName =
                        call.argument<String>("packageName")

                    if (packageName.isNullOrBlank()) {
                        result.error(
                            "INVALID_PACKAGE",
                            "No package name was provided.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val launchIntent =
                            packageManager.getLaunchIntentForPackage(
                                packageName
                            )

                        if (launchIntent == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        launchIntent.addFlags(
                            Intent.FLAG_ACTIVITY_NEW_TASK
                        )

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

                "isAppInstalled" -> {
                    val packageName =
                        call.argument<String>("packageName")

                    if (packageName.isNullOrBlank()) {
                        result.error(
                            "INVALID_PACKAGE",
                            "No package name was provided.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        packageManager.getPackageInfo(
                            packageName,
                            PackageManager.GET_ACTIVITIES
                        )

                        result.success(true)

                    } catch (_: PackageManager.NameNotFoundException) {
                        result.success(false)

                    } catch (e: Exception) {
                        result.error(
                            "CHECK_APP_FAILED",
                            e.message,
                            null
                        )
                    }
                }

                "resolveApp" -> {
                    val appName =
                        call.argument<String>("appName")

                    if (appName.isNullOrBlank()) {
                        result.error(
                            "INVALID_APP_NAME",
                            "No app name was provided.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val packageName = resolveAppPackage(appName)

                        result.success(packageName)

                    } catch (e: Exception) {
                        result.error(
                            "RESOLVE_APP_FAILED",
                            e.message,
                            null
                        )
                    }
                }

                "launchAppByName" -> {
                    val appName =
                        call.argument<String>("appName")

                    if (appName.isNullOrBlank()) {
                        result.error(
                            "INVALID_APP_NAME",
                            "No app name was provided.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val packageName = resolveAppPackage(appName)

                        if (packageName == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        val launchIntent =
                            packageManager.getLaunchIntentForPackage(
                                packageName
                            )

                        if (launchIntent == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }

                        launchIntent.addFlags(
                            Intent.FLAG_ACTIVITY_NEW_TASK
                        )

                        startActivity(launchIntent)
                        result.success(true)

                    } catch (e: Exception) {
                        result.error(
                            "LAUNCH_APP_BY_NAME_FAILED",
                            e.message,
                            null
                        )
                    }
                }

                "openSettings" -> {
                    try {
                        val intent = Intent(
                            Settings.ACTION_SETTINGS
                        )

                        startActivity(intent)
                        result.success(true)

                    } catch (e: Exception) {
                        result.error(
                            "OPEN_SETTINGS_FAILED",
                            e.message,
                            null
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun resolveAppPackage(
        requestedName: String
    ): String? {

        val wanted =
            requestedName.trim().lowercase(Locale.getDefault())

        val intent = Intent(
            Intent.ACTION_MAIN,
            null
        )

        intent.addCategory(Intent.CATEGORY_LAUNCHER)

        val apps: List<ResolveInfo> =
            packageManager.queryIntentActivities(
                intent,
                PackageManager.MATCH_ALL
            )

        // Exact application-label match.
        for (info in apps) {
            val label =
                info.loadLabel(packageManager)
                    ?.toString()
                    ?.trim()
                    ?.lowercase(Locale.getDefault())

            if (label == wanted) {
                return info.activityInfo.packageName
            }
        }

        // Partial label match.
        for (info in apps) {
            val label =
                info.loadLabel(packageManager)
                    ?.toString()
                    ?.trim()
                    ?.lowercase(Locale.getDefault())

            if (!label.isNullOrEmpty() &&
                (label.contains(wanted) ||
                 wanted.contains(label))) {
                return info.activityInfo.packageName
            }
        }

        // Package-name fallback.
        for (info in apps) {
            val packageName =
                info.activityInfo.packageName.lowercase(
                    Locale.getDefault()
                )

            if (packageName == wanted ||
                packageName.contains(wanted)) {
                return info.activityInfo.packageName
            }
        }

        return null
    }
}
