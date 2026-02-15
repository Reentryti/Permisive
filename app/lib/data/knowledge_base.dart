import '../models/permission_models.dart';

/// Permission Knowledge Base
/// Defines expected permissions per app category and permission metadata
class PermissionKnowledgeBase {
  // ── Dangerous Permissions Database ─────────────────────────────
  static const Map<String, PermissionInfo> permissionDatabase = {
    // Location
    'android.permission.ACCESS_FINE_LOCATION': PermissionInfo(
      name: 'android.permission.ACCESS_FINE_LOCATION',
      group: 'Location',
      description: 'Precise GPS location',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Tracking user movements', 'Stalking', 'Profiling'],
    ),
    'android.permission.ACCESS_COARSE_LOCATION': PermissionInfo(
      name: 'android.permission.ACCESS_COARSE_LOCATION',
      group: 'Location',
      description: 'Approximate location via network',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Location tracking', 'Profiling'],
    ),
    'android.permission.ACCESS_BACKGROUND_LOCATION': PermissionInfo(
      name: 'android.permission.ACCESS_BACKGROUND_LOCATION',
      group: 'Location',
      description: 'Location access in background',
      dangerLevel: PermissionDangerLevel.special,
      potentialAbuse: ['Persistent surveillance', 'Continuous tracking'],
    ),

    // Camera & Microphone
    'android.permission.CAMERA': PermissionInfo(
      name: 'android.permission.CAMERA',
      group: 'Camera',
      description: 'Access device camera',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Covert photo/video capture', 'Spying'],
    ),
    'android.permission.RECORD_AUDIO': PermissionInfo(
      name: 'android.permission.RECORD_AUDIO',
      group: 'Microphone',
      description: 'Record audio via microphone',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Eavesdropping', 'Audio surveillance', 'Conversation recording'],
    ),

    // Contacts
    'android.permission.READ_CONTACTS': PermissionInfo(
      name: 'android.permission.READ_CONTACTS',
      group: 'Contacts',
      description: 'Read contact list',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Contact harvesting', 'Spam distribution', 'Social engineering'],
    ),
    'android.permission.WRITE_CONTACTS': PermissionInfo(
      name: 'android.permission.WRITE_CONTACTS',
      group: 'Contacts',
      description: 'Modify contact list',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Contact injection', 'Data manipulation'],
    ),

    // Phone
    'android.permission.READ_PHONE_STATE': PermissionInfo(
      name: 'android.permission.READ_PHONE_STATE',
      group: 'Phone',
      description: 'Read phone state and identity',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Device fingerprinting', 'IMEI tracking'],
    ),
    'android.permission.CALL_PHONE': PermissionInfo(
      name: 'android.permission.CALL_PHONE',
      group: 'Phone',
      description: 'Make phone calls',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Premium rate calls', 'Phone fraud'],
    ),
    'android.permission.READ_CALL_LOG': PermissionInfo(
      name: 'android.permission.READ_CALL_LOG',
      group: 'Phone',
      description: 'Read call history',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Surveillance', 'Profiling social connections'],
    ),

    // SMS
    'android.permission.SEND_SMS': PermissionInfo(
      name: 'android.permission.SEND_SMS',
      group: 'SMS',
      description: 'Send SMS messages',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Premium SMS fraud', 'Spam', 'Phishing'],
    ),
    'android.permission.READ_SMS': PermissionInfo(
      name: 'android.permission.READ_SMS',
      group: 'SMS',
      description: 'Read SMS messages',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['OTP interception', '2FA bypass', 'Data theft'],
    ),
    'android.permission.RECEIVE_SMS': PermissionInfo(
      name: 'android.permission.RECEIVE_SMS',
      group: 'SMS',
      description: 'Receive SMS messages',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['SMS interception', 'OTP theft'],
    ),

    // Storage
    'android.permission.READ_EXTERNAL_STORAGE': PermissionInfo(
      name: 'android.permission.READ_EXTERNAL_STORAGE',
      group: 'Storage',
      description: 'Read files on device',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Data exfiltration', 'Photo theft', 'Document access'],
    ),
    'android.permission.WRITE_EXTERNAL_STORAGE': PermissionInfo(
      name: 'android.permission.WRITE_EXTERNAL_STORAGE',
      group: 'Storage',
      description: 'Write files to device',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Malware dropper', 'Data corruption'],
    ),
    'android.permission.MANAGE_EXTERNAL_STORAGE': PermissionInfo(
      name: 'android.permission.MANAGE_EXTERNAL_STORAGE',
      group: 'Storage',
      description: 'Full access to all files',
      dangerLevel: PermissionDangerLevel.special,
      potentialAbuse: ['Complete data exfiltration', 'Ransomware'],
    ),

    // Body Sensors
    'android.permission.BODY_SENSORS': PermissionInfo(
      name: 'android.permission.BODY_SENSORS',
      group: 'Sensors',
      description: 'Access body sensors (heart rate, etc.)',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Health data theft', 'Profiling'],
    ),

    // Calendar
    'android.permission.READ_CALENDAR': PermissionInfo(
      name: 'android.permission.READ_CALENDAR',
      group: 'Calendar',
      description: 'Read calendar events',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Schedule surveillance', 'Social engineering'],
    ),
    'android.permission.WRITE_CALENDAR': PermissionInfo(
      name: 'android.permission.WRITE_CALENDAR',
      group: 'Calendar',
      description: 'Modify calendar events',
      dangerLevel: PermissionDangerLevel.dangerous,
      potentialAbuse: ['Calendar spam', 'Phishing events'],
    ),

    // Special Permissions
    'android.permission.SYSTEM_ALERT_WINDOW': PermissionInfo(
      name: 'android.permission.SYSTEM_ALERT_WINDOW',
      group: 'Special',
      description: 'Draw over other apps',
      dangerLevel: PermissionDangerLevel.special,
      potentialAbuse: ['Clickjacking', 'Overlay attacks', 'Credential phishing'],
    ),
    'android.permission.REQUEST_INSTALL_PACKAGES': PermissionInfo(
      name: 'android.permission.REQUEST_INSTALL_PACKAGES',
      group: 'Special',
      description: 'Install unknown apps',
      dangerLevel: PermissionDangerLevel.special,
      potentialAbuse: ['Sideloading malware', 'Dropper'],
    ),
    'android.permission.BIND_ACCESSIBILITY_SERVICE': PermissionInfo(
      name: 'android.permission.BIND_ACCESSIBILITY_SERVICE',
      group: 'Special',
      description: 'Accessibility service access',
      dangerLevel: PermissionDangerLevel.special,
      potentialAbuse: ['Keylogging', 'Screen scraping', 'Auto-clicking'],
    ),
    'android.permission.BIND_DEVICE_ADMIN': PermissionInfo(
      name: 'android.permission.BIND_DEVICE_ADMIN',
      group: 'Special',
      description: 'Device admin privileges',
      dangerLevel: PermissionDangerLevel.special,
      potentialAbuse: ['Device lockout', 'Ransomware', 'Data wipe'],
    ),

    // Network
    'android.permission.INTERNET': PermissionInfo(
      name: 'android.permission.INTERNET',
      group: 'Network',
      description: 'Full internet access',
      dangerLevel: PermissionDangerLevel.normal,
      potentialAbuse: ['Data exfiltration', 'C2 communication'],
    ),
    'android.permission.ACCESS_NETWORK_STATE': PermissionInfo(
      name: 'android.permission.ACCESS_NETWORK_STATE',
      group: 'Network',
      description: 'View network connections',
      dangerLevel: PermissionDangerLevel.normal,
    ),
    'android.permission.ACCESS_WIFI_STATE': PermissionInfo(
      name: 'android.permission.ACCESS_WIFI_STATE',
      group: 'Network',
      description: 'View Wi-Fi connections',
      dangerLevel: PermissionDangerLevel.normal,
    ),
  };

