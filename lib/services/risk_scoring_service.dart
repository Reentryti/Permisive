import '../models/permission_models.dart';
import '../data/knowledge_base.dart';

/// Risk Scoring Engine
/// Evaluates applications against the permission knowledge base
class RiskScoringService {
  /// Analyze an app and produce a ScannedApp result
  ScannedApp analyzeApp({
    required String packageName,
    required String appName,
    required List<String> requestedPermissions,
    required List<String> grantedPermissions,
    bool isSystemApp = false,
  }) {
    final category = PermissionKnowledgeBase.guessCategory(packageName, appName);
    final findings = <PermissionFinding>[];
    double score = 0;

    for (final perm in requestedPermissions) {
      final permInfo = PermissionKnowledgeBase.getPermissionInfo(perm);

      if (category.requiredPermissions.contains(perm)) {
        // Required: +0 score, informational finding
        findings.add(PermissionFinding(
          permission: perm,
          message: '${permInfo.shortName} is expected for ${category.name} apps.',
          severity: FindingSeverity.info,
          recommendation: 'This permission is standard for this app category.',
          scoreContribution: 0,
        ));
      } else if (category.optionalPermissions.contains(perm)) {
        // Optional: +1 score
        score += 1;
        findings.add(PermissionFinding(
          permission: perm,
          message: '${permInfo.shortName} is optional for ${category.name} apps.',
          severity: FindingSeverity.low,
          recommendation: 'Consider if you need this feature. Revoke if not used.',
          scoreContribution: 1,
        ));
      } else if (category.suspiciousPermissions.contains(perm)) {
        // Suspicious: +3 score
        score += 3;
        final severity = permInfo.dangerLevel == PermissionDangerLevel.special
            ? FindingSeverity.critical
            : FindingSeverity.high;
        findings.add(PermissionFinding(
          permission: perm,
          message:
              '${permInfo.shortName} is suspicious for ${category.name} apps. ${permInfo.potentialAbuse.isNotEmpty ? "Potential abuse: ${permInfo.potentialAbuse.join(', ')}." : ""}',
          severity: severity,
          recommendation: 'REVOKE this permission. It is not expected for this type of app.',
          scoreContribution: 3,
        ));
      } else {
        // Not in any list — evaluate by danger level
        final contribution = permInfo.dangerLevel.baseScore;
        score += contribution;
        final severity = contribution >= 2 ? FindingSeverity.medium : FindingSeverity.info;
        findings.add(PermissionFinding(
          permission: perm,
          message: '${permInfo.shortName}: ${permInfo.description}. '
              'Danger level: ${permInfo.dangerLevel.label}.',
          severity: severity,
          recommendation: contribution >= 2
              ? 'Review this permission carefully.'
              : 'Generally safe.',
          scoreContribution: contribution,
        ));
      }
    }

    // Bonus: penalize apps with many dangerous permissions
    final dangerousCount = requestedPermissions.where((p) {
      final info = PermissionKnowledgeBase.getPermissionInfo(p);
      return info.dangerLevel == PermissionDangerLevel.dangerous ||
          info.dangerLevel == PermissionDangerLevel.special;
    }).length;

    if (dangerousCount > 5) {
      score += (dangerousCount - 5) * 1.5;
      findings.add(PermissionFinding(
        permission: 'AGGREGATE',
        message: 'This app requests $dangerousCount dangerous/special permissions — significantly above average.',
        severity: FindingSeverity.high,
        recommendation: 'High permission count increases attack surface. Review each permission.',
        scoreContribution: ((dangerousCount - 5) * 1.5).round(),
      ));
    }

    // Sort findings: critical/high first
    findings.sort((a, b) => b.severity.index.compareTo(a.severity.index));

    return ScannedApp(
      packageName: packageName,
      appName: appName,
      categoryName: category.name,
      requestedPermissions: requestedPermissions,
      grantedPermissions: grantedPermissions,
      riskScore: score,
      findings: findings,
      scannedAt: DateTime.now(),
      isSystemApp: isSystemApp,
    );
  }

  /// Generate a scan summary from a list of scanned apps
  ScanSummary generateSummary(List<ScannedApp> apps) {
    int low = 0, medium = 0, high = 0, critical = 0;
    double totalScore = 0;
    final permCount = <String, int>{};

    for (final app in apps) {
      totalScore += app.riskScore;
      if (app.riskScore <= 3) {
        low++;
      } else if (app.riskScore <= 8) {
        medium++;
      } else if (app.riskScore <= 15) {
        high++;
      } else {
        critical++;
      }

      for (final finding in app.findings) {
        if (finding.severity == FindingSeverity.high ||
            finding.severity == FindingSeverity.critical) {
          final shortName = finding.permission.split('.').last;
          permCount[shortName] = (permCount[shortName] ?? 0) + 1;
        }
      }
    }

    final sorted = List<ScannedApp>.from(apps)
      ..sort((a, b) => b.riskScore.compareTo(a.riskScore));

    return ScanSummary(
      totalApps: apps.length,
      scannedApps: apps.length,
      lowRiskApps: low,
      mediumRiskApps: medium,
      highRiskApps: high,
      criticalRiskApps: critical,
      averageRiskScore: apps.isEmpty ? 0 : totalScore / apps.length,
      topRiskApps: sorted.take(5).toList(),
      timestamp: DateTime.now(),
      mostAbusedPermissions: permCount,
    );
  }
}
