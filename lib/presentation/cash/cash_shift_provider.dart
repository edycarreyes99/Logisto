import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/shift_status_enum.dart';
import '../../data/repositories/cash_shift_repository.dart';
import '../../domain/models/cash_shift_model.dart';
import '../../domain/services/cash_shift_calculator.dart';

/// State provider managing cashier shifts, blind drop closures,
/// cash movements (sangrías / injections), and reconciliation variances.
class CashShiftProvider extends ChangeNotifier {
  final CashShiftRepository repository;
  final CashShiftCalculator calculator;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  CashShiftModel? _activeShift;
  List<CashShiftModel> _pastShifts = [];

  CashShiftProvider({required this.repository, required this.calculator});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  CashShiftModel? get activeShift => _activeShift;
  List<CashShiftModel> get pastShifts => List.unmodifiable(_pastShifts);
  bool get hasActiveShift =>
      _activeShift != null && _activeShift!.status == ShiftStatusEnum.open;

  Future<void> loadShifts({required String orgId, required String buId}) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await repository.getShifts(orgId: orgId, buId: buId);
      _pastShifts = fetched
          .where((s) => s.status == ShiftStatusEnum.closed)
          .toList();
      final openList = fetched.where((s) => s.status == ShiftStatusEnum.open);
      _activeShift = openList.isNotEmpty ? openList.first : null;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _activeShift = null;
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> openNewShift({
    String? orgId,
    required String buId,
    required int registerNumber,
    required double openingBalance,
    required String cashierId,
    String? cashierName,
  }) async {
    final effectiveBu = buId.isNotEmpty ? buId : (_activeBuId ?? 'bu_default');
    final shift = CashShiftModel(
      id: 'shift_${DateTime.now().millisecondsSinceEpoch}',
      buId: effectiveBu,
      cashRegisterNumber: registerNumber,
      cashierUserId: cashierId,
      openedAt: DateTime.now(),
      openingBalance: openingBalance,
      expectedCashBalance: openingBalance,
      status: ShiftStatusEnum.open,
    );

    _activeShift = shift;
    final effectiveOrg = orgId ?? _activeOrgId;
    if (effectiveOrg != null) {
      try {
        await repository.openShift(
          orgId: effectiveOrg,
          buId: effectiveBu,
          shift: shift,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> recordCashMovement({
    required double amount,
    required bool isWithdrawal,
  }) async {
    if (_activeShift == null) return;

    final updated = _activeShift!.copyWith(
      cashWithdrawals: isWithdrawal
          ? _activeShift!.cashWithdrawals + amount
          : _activeShift!.cashWithdrawals,
      cashInjections: !isWithdrawal
          ? _activeShift!.cashInjections + amount
          : _activeShift!.cashInjections,
      expectedCashBalance: isWithdrawal
          ? _activeShift!.expectedCashBalance - amount
          : _activeShift!.expectedCashBalance + amount,
    );

    _activeShift = updated;
    if (_activeOrgId != null) {
      try {
        await repository.updateShift(
          orgId: _activeOrgId!,
          buId: updated.buId,
          shift: updated,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> recordSale({
    required double cashAmount,
    required double cardAmount,
    required double creditAmount,
  }) async {
    if (_activeShift == null) return;

    final updated = _activeShift!.copyWith(
      cashSales: _activeShift!.cashSales + cashAmount,
      cardSales: _activeShift!.cardSales + cardAmount,
      creditSales: _activeShift!.creditSales + creditAmount,
      expectedCashBalance: _activeShift!.expectedCashBalance + cashAmount,
    );

    _activeShift = updated;
    if (_activeOrgId != null) {
      try {
        await repository.updateShift(
          orgId: _activeOrgId!,
          buId: updated.buId,
          shift: updated,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<ShiftReconciliationResult?> closeShiftBlindDrop({
    required double actualCounted,
    String? supervisorId,
    String? orgId,
  }) async {
    if (_activeShift == null) return null;

    final recon = calculator.reconcileBlindDrop(
      openingBalance: _activeShift!.openingBalance,
      cashSales: _activeShift!.cashSales,
      cashInjections: _activeShift!.cashInjections,
      cashWithdrawals: _activeShift!.cashWithdrawals,
      actualCashCounted: actualCounted,
    );

    final closed = _activeShift!.copyWith(
      closedAt: DateTime.now(),
      actualCashCounted: actualCounted,
      difference: recon.difference,
      discrepancyStatus: recon.discrepancyStatus,
      status: ShiftStatusEnum.closed,
      supervisorApprovalUserId: supervisorId,
    );

    _pastShifts = [closed, ..._pastShifts];
    final buId = _activeShift!.buId;
    _activeShift = null;

    final effectiveOrg = orgId ?? _activeOrgId;
    if (effectiveOrg != null) {
      try {
        await repository.closeShift(
          orgId: effectiveOrg,
          buId: buId,
          closedShift: closed,
        );
      } catch (_) {}
    }

    notifyListeners();
    return recon;
  }
}
