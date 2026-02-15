import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/permission_models.dart';
import '../data/knowledge_base.dart';
import '../widgets/glass_card.dart';

class AppDetailScreen extends StatelessWidget {
  final ScannedApp app;
  const AppDetailScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.riskColor(app.riskScore);
    final riskLabel = AppTheme.riskLabel(app.riskScore);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.2),
                      AppTheme.deepNavy,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // App icon
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: color.withValues(alpha: 0.3)),
                          ),
                          child: Center(
                            child: Text(
                              app.appName.isNotEmpty ? app.appName[0] : '?',
                              style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.appName,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                app.packageName,
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _Badge(label: riskLabel, color: color),
                                  const SizedBox(width: 8),
                                  _Badge(label: app.categoryName ?? 'Unknown', color: AppTheme.accentPurple),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Risk Score Card
                GlassCard(
                  borderColor: color.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.12),
                          border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
                        ),
                        child: Center(
                          child: Text(
                            app.riskScore.toStringAsFixed(1),
                            style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Permission Risk Score', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              _riskExplanation(app.riskScore),
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    _MiniStat(label: 'Requested', value: '${app.requestedPermissions.length}', color: AppTheme.accentCyan),
                    const SizedBox(width: 8),
                    _MiniStat(label: 'Granted', value: '${app.grantedPermissions.length}', color: AppTheme.accentAmber),
                    const SizedBox(width: 8),
                    _MiniStat(label: 'Issues', value: '${app.dangerousPermCount}', color: AppTheme.accentRed),
                  ],
                ),
                const SizedBox(height: 24),

                // Findings Section
                const Text(
                  'PERMISSION ANALYSIS',
                  style: TextStyle(
                    color: AppTheme.accentCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Critical / High findings first
                ...app.findings
                    .where((f) => f.severity == FindingSeverity.critical || f.severity == FindingSeverity.high)
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _FindingCard(finding: f),
                        )),

                if (app.findings.any((f) => f.severity == FindingSeverity.critical || f.severity == FindingSeverity.high))
                  const SizedBox(height: 8),

                // Medium / Low findings
                ...app.findings
                    .where((f) => f.severity == FindingSeverity.medium || f.severity == FindingSeverity.low)
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _FindingCard(finding: f),
                        )),

                // Info findings (collapsible)
                if (app.findings.any((f) => f.severity == FindingSeverity.info)) ...[
                  const SizedBox(height: 8),
                  _InfoFindingsSection(
                    findings: app.findings.where((f) => f.severity == FindingSeverity.info).toList(),
                  ),
                ],

                const SizedBox(height: 24),

                // Recommendation Card
                GlassCard(
                  borderColor: AppTheme.accentCyan.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: AppTheme.accentCyan, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Recommendation',
                            style: TextStyle(
                              color: AppTheme.accentCyan,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getRecommendation(),
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // All Permissions List
                const Text(
                  'ALL REQUESTED PERMISSIONS',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...app.requestedPermissions.map((perm) {
                  final info = PermissionKnowledgeBase.getPermissionInfo(perm);
                  final granted = app.grantedPermissions.contains(perm);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _PermissionTile(info: info, granted: granted),
                  );
                }),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _riskExplanation(double score) {
    if (score <= 3) return 'This app requests only expected permissions for its category. Low risk.';
    if (score <= 8) return 'Some optional or unexpected permissions detected. Review recommended.';
    if (score <= 15) return 'Multiple suspicious permissions found. This app may be overprivileged.';
    return 'Critical: This app requests many dangerous and unexpected permissions. High abuse potential.';
  }

  String _getRecommendation() {
    if (app.riskScore <= 3) {
      return 'This app appears to follow the principle of least privilege. No action needed.';
    } else if (app.riskScore <= 8) {
      return 'Review the optional permissions and revoke any you don\'t actively use. Navigate to Android Settings > Apps > ${app.appName} > Permissions.';
    } else if (app.riskScore <= 15) {
      return 'This app requests permissions beyond what\'s expected for a ${app.categoryName} app. Strongly consider revoking suspicious permissions. If the app still functions, those permissions were unnecessary.';
    } else {
      return 'WARNING: This app has a critical risk score. The number and nature of permissions it requests are consistent with spyware or malware behavior. Consider uninstalling this app immediately and scanning your device.';
    }
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _FindingCard extends StatelessWidget {
  final PermissionFinding finding;
  const _FindingCard({required this.finding});

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(finding.severity);
    final icon = _severityIcon(finding.severity);

    return GlassCard(
      borderColor: color.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  finding.permission.split('.').last,
                  style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  finding.severity.label.toUpperCase(),
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            finding.message,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.deepNavy.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_rounded, color: AppTheme.accentCyan, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    finding.recommendation,
                    style: const TextStyle(color: AppTheme.accentCyan, fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _severityColor(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.critical:
        return AppTheme.accentRed;
      case FindingSeverity.high:
        return const Color(0xFFFF6D00);
      case FindingSeverity.medium:
        return AppTheme.accentAmber;
      case FindingSeverity.low:
        return AppTheme.accentGreen;
      case FindingSeverity.info:
        return AppTheme.textMuted;
    }
  }

  IconData _severityIcon(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.critical:
        return Icons.gpp_bad_rounded;
      case FindingSeverity.high:
        return Icons.warning_rounded;
      case FindingSeverity.medium:
        return Icons.info_rounded;
      case FindingSeverity.low:
        return Icons.check_circle_rounded;
      case FindingSeverity.info:
        return Icons.info_outline_rounded;
    }
  }
}

class _InfoFindingsSection extends StatefulWidget {
  final List<PermissionFinding> findings;
  const _InfoFindingsSection({required this.findings});

  @override
  State<_InfoFindingsSection> createState() => _InfoFindingsSectionState();
}

class _InfoFindingsSectionState extends State<_InfoFindingsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.textMuted, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${widget.findings.length} standard permission${widget.findings.length > 1 ? 's' : ''}',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                ),
                const Spacer(),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...widget.findings.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _FindingCard(finding: f),
              )),
      ],
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final PermissionInfo info;
  final bool granted;
  const _PermissionTile({required this.info, required this.granted});

  @override
  Widget build(BuildContext context) {
    final dangerColor = _dangerColor(info.dangerLevel);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dangerColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.shortName,
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  info.description,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (granted ? AppTheme.accentAmber : AppTheme.textMuted).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              granted ? 'GRANTED' : 'DENIED',
              style: TextStyle(
                color: granted ? AppTheme.accentAmber : AppTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _dangerColor(PermissionDangerLevel level) {
    switch (level) {
      case PermissionDangerLevel.normal:
        return AppTheme.accentGreen;
      case PermissionDangerLevel.signature:
        return AppTheme.accentCyan;
      case PermissionDangerLevel.dangerous:
        return AppTheme.accentAmber;
      case PermissionDangerLevel.special:
        return AppTheme.accentRed;
    }
  }
}
