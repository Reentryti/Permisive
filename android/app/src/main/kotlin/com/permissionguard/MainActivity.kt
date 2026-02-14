package com.permissionguard

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.permissionguard/scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    try {
                        val apps = getInstalledAppsInfo()
                        result.success(apps)
                    } catch (e: Exception) {
                        result.error("SCAN_ERROR", "Failed to scan apps: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getInstalledAppsInfo(): List<Map<String, Any?>> {
        val pm = packageManager
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            PackageManager.GET_PERMISSIONS
        } else {
            @Suppress("DEPRECATION")
            PackageManager.GET_PERMISSIONS
        }

        val packages = pm.getInstalledPackages(flags)
        return packages.map { pkgInfo ->
            val requestedPerms = pkgInfo.requestedPermissions?.toList() ?: emptyList()
            val grantedPerms = mutableListOf<String>()

            pkgInfo.requestedPermissions?.forEachIndexed { index, perm ->
                if (pkgInfo.requestedPermissionsFlags != null &&
                    pkgInfo.requestedPermissionsFlags!![index] and PackageInfo.REQUESTED_PERMISSION_GRANTED != 0
                ) {
                    grantedPerms.add(perm)
                }
            }

            val isSystemApp = (pkgInfo.applicationInfo?.flags ?: 0) and
                    android.content.pm.ApplicationInfo.FLAG_SYSTEM != 0

            mapOf(
                "packageName" to pkgInfo.packageName,
                "appName" to (pkgInfo.applicationInfo?.loadLabel(pm)?.toString() ?: pkgInfo.packageName),
                "requestedPermissions" to requestedPerms,
                "grantedPermissions" to grantedPerms,
                "isSystemApp" to isSystemApp,
                "versionName" to pkgInfo.versionName,
            )
        }
    }
}
