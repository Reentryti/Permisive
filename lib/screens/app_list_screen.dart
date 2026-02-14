import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/permission_models.dart';
import '../services/guard_provider.dart';
import '../widgets/glass_card.dart';
import 'app_detail_screen.dart';

class AppListScreen extends StatelessWidget {
  const AppListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardProvider>(
      builder: (context, provider, _) {
        if (provider.state != ScanState.completed) {
          return _buildEmptyState(context, provider);
        }
        return _buildAppList(context, provider);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, GuardProvider provider) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apps_rounded, size: 64, color: AppTheme.textMuted.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            const Text(
              'No scan data available',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Run a scan from the Dashboard first',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppList(BuildContext context, GuardProvider provider) {
    final apps = provider.scannedApps;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Applications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort_rounded, size: 22),
              onPressed: () => _showSortSheet(context, provider),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list_rounded, size: 22),
              onPressed: () => _showFilterSheet(context, provider),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // Active filters chip
        if (provider.filterRisk != 'all')
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(
                      'Risk: ${provider.filterRisk.toUpperCase()}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.accentCyan),
                    ),
                    backgroundColor: AppTheme.accentCyan.withValues(alpha: 0.1),
                    deleteIcon: const Icon(Icons.close, size: 16, color: AppTheme.accentCyan),
                    onDeleted: () => provider.setFilterRisk('all'),
                    side: BorderSide(color: AppTheme.accentCyan.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ],
              ),
            ),
          ),

        // App count
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              '${apps.length} application${apps.length == 1 ? '' : 's'}',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          ),
        ),

        // App list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final app = apps[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _AppListTile(
                    app: app,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AppDetailScreen(app: app)),
                      );
                    },
                  ),
                );
              },
              childCount: apps.length,
            ),
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }

  void _showSortSheet(BuildContext context, GuardProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            _SortOption(label: 'Risk Score (High → Low)', value: 'risk', current: provider.sortBy, onTap: () { provider.setSortBy('risk'); Navigator.pop(context); }),
            _SortOption(label: 'Name (A → Z)', value: 'name', current: provider.sortBy, onTap: () { provider.setSortBy('name'); Navigator.pop(context); }),
            _SortOption(label: 'Permissions Count', value: 'permissions', current: provider.sortBy, onTap: () { provider.setSortBy('permissions'); Navigator.pop(context); }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, GuardProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter by Risk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            _SortOption(label: 'All Apps', value: 'all', current: provider.filterRisk, onTap: () { provider.setFilterRisk('all'); Navigator.pop(context); }),
            _SortOption(label: 'Low Risk', value: 'low', current: provider.filterRisk, color: AppTheme.accentGreen, onTap: () { provider.setFilterRisk('low'); Navigator.pop(context); }),
            _SortOption(label: 'Medium Risk', value: 'medium', current: provider.filterRisk, color: AppTheme.accentAmber, onTap: () { provider.setFilterRisk('medium'); Navigator.pop(context); }),
            _SortOption(label: 'High Risk', value: 'high', current: provider.filterRisk, color: const Color(0xFFFF6D00), onTap: () { provider.setFilterRisk('high'); Navigator.pop(context); }),
            _SortOption(label: 'Critical Risk', value: 'critical', current: provider.filterRisk, color: AppTheme.accentRed, onTap: () { provider.setFilterRisk('critical'); Navigator.pop(context); }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────

class _AppListTile extends StatelessWidget {
  final ScannedApp app;
  final VoidCallback onTap;

  const _AppListTile({required this.app, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.riskColor(app.riskScore);
    final riskLabel = AppTheme.riskLabel(app.riskScore);
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          // App icon placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                app.appName.isNotEmpty ? app.appName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // App info
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${app.categoryName ?? "Unknown"} · ${app.requestedPermissions.length} perms',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                if (app.dangerousPermCount > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: color, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${app.dangerousPermCount} issue${app.dangerousPermCount > 1 ? 's' : ''} found',
                        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Risk badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  riskLabel,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                app.riskScore.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted.withValues(alpha: 0.5), size: 20),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final VoidCallback onTap;
  final Color? color;

  const _SortOption({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            if (color != null) ...[
              Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? AppTheme.accentCyan : AppTheme.textSecondary,
                fontSize: 15,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_rounded, color: AppTheme.accentCyan, size: 20),
          ],
        ),
      ),
    );
  }
}
