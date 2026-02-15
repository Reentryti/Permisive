import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/guard_provider.dart';
import '../data/knowledge_base.dart';
import '../widgets/glass_card.dart';

class ThreatMapScreen extends StatelessWidget {
  const ThreatMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardProvider>(
      builder: (context, provider, _) {
        if (provider.state != ScanState.completed) {
          return _buildEmptyState();
        }
        return _buildThreatView(context, provider);
      },
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.radar_rounded, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            const Text('No threat data', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Run a scan first', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildThreatView(BuildContext context, GuardProvider provider) {
    final apps = provider.scannedApps;

    // Group permissions by type and count how many apps use each
    final permGroups = <String, _PermGroupData>{};
    for (final app in apps) {
      for (final perm in app.requestedPermissions) {
        final info = PermissionKnowledgeBase.getPermissionInfo(perm);
        final group = info.group;
        permGroups.putIfAbsent(group, () => _PermGroupData(group: group, permissions: {}, appCount: 0));
        permGroups[group]!.permissions.putIfAbsent(info.shortName, () => 0);
        permGroups[group]!.permissions[info.shortName] = permGroups[group]!.permissions[info.shortName]! + 1;
        permGroups[group]!.appCount++;
      }
    }

    final sortedGroups = permGroups.values.toList()..sort((a, b) => b.appCount.compareTo(a.appCount));

    // Threat categories
    final spywareApps = apps.where((a) {
      final perms = a.requestedPermissions;
      return perms.any((p) => p.contains('RECORD_AUDIO')) &&
          perms.any((p) => p.contains('CAMERA')) &&
          perms.any((p) => p.contains('LOCATION'));
    }).toList();

    final dataExfilApps = apps.where((a) {
      final perms = a.requestedPermissions;
      return perms.any((p) => p.contains('READ_CONTACTS') || p.contains('READ_SMS') || p.contains('READ_CALL_LOG')) &&
          perms.any((p) => p.contains('INTERNET'));
    }).toList();

    final overlayApps = apps.where((a) {
      return a.requestedPermissions.any((p) => p.contains('SYSTEM_ALERT_WINDOW'));
    }).toList();

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('Threat Analysis'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Threat Categories
              const Text(
                'THREAT VECTORS',
                style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),

              _ThreatCategory(
                icon: Icons.mic_rounded,
                title: 'Spyware Indicators',
                subtitle: 'Apps with camera + microphone + location',
                count: spywareApps.length,
                color: AppTheme.accentRed,
                apps: spywareApps.map((a) => a.appName).toList(),
              ),
              const SizedBox(height: 8),

              _ThreatCategory(
                icon: Icons.cloud_upload_rounded,
                title: 'Data Exfiltration Risk',
                subtitle: 'Apps reading contacts/SMS/calls + internet',
                count: dataExfilApps.length,
                color: const Color(0xFFFF6D00),
                apps: dataExfilApps.map((a) => a.appName).toList(),
              ),
              const SizedBox(height: 8),

              _ThreatCategory(
                icon: Icons.layers_rounded,
                title: 'Overlay Attack Surface',
                subtitle: 'Apps that can draw over other apps',
                count: overlayApps.length,
                color: AppTheme.accentAmber,
                apps: overlayApps.map((a) => a.appName).toList(),
              ),

              const SizedBox(height: 28),

              // Permission Group Heatmap
              const Text(
                'PERMISSION USAGE HEATMAP',
                style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),

              ...sortedGroups.map((group) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _PermGroupBar(group: group, totalApps: apps.length),
                  )),

              const SizedBox(height: 28),

              // Attack Surface Summary
              const Text(
                'ATTACK SURFACE SUMMARY',
                style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SummaryRow(label: 'Total permissions requested', value: '${apps.fold<int>(0, (sum, a) => sum + a.requestedPermissions.length)}'),
                    const Divider(color: AppTheme.dividerColor, height: 20),
                    _SummaryRow(label: 'Unique permission types', value: '${_countUnique(apps)}'),
                    const Divider(color: AppTheme.dividerColor, height: 20),
                    _SummaryRow(label: 'Apps with 10+ permissions', value: '${apps.where((a) => a.requestedPermissions.length >= 10).length}'),
                    const Divider(color: AppTheme.dividerColor, height: 20),
                    _SummaryRow(label: 'Average permissions per app', value: '${(apps.fold<int>(0, (s, a) => s + a.requestedPermissions.length) / apps.length).toStringAsFixed(1)}'),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  int _countUnique(List apps) {
    final allPerms = <String>{};
    for (final app in apps) {
      allPerms.addAll(app.requestedPermissions);
    }
    return allPerms.length;
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────

class _PermGroupData {
  final String group;
  final Map<String, int> permissions;
  int appCount;
  _PermGroupData({required this.group, required this.permissions, required this.appCount});
}

class _ThreatCategory extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int count;
  final Color color;
  final List<String> apps;

  const _ThreatCategory({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.color,
    required this.apps,
  });

  @override
  State<_ThreatCategory> createState() => _ThreatCategoryState();
}

class _ThreatCategoryState extends State<_ThreatCategory> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: widget.apps.isNotEmpty ? () => setState(() => _expanded = !_expanded) : null,
      borderColor: widget.count > 0 ? widget.color.withValues(alpha: 0.25) : null,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.count > 0 ? widget.color.withValues(alpha: 0.15) : AppTheme.textMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    color: widget.count > 0 ? widget.color : AppTheme.textMuted,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (_expanded && widget.apps.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppTheme.dividerColor),
            const SizedBox(height: 8),
            ...widget.apps.map((name) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: widget.color, size: 6),
                      const SizedBox(width: 10),
                      Text(name, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _PermGroupBar extends StatelessWidget {
  final _PermGroupData group;
  final int totalApps;
  const _PermGroupBar({required this.group, required this.totalApps});

  @override
  Widget build(BuildContext context) {
    final ratio = (group.appCount / (totalApps * group.permissions.length)).clamp(0.0, 1.0);
    final color = _groupColor(group.group);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(group.group, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${group.appCount} uses', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Color _groupColor(String group) {
    switch (group) {
      case 'Location':
        return const Color(0xFF448AFF);
      case 'Camera':
        return AppTheme.accentPurple;
      case 'Microphone':
        return AppTheme.accentRed;
      case 'Contacts':
        return AppTheme.accentAmber;
      case 'Phone':
        return const Color(0xFFFF6D00);
      case 'SMS':
        return AppTheme.accentRed;
      case 'Storage':
        return AppTheme.accentGreen;
      case 'Network':
        return AppTheme.accentCyan;
      case 'Special':
        return const Color(0xFFFF1744);
      default:
        return AppTheme.textMuted;
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
