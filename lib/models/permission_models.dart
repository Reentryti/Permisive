/// Represents an Android permission with metadata
class PermissionInfo {
  final String name;
  final String group;
  final String description;
  final PermissionDangerLevel dangerLevel;
  final List<String> potentialAbuse;

  const PermissionInfo({
    required this.name,
    required this.group,
    required this.description,
    required this.dangerLevel,
    this.potentialAbuse = const [],
  });

  String get shortName {
    final parts = name.split('.');
    return parts.last;
  }
}

enum PermissionDangerLevel {
  normal(0, 'Normal'),
  signature(0, 'Signature'),
  dangerous(2, 'Dangerous'),
  special(3, 'Special');

  final int baseScore;
  final String label;
  const PermissionDangerLevel(this.baseScore, this.label);
}

/// Represents an application category with expected permissions
class AppCategory {
  final String name;
  final String icon;
  final List<String> requiredPermissions;
  final List<String> optionalPermissions;
  final List<String> suspiciousPermissions;

  const AppCategory({
    required this.name,
    required this.icon,
    this.requiredPermissions = const [],
    this.optionalPermissions = const [],
    this.suspiciousPermissions = const [],
  });
}

/// Represents a scanned application
class ScannedApp {
  final String packageName;
  final String appName;
  final String? categoryName;
  final List<String> requestedPermissions;
  final List<String> grantedPermissions;
  final double riskScore;
  final List<PermissionFinding> findings;
  final DateTime scannedAt;
  final bool isSystemApp;

  const ScannedApp({
    required this.packageName,
    required this.appName,
    this.categoryName,
    required this.requestedPermissions,
    required this.grantedPermissions,
    required this.riskScore,
    required this.findings,
    required this.scannedAt,
    this.isSystemApp = false,
  });

  int get dangerousPermCount =>
      findings.where((f) => f.severity == FindingSeverity.high || f.severity == FindingSeverity.critical).length;
}

/// A finding about a specific permission
class PermissionFinding {
  final String permission;
  final String message;
  final FindingSeverity severity;
  final String recommendation;
  final int scoreContribution;

  const PermissionFinding({
    required this.permission,
    required this.message,
    required this.severity,
    required this.recommendation,
    this.scoreContribution = 0,
  });
}

enum FindingSeverity {
  info('Info'),
  low('Low'),
  medium('Medium'),
  high('High'),
  critical('Critical');

  final String label;
  const FindingSeverity(this.label);
}

/// Summary of a full scan
class ScanSummary {
  final int totalApps;
  final int scannedApps;
  final int lowRiskApps;
  final int mediumRiskApps;
  final int highRiskApps;
  final int criticalRiskApps;
  final double averageRiskScore;
  final List<ScannedApp> topRiskApps;
  final DateTime timestamp;
  final Map<String, int> mostAbusedPermissions;

  const ScanSummary({
    required this.totalApps,
    required this.scannedApps,
    required this.lowRiskApps,
    required this.mediumRiskApps,
    required this.highRiskApps,
    required this.criticalRiskApps,
    required this.averageRiskScore,
    required this.topRiskApps,
    required this.timestamp,
    required this.mostAbusedPermissions,
  });
}
