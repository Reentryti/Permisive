import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/guard_provider.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardProvider>(
      builder: (context, provider, _) {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              title: Text('Settings'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Defense Level Selection
                  const Text(
                    'DEFENSE LEVEL',
                    style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),

                  _DefenseLevelOption(
                    level: 1,
                    title: 'Advisory Mode',
                    subtitle: 'Analyze and warn. No restrictions applied.',
                    icon: Icons.info_outline_rounded,
                    color: AppTheme.accentGreen,
                    selected: provider.defenseLevel == 1,
                    onTap: () => provider.setDefenseLevel(1),
                    features: [
                      'Permission analysis at scan time',
                      'Risk score calculation',
                      'Warning notifications',
                      'Safe permission recommendations',
                    ],
                  ),
                  const SizedBox(height: 8),

                  _DefenseLevelOption(
                    level: 2,
                    title: 'Assisted Restriction',
                    subtitle: 'Guides you to revoke dangerous permissions.',
                    icon: Icons.tune_rounded,
                    color: AppTheme.accentAmber,
                    selected: provider.defenseLevel == 2,
                    onTap: () => provider.setDefenseLevel(2),
                    features: [
                      'Everything in Level 1',
                      'One-tap permission revocation guide',
                      'Runtime permission interception',
                      'Accessibility Service integration',
                    ],
                  ),
                  const SizedBox(height: 8),

                  _DefenseLevelOption(
                    level: 3,
                    title: 'Enforcement Mode',
                    subtitle: 'Blocks dangerous permissions at runtime.',
                    icon: Icons.lock_rounded,
                    color: AppTheme.accentRed,
                    selected: provider.defenseLevel == 3,
                    onTap: () => provider.setDefenseLevel(3),
                    isResearch: true,
                    features: [
                      'Everything in Level 2',
                      'Runtime permission blocking',
                      'Permission hook enforcement',
                      'Requires root or custom ROM',
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Scan Options
                  const Text(
                    'SCAN OPTIONS',
                    style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),

                  GlassCard(
                    child: Column(
                      children: [
                        _ToggleRow(
                          title: 'Include System Apps',
                          subtitle: 'Show pre-installed system applications',
                          value: provider.showSystemApps,
                          onChanged: (_) => provider.toggleSystemApps(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // About
                  const Text(
                    'ABOUT',
                    style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentCyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.shield_rounded, color: AppTheme.accentCyan, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PermissionGuard',
                                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'v1.0.0 — Research Prototype',
                                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Permission-based defense mechanism for Android. '
                          'Implements the Principle of Least Privilege to reduce '
                          'mobile attack surfaces and prevent overprivileged applications '
                          'from compromising user security.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.dividerColor),
                        const SizedBox(height: 12),
                        _InfoRow(label: 'Approach', value: 'Defense in Depth'),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Principle', value: 'Least Privilege'),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Context', value: 'Academic Research'),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Test Env', value: 'Waydroid / Emulator'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Threat Model
                  const Text(
                    'THREAT MODEL',
                    style: TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'In Scope',
                          style: TextStyle(color: AppTheme.accentGreen, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _ThreatRow(icon: Icons.bug_report_rounded, text: 'Spyware (contacts, SMS, mic, storage)'),
                        _ThreatRow(icon: Icons.cloud_upload_rounded, text: 'Data exfiltration via network'),
                        _ThreatRow(icon: Icons.masks_rounded, text: 'Trojans in legitimate-looking apps'),
                        _ThreatRow(icon: Icons.warning_rounded, text: 'Overprivileged applications'),
                        const SizedBox(height: 16),
                        const Text(
                          'Out of Scope',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _ThreatRow(icon: Icons.cell_tower_rounded, text: 'Baseband / modem attacks', muted: true),
                        _ThreatRow(icon: Icons.memory_rounded, text: 'Hardware level exploits', muted: true),
                        _ThreatRow(icon: Icons.developer_board_rounded, text: 'Kernel vulnerabilities', muted: true),
                        _ThreatRow(icon: Icons.shield_rounded, text: 'Zero-day framework exploits', muted: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────

class _DefenseLevelOption extends StatefulWidget {
  final int level;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final bool isResearch;
  final List<String> features;

  const _DefenseLevelOption({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
    this.isResearch = false,
    required this.features,
  });

  @override
  State<_DefenseLevelOption> createState() => _DefenseLevelOptionState();
}

class _DefenseLevelOptionState extends State<_DefenseLevelOption> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: widget.onTap,
      borderColor: widget.selected ? widget.color.withValues(alpha: 0.5) : null,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: widget.selected ? 0.2 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Level ${widget.level}',
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (widget.isResearch) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentRed.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'RESEARCH',
                              style: TextStyle(color: AppTheme.accentRed, fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(widget.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Radio<bool>(
                value: true,
                groupValue: widget.selected,
                onChanged: (_) => widget.onTap(),
                activeColor: widget.color,
              ),
            ],
          ),
          // Expand/collapse
          const SizedBox(height: 8),
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _expanded ? 'Hide features' : 'Show features',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppTheme.textMuted,
                  size: 18,
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 8),
            ...widget.features.map((f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Icon(Icons.check_rounded, color: widget.color, size: 14),
                      const SizedBox(width: 8),
                      Text(f, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.accentCyan,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ThreatRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool muted;
  const _ThreatRow({required this.icon, required this.text, this.muted = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: muted ? AppTheme.textMuted : AppTheme.accentGreen, size: 16),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: muted ? AppTheme.textMuted : AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
