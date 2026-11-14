import 'package:flutter/foundation.dart';
import '../../core/enums/account_status_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/table_status_enum.dart';
import '../../data/repositories/billiard_table_repository.dart';
import '../../data/repositories/open_account_repository.dart';
import '../../domain/models/billiard_table_model.dart';
import '../../domain/models/open_account_model.dart';
import '../../domain/services/billiard_rate_calculator.dart';

/// State provider for billiard tables, rental session timers,
/// rate calculations, and table transfers.
class BilliardProvider extends ChangeNotifier {
  final BilliardTableRepository repository;
  final BilliardRateCalculator rateCalculator;
  final OpenAccountRepository? openAccountRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<BilliardTableModel> _tables = [];

  BilliardProvider({
    required this.repository,
    required this.rateCalculator,
    this.openAccountRepository,
  });

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<BilliardTableModel> get tables => List.unmodifiable(_tables);

  Future<void> loadTables({required String orgId, required String buId}) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await repository.getTables(orgId: orgId, buId: buId);
      _tables = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveTable({
    required String orgId,
    required String buId,
    required BilliardTableModel table,
  }) async {
    final idx = _tables.indexWhere((t) => t.id == table.id);
    if (idx != -1) {
      _tables[idx] = table;
    } else {
      _tables = [..._tables, table];
    }
    try {
      await repository.saveTable(orgId: orgId, buId: buId, table: table);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> deleteTable({
    required String orgId,
    required String buId,
    required String tableId,
  }) async {
    try {
      await repository.deleteTable(orgId: orgId, buId: buId, tableId: tableId);
    } catch (_) {}
    _tables = _tables.where((t) => t.id != tableId).toList();
    notifyListeners();
  }

  double calculateCurrentCharge(BilliardTableModel table) {
    if (table.currentSession == null) return 0.0;
    final now = DateTime.now();
    final elapsedSec = table.currentSession!.isPaused
        ? table.currentSession!.accumulatedSeconds
        : table.currentSession!.accumulatedSeconds +
              now.difference(table.currentSession!.startTime).inSeconds;

    return rateCalculator.calculateCharge(
      table: table,
      elapsedSeconds: elapsedSec,
    );
  }

  Future<void> startSession({
    required String tableId,
    required String customerName,
  }) async {
    final idx = _tables.indexWhere((t) => t.id == tableId);
    if (idx == -1) return;

    final session = BilliardSessionModel(
      sessionId: 'ses_${DateTime.now().millisecondsSinceEpoch}',
      customerName: customerName.isEmpty ? 'Cliente Mostrador' : customerName,
      startTime: DateTime.now(),
      accumulatedSeconds: 0,
      isPaused: false,
    );

    _tables[idx] = _tables[idx].copyWith(
      status: TableStatusEnum.occupied,
      currentSession: session,
    );
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.saveTable(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          table: _tables[idx],
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> pauseSession(String tableId) async {
    final idx = _tables.indexWhere((t) => t.id == tableId);
    if (idx == -1) return;

    final table = _tables[idx];
    if (table.currentSession == null) return;

    final additional = DateTime.now()
        .difference(table.currentSession!.startTime)
        .inSeconds;
    final updatedSession = table.currentSession!.copyWith(
      isPaused: true,
      pausedAt: DateTime.now(),
      accumulatedSeconds: table.currentSession!.accumulatedSeconds + additional,
    );

    _tables[idx] = table.copyWith(
      status: TableStatusEnum.paused,
      currentSession: updatedSession,
    );
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.saveTable(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          table: _tables[idx],
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> resumeSession(String tableId) async {
    final idx = _tables.indexWhere((t) => t.id == tableId);
    if (idx == -1) return;

    final table = _tables[idx];
    if (table.currentSession == null) return;

    final updatedSession = table.currentSession!.copyWith(
      isPaused: false,
      startTime: DateTime.now(),
    );

    _tables[idx] = table.copyWith(
      status: TableStatusEnum.occupied,
      currentSession: updatedSession,
    );
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.saveTable(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          table: _tables[idx],
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> stopSession(String tableId) async {
    final idx = _tables.indexWhere((t) => t.id == tableId);
    if (idx == -1) return;

    final table = _tables[idx];
    final charge = calculateCurrentCharge(table);

    // Transfer accrued billiard charge to Open Account / Bar Tab (Module 5 & 6)
    if (charge > 0 &&
        openAccountRepository != null &&
        _activeOrgId != null &&
        _activeBuId != null) {
      final billiardItem = AccountItemModel(
        productId: 'srv_billiard_${table.id}',
        name: 'Tiempo Billar (${table.name})',
        quantity: 1,
        unitPrice: charge,
        total: charge,
        isBilliardTime: true,
      );

      final associatedTabId = table.currentSession?.associatedAccountId;
      if (associatedTabId != null) {
        try {
          await openAccountRepository!.addItemToAccount(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            accountId: associatedTabId,
            item: billiardItem,
          );
        } catch (_) {}
      } else {
        final newTab = OpenAccountModel(
          id: 'tab_${DateTime.now().millisecondsSinceEpoch}',
          code: 'TAB-${table.tableNumber}',
          originType: 'table',
          tableId: table.id,
          tableName: table.name,
          customerDisplayName:
              table.currentSession?.customerName ?? 'Mesa ${table.tableNumber}',
          status: AccountStatusEnum.open,
          items: [billiardItem],
          totalAmount: charge,
          openedAt: DateTime.now(),
        );
        try {
          await openAccountRepository!.saveAccount(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            account: newTab,
          );
        } catch (_) {}
      }
    }

    _tables[idx] = BilliardTableModel(
      id: _tables[idx].id,
      tableNumber: _tables[idx].tableNumber,
      name: _tables[idx].name,
      tableType: _tables[idx].tableType,
      hourlyRate: _tables[idx].hourlyRate,
      minimumMinutes: _tables[idx].minimumMinutes,
      graceMinutes: _tables[idx].graceMinutes,
      status: TableStatusEnum.available,
      currentSession: null,
    );
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.saveTable(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          table: _tables[idx],
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> transferTable({
    required String fromTableId,
    required String toTableId,
  }) async {
    final fromIdx = _tables.indexWhere((t) => t.id == fromTableId);
    final toIdx = _tables.indexWhere((t) => t.id == toTableId);
    if (fromIdx == -1 || toIdx == -1) return;

    final session = _tables[fromIdx].currentSession;
    if (session == null) return;
    if (_tables[toIdx].status != TableStatusEnum.available) return;

    _tables[toIdx] = _tables[toIdx].copyWith(
      status: TableStatusEnum.occupied,
      currentSession: session,
    );

    _tables[fromIdx] = BilliardTableModel(
      id: _tables[fromIdx].id,
      tableNumber: _tables[fromIdx].tableNumber,
      name: _tables[fromIdx].name,
      tableType: _tables[fromIdx].tableType,
      hourlyRate: _tables[fromIdx].hourlyRate,
      minimumMinutes: _tables[fromIdx].minimumMinutes,
      graceMinutes: _tables[fromIdx].graceMinutes,
      status: TableStatusEnum.available,
      currentSession: null,
    );
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.saveTable(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          table: _tables[toIdx],
        );
        await repository.saveTable(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          table: _tables[fromIdx],
        );

        if (session.associatedAccountId != null &&
            openAccountRepository != null) {
          final tab = await openAccountRepository!.getAccountById(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            accountId: session.associatedAccountId!,
          );
          if (tab != null) {
            await openAccountRepository!.saveAccount(
              orgId: _activeOrgId!,
              buId: _activeBuId!,
              account: tab.copyWith(
                tableId: _tables[toIdx].id,
                tableName: _tables[toIdx].name,
              ),
            );
          }
        }
      } catch (_) {}
    }
    notifyListeners();
  }
}
