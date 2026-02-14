import 'package:flutter/material.dart';
import '../models/permission_models.dart';
import '../services/app_scanner_service.dart';
import '../services/risk_scoring_service.dart';

enum ScanState { idle, scanning, completed, error }

class GuardProvider extends ChangeNotifier {
  final AppScannerService _scanner = AppScannerService();
  final RiskScoringService _riskService = RiskScoringService();

  ScanState _state = ScanState.idle;
  List<ScannedApp> _scannedApps = [];
  ScanSummary? _summary;
  String? _error;
  bool _showSystemApps = false;
  String _sortBy = 'risk'; // 'risk', 'name', 'permissions'
  String _filterRisk = 'all'; // 'all', 'low', 'medium', 'high', 'critical'
  int _defenseLevel = 1; // 1 = Advisory, 2 = Assisted, 3 = Enforcement

  // ── Getters ────────────────────────────────────────────────────
  ScanState get state => _state;
  ScanSummary? get summary => _summary;
  String? get error => _error;
  int get defenseLevel => _defenseLevel;

  List<ScannedApp> get scannedApps {
    var apps = List<ScannedApp>.from(_scannedApps);

    if (!_showSystemApps) {
      apps = apps.where((a) => !a.isSystemApp).toList();
    }

    // Filter
    if (_filterRisk != 'all') {
      apps = apps.where((app) {
        switch (_filterRisk) {
          case 'low':
            return app.riskScore <= 3;
          case 'medium':
            return app.riskScore > 3 && app.riskScore <= 8;
          case 'high':
            return app.riskScore > 8 && app.riskScore <= 15;
          case 'critical':
            return app.riskScore > 15;
          default:
            return true;
        }
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'risk':
        apps.sort((a, b) => b.riskScore.compareTo(a.riskScore));
        break;
      case 'name':
        apps.sort((a, b) => a.appName.compareTo(b.appName));
        break;
      case 'permissions':
        apps.sort((a, b) => b.requestedPermissions.length.compareTo(a.requestedPermissions.length));
        break;
    }

    return apps;
  }

  String get sortBy => _sortBy;
  String get filterRisk => _filterRisk;
  bool get showSystemApps => _showSystemApps;

  // ── Actions ────────────────────────────────────────────────────
  Future<void> startScan() async {
    _state = ScanState.scanning;
    _error = null;
    notifyListeners();

    try {
      // Simulate scan time for better UX
      await Future.delayed(const Duration(milliseconds: 1500));
      _scannedApps = await _scanner.scanInstalledApps();
      _summary = _riskService.generateSummary(_scannedApps);
      _state = ScanState.completed;
    } catch (e) {
      _error = e.toString();
      _state = ScanState.error;
    }
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void setFilterRisk(String filter) {
    _filterRisk = filter;
    notifyListeners();
  }

  void toggleSystemApps() {
    _showSystemApps = !_showSystemApps;
    notifyListeners();
  }

  void setDefenseLevel(int level) {
    _defenseLevel = level.clamp(1, 3);
    notifyListeners();
  }
}
