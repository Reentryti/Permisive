import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../services/guard_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/scan_button.dart';
import '../widgets/risk_gauge.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.shield_rounded, color: AppTheme.accentCyan, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text('PermissionGuard'),
                  ],
                ),
                titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              ),
              actions: [
                if (provider.state == ScanState.completed)
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Re-scan',
                    onPressed: () => provider.startScan(),
                  ),
                const SizedBox(width: 8),
              ],
            ),

            // ── Content ────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Defense Level Indicator
                  _DefenseLevelBanner(level: provider.defenseLevel),
                  const SizedBox(height: 20),

                  if (provider.state == ScanState.idle || provider.state == ScanState.error) ...[
                    _buildWelcomeSection(context, provider),
                  ] else if (provider.state == ScanState.scanning) ...[
                    _buildScanningSection(),
                  ] else if (provider.state == ScanState.completed && provider.summary != null) ...[
                    _buildSummarySection(context, provider),
                  ],
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context, GuardProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.accentCyan.withValues(alpha: 0.2),
                AppTheme.accentCyan.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: const Icon(
            Icons.security_rounded,
            size: 56,
            color: AppTheme.accentCyan,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Protect Your Device',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Scan installed apps to detect overprivileged\npermissions and reduce your attack surface.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ScanButton(onPressed: () => provider.startScan()),
        if (provider.error != null) ...[
          const SizedBox(height: 16),
          GlassCard(
            borderColor: AppTheme.accentRed.withValues(alpha: 0.3),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.accentRed, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: AppTheme.accentRed, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScanningSection() {
    return Column(
      children: [
        const SizedBox(height: 80),
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppTheme.accentCyan,
            backgroundColor: AppTheme.accentCyan.withValues(alpha: 0.1),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Scanning Applications...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Analyzing permissions and calculating risk scores',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context, GuardProvider provider) {
    final summary = provider.summary!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Risk Gauge
        RiskGauge(averageScore: summary.averageRiskScore, totalApps: summary.scannedApps),
        const SizedBox(height: 24),

        // Quick Stats
        Row(
          children: [
            _StatCard(
              label: 'SCANNED',
              value: '${summary.scannedApps}',
              icon: Icons.apps_rounded,
              color: AppTheme.accentCyan,
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'AT RISK',
              value: '${summary.highRiskApps + summary.criticalRiskApps}',
              icon: Icons.warning_rounded,
              color: AppTheme.accentRed,
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'SAFE',
              value: '${summary.lowRiskApps}',
              icon: Icons.verified_user_rounded,
              color: AppTheme.accentGreen,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Risk Distribution Chart
        Text(
          'Risk Distribution',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: SizedBox(
            height: 200,
            child: _buildRiskPieChart(summary),
          ),
        ),
        const SizedBox(height: 24),

        // Top Risky Apps
        Text(
          'Highest Risk Applications',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ...summary.topRiskApps.take(3).map((app) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TopRiskAppTile(app: app),
            )),

        // Most Abused Permissions
        if (summary.mostAbusedPermissions.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Most Flagged Permissions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Column(
              children: summary.mostAbusedPermissions.entries
                  .toList()
                  .take(5)
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: AppTheme.accentAmber, size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                    color: AppTheme.textPrimary, fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentAmber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${entry.value} apps',
                                style: const TextStyle(
                                  color: AppTheme.accentAmber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRiskPieChart(summary) {
    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: [
                if (summary.lowRiskApps > 0)
                  PieChartSectionData(
                    value: summary.lowRiskApps.toDouble(),
                    color: AppTheme.accentGreen,
                    radius: 40,
                    showTitle: false,
                  ),
                if (summary.mediumRiskApps > 0)
                  PieChartSectionData(
                    value: summary.mediumRiskApps.toDouble(),
                    color: AppTheme.accentAmber,
                    radius: 40,
                    showTitle: false,
                  ),
                if (summary.highRiskApps > 0)
                  PieChartSectionData(
                    value: summary.highRiskApps.toDouble(),
                    color: const Color(0xFFFF6D00),
                    radius: 40,
                    showTitle: false,
                  ),
                if (summary.criticalRiskApps > 0)
                  PieChartSectionData(
                    value: summary.criticalRiskApps.toDouble(),
                    color: AppTheme.accentRed,
                    radius: 40,
                    showTitle: false,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: AppTheme.accentGreen, label: 'Low', count: summary.lowRiskApps),
            const SizedBox(height: 8),
            _LegendItem(color: AppTheme.accentAmber, label: 'Medium', count: summary.mediumRiskApps),
            const SizedBox(height: 8),
            _LegendItem(color: const Color(0xFFFF6D00), label: 'High', count: summary.highRiskApps),
            const SizedBox(height: 8),
            _LegendItem(color: AppTheme.accentRed, label: 'Critical', count: summary.criticalRiskApps),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────

class _DefenseLevelBanner extends StatelessWidget {
  final int level;
  const _DefenseLevelBanner({required this.level});

  @override
  Widget build(BuildContext context) {
    final colors = [AppTheme.accentGreen, AppTheme.accentAmber, AppTheme.accentRed];
    final labels = ['Advisory Mode', 'Assisted Restriction', 'Enforcement Mode'];
    final icons = [Icons.info_outline, Icons.tune_rounded, Icons.lock_rounded];
    final color = colors[level - 1];

    return GlassCard(
      borderColor: color.withValues(alpha: 0.3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icons[level - 1], color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Defense Level $level',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  labels[level - 1],
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Level dots
          Row(
            children: List.generate(3, (i) {
              final active = i < level;
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? color : AppTheme.textMuted.withValues(alpha: 0.3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  const _LegendItem({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text('$label ($count)', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      ],
    );
  }
}

class _TopRiskAppTile extends StatelessWidget {
  final dynamic app;
  const _TopRiskAppTile({required this.app});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.riskColor(app.riskScore);
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(AppTheme.riskIcon(app.riskScore), color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.appName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${app.requestedPermissions.length} permissions · ${app.categoryName ?? "Unknown"}',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${app.riskScore.toStringAsFixed(1)}',
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