  // ── App Categories ─────────────────────────────────────────────
  static const Map<String, AppCategory> categories = {
    'social_media': AppCategory(
      name: 'Social Media',
      icon: '👥',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.READ_CONTACTS',
        'android.permission.ACCESS_FINE_LOCATION',
      ],
      suspiciousPermissions: [
        'android.permission.SEND_SMS',
        'android.permission.READ_SMS',
        'android.permission.READ_CALL_LOG',
        'android.permission.CALL_PHONE',
        'android.permission.BIND_DEVICE_ADMIN',
        'android.permission.MANAGE_EXTERNAL_STORAGE',
      ],
    ),
    'messaging': AppCategory(
      name: 'Messaging',
      icon: '💬',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.READ_CONTACTS',
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.RECEIVE_SMS',
        'android.permission.READ_SMS',
      ],
      suspiciousPermissions: [
        'android.permission.CALL_PHONE',
        'android.permission.BIND_DEVICE_ADMIN',
        'android.permission.SYSTEM_ALERT_WINDOW',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
      ],
    ),
    'navigation': AppCategory(
      name: 'Navigation',
      icon: '🗺️',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_COARSE_LOCATION',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.ACCESS_BACKGROUND_LOCATION',
      ],
      suspiciousPermissions: [
        'android.permission.READ_CONTACTS',
        'android.permission.CAMERA',
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_CALL_LOG',
      ],
    ),
    'game': AppCategory(
      name: 'Game',
      icon: '🎮',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.RECORD_AUDIO',
        'android.permission.READ_EXTERNAL_STORAGE',
      ],
      suspiciousPermissions: [
        'android.permission.READ_CONTACTS',
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CALL_LOG',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.CAMERA',
        'android.permission.CALL_PHONE',
        'android.permission.SYSTEM_ALERT_WINDOW',
        'android.permission.BIND_DEVICE_ADMIN',
      ],
    ),
    'productivity': AppCategory(
      name: 'Productivity',
      icon: '📋',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.READ_CALENDAR',
        'android.permission.WRITE_CALENDAR',
        'android.permission.CAMERA',
      ],
      suspiciousPermissions: [
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CONTACTS',
        'android.permission.RECORD_AUDIO',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.READ_CALL_LOG',
        'android.permission.BIND_DEVICE_ADMIN',
      ],
    ),
    'finance': AppCategory(
      name: 'Finance',
      icon: '💰',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.CAMERA',
        'android.permission.READ_PHONE_STATE',
        'android.permission.USE_BIOMETRIC',
      ],
      suspiciousPermissions: [
        'android.permission.READ_CONTACTS',
        'android.permission.READ_SMS',
        'android.permission.READ_CALL_LOG',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.RECORD_AUDIO',
        'android.permission.SYSTEM_ALERT_WINDOW',
        'android.permission.BIND_DEVICE_ADMIN',
      ],
    ),
    'health': AppCategory(
      name: 'Health & Fitness',
      icon: '❤️',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [
        'android.permission.BODY_SENSORS',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.CAMERA',
        'android.permission.ACTIVITY_RECOGNITION',
      ],
      suspiciousPermissions: [
        'android.permission.READ_CONTACTS',
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CALL_LOG',
        'android.permission.CALL_PHONE',
        'android.permission.SYSTEM_ALERT_WINDOW',
      ],
    ),
    'utility': AppCategory(
      name: 'Utility',
      icon: '🔧',
      requiredPermissions: [
        'android.permission.INTERNET',
      ],
      optionalPermissions: [
        'android.permission.CAMERA',
        'android.permission.READ_EXTERNAL_STORAGE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      suspiciousPermissions: [
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_CALL_LOG',
        'android.permission.RECORD_AUDIO',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.BIND_DEVICE_ADMIN',
      ],
    ),
    'unknown': AppCategory(
      name: 'Unknown',
      icon: '❓',
      requiredPermissions: [
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ],
      optionalPermissions: [],
      suspiciousPermissions: [
        'android.permission.READ_SMS',
        'android.permission.SEND_SMS',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_CALL_LOG',
        'android.permission.CALL_PHONE',
        'android.permission.RECORD_AUDIO',
        'android.permission.CAMERA',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.ACCESS_BACKGROUND_LOCATION',
        'android.permission.SYSTEM_ALERT_WINDOW',
        'android.permission.BIND_DEVICE_ADMIN',
        'android.permission.MANAGE_EXTERNAL_STORAGE',
        'android.permission.REQUEST_INSTALL_PACKAGES',
      ],
    ),
  };

  /// Lookup permission info, return a default if unknown
  static PermissionInfo getPermissionInfo(String permission) {
    return permissionDatabase[permission] ??
        PermissionInfo(
          name: permission,
          group: 'Other',
          description: 'Unknown permission',
          dangerLevel: PermissionDangerLevel.normal,
        );
  }

  /// Get the category for a package name (heuristic-based)
  static AppCategory guessCategory(String packageName, String appName) {
    final lower = '${packageName.toLowerCase()} ${appName.toLowerCase()}';

    if (_matches(lower, ['facebook', 'instagram', 'twitter', 'tiktok', 'snapchat', 'linkedin', 'reddit', 'social'])) {
      return categories['social_media']!;
    }
    if (_matches(lower, ['whatsapp', 'telegram', 'signal', 'viber', 'messenger', 'chat', 'sms', 'message'])) {
      return categories['messaging']!;
    }
    if (_matches(lower, ['maps', 'waze', 'navigation', 'gps', 'uber', 'lyft', 'bolt', 'grab'])) {
      return categories['navigation']!;
    }
    if (_matches(lower, ['game', 'play', 'puzzle', 'arcade', 'racing', 'rpg', 'unity', 'supercell'])) {
      return categories['game']!;
    }
    if (_matches(lower, ['bank', 'pay', 'wallet', 'finance', 'money', 'revolut', 'wise', 'crypto'])) {
      return categories['finance']!;
    }
    if (_matches(lower, ['health', 'fitness', 'workout', 'run', 'step', 'medical', 'heart'])) {
      return categories['health']!;
    }
    if (_matches(lower, ['note', 'calendar', 'office', 'docs', 'sheet', 'slide', 'task', 'todo', 'mail', 'email'])) {
      return categories['productivity']!;
    }
    if (_matches(lower, ['calculator', 'flashlight', 'scanner', 'cleaner', 'file', 'manager', 'clock', 'alarm'])) {
      return categories['utility']!;
    }

    return categories['unknown']!;
  }

  static bool _matches(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }
}
