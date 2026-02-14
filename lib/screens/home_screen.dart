import 'package:flutter/material.dart';
import '../theme.dart';
import 'dashboard_screen.dart';
import 'app_list_screen.dart';
import 'threat_map_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    AppListScreen(),
    ThreatMapScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.dividerColor, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          height: 68,
          destinations: [
            _buildDestination(Icons.shield_rounded, 'Dashboard', 0),
            _buildDestination(Icons.apps_rounded, 'Apps', 1),
            _buildDestination(Icons.radar_rounded, 'Threats', 2),
            _buildDestination(Icons.tune_rounded, 'Settings', 3),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildDestination(IconData icon, String label, int index) {
    final selected = _currentIndex == index;
    return NavigationDestination(
      icon: Icon(icon, color: selected ? AppTheme.accentCyan : AppTheme.textMuted, size: 24),
      selectedIcon: Icon(icon, color: AppTheme.accentCyan, size: 24),
      label: label,
    );
  }
}
