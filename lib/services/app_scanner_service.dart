import 'dart:math';
import 'package:flutter/services.dart';
import '../models/permission_models.dart';
import 'risk_scoring_service.dart';

/// Service that scans installed apps and their permissions.
/// Uses platform channels on real Android, falls back to demo data otherwise.
class AppScannerService {
  static const _channel = MethodChannel('com.permissionguard/scanner');
  final RiskScoringService _riskService = RiskScoringService();

  /// Attempt to scan real apps via platform channel; fallback to demo
  Future<List<ScannedApp>> scanInstalledApps() async {
    try {
      final List<dynamic> rawApps = await _channel.invokeMethod('getInstalledApps');
      return rawApps.map((app) {
        final map = Map<String, dynamic>.from(app);
        return _riskService.analyzeApp(
          packageName: map['packageName'] as String,
          appName: map['appName'] as String,
          requestedPermissions: List<String>.from(map['requestedPermissions'] ?? []),
          grantedPermissions: List<String>.from(map['grantedPermissions'] ?? []),
          isSystemApp: map['isSystemApp'] as bool? ?? false,
        );
      }).toList();
    } on PlatformException catch (_) {
      return _generateDemoData();
    } on MissingPluginException catch (_) {
      return _generateDemoData();
    }
  }

  /// Demo dataset for testing / emulator environments
  List<ScannedApp> _generateDemoData() {
    final demoApps = [
      _DemoApp('com.whatsapp', 'WhatsApp', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.READ_CONTACTS',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.READ_PHONE_STATE',
        'android.permission.RECEIVE_SMS',
        'android.permission.READ_SMS',
      ]),
      _DemoApp('com.instagram.android', 'Instagram', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.READ_CONTACTS',
      ]),
      _DemoApp('com.facebook.katana', 'Facebook', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_COARSE_LOCATION',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_PHONE_STATE',
        'android.permission.READ_CALL_LOG',
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.SYSTEM_ALERT_WINDOW',
      ]),
      _DemoApp('com.supercell.clashofclans', 'Clash of Clans', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.ACCESS_WIFI_STATE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
      ]),
      _DemoApp('com.google.android.apps.maps', 'Google Maps', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_COARSE_LOCATION',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_CONTACTS',
      ]),
      _DemoApp('com.spotify.music', 'Spotify', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.RECORD_AUDIO',
      ]),
      _DemoApp('com.zhiliaoapp.musically', 'TikTok', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_PHONE_STATE',
        'android.permission.READ_CALENDAR',
      ]),
      _DemoApp('com.suspicious.flashlight', 'Super Flashlight Pro', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.CAMERA',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CALL_LOG',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.MANAGE_EXTERNAL_STORAGE',
        'android.permission.SYSTEM_ALERT_WINDOW',
        'android.permission.REQUEST_INSTALL_PACKAGES',
      ]),
      _DemoApp('com.fake.calculator', 'Calculator Plus Free', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.READ_CONTACTS',
        'android.permission.SEND_SMS',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_PHONE_STATE',
        'android.permission.READ_CALL_LOG',
        'android.permission.READ_EXTERNAL_STORAGE',
      ]),
      _DemoApp('com.revolut.revolut', 'Revolut', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.CAMERA',
        'android.permission.READ_PHONE_STATE',
      ]),
      _DemoApp('com.google.android.gm', 'Gmail', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.CAMERA',
        'android.permission.GET_ACCOUNTS',
      ]),
      _DemoApp('org.telegram.messenger', 'Telegram', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.READ_CONTACTS',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.READ_PHONE_STATE',
      ]),
      _DemoApp('com.malware.cleaner', 'Phone Booster & Cleaner', [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CALL_LOG',
        'android.permission.CALL_PHONE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.MANAGE_EXTERNAL_STORAGE',
        'android.permission.SYSTEM_ALERT_WINDOW',
        'android.permission.REQUEST_INSTALL_PACKAGES',
        'android.permission.BIND_ACCESSIBILITY_SERVICE',
        'android.permission.BIND_DEVICE_ADMIN',
      ]),
    ];

    final rng = Random(42);
    return demoApps.map((demo) {
      // Simulate that most granted permissions match requested
      final granted = demo.permissions
          .where((_) => rng.nextDouble() > 0.2)
          .toList();
      return _riskService.analyzeApp(
        packageName: demo.packageName,
        appName: demo.appName,
        requestedPermissions: demo.permissions,
        grantedPermissions: granted,
      );
    }).toList();
  }
}

class _DemoApp {
  final String packageName;
  final String appName;
  final List<String> permissions;
  _DemoApp(this.packageName, this.appName, this.permissions);
}
