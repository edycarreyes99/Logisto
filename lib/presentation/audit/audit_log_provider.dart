import 'package:flutter/foundation.dart';
import '../../core/enums/audit_action_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/audit_log_repository.dart';
import '../../domain/models/audit_log_model.dart';

/// State provider for immutable security audit logging, suspicious event detection,
/// and activity trail monitoring.
class AuditLogProvider extends ChangeNotifier {
  final AuditLogRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  List<AuditLogModel> _logs = [];
  AuditActionEnum? _selectedActionFilter;
  String _searchQuery = '';

  AuditLogProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  AuditActionEnum? get selectedActionFilter => _selectedActionFilter;
  String get searchQuery => _searchQuery;

  List<AuditLogModel> get logs => List.unmodifiable(_logs);

  List<AuditLogModel> get filteredLogs {
    return _logs.where((entry) {
      if (_selectedActionFilter != null &&
          entry.action != _selectedActionFilter) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesUser = entry.userDisplayName.toLowerCase().contains(q);
        final matchesDesc = entry.description.toLowerCase().contains(q);
        return matchesUser || matchesDesc;
      }
      return true;
    }).toList();
  }

  void setActionFilter(AuditActionEnum? action) {
    _selectedActionFilter = action;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadAuditLogs(String orgId) async {
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.getRecentLogs(orgId: orgId);
      _logs = result;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _logs = [];
      _status = FeatureStatusEnum.error;
    }
    notifyListeners();
  }

  Future<void> recordLog(AuditLogModel entry) async {
    try {
      await repository.logAction(entry);
    } catch (_) {}
    _logs = [entry, ..._logs];
    notifyListeners();
  }
}
