import '../../core/enums/shift_status_enum.dart';

/// Calculation result produced by blind drop reconciliation.
class ShiftReconciliationResult {
  final double expectedBalance;
  final double actualCounted;
  final double difference;
  final ShiftDiscrepancyEnum discrepancyStatus;

  const ShiftReconciliationResult({
    required this.expectedBalance,
    required this.actualCounted,
    required this.difference,
    required this.discrepancyStatus,
  });
}

/// Pure domain service calculating cash drawer expected balances and blind drop variances.
class CashShiftCalculator {
  const CashShiftCalculator();

  /// Reconciles physical cash count against mathematically expected shift balance.
  ShiftReconciliationResult reconcileBlindDrop({
    required double openingBalance,
    required double cashSales,
    required double cashInjections,
    required double cashWithdrawals,
    required double actualCashCounted,
  }) {
    final expected =
        openingBalance + cashSales + cashInjections - cashWithdrawals;
    final diff = actualCashCounted - expected;
    final roundedDiff = double.parse(diff.toStringAsFixed(2));

    final ShiftDiscrepancyEnum discrepancy;
    if (roundedDiff.abs() < 0.01) {
      discrepancy = ShiftDiscrepancyEnum.balanced;
    } else if (roundedDiff < 0) {
      discrepancy = ShiftDiscrepancyEnum.shortage;
    } else {
      discrepancy = ShiftDiscrepancyEnum.surplus;
    }

    return ShiftReconciliationResult(
      expectedBalance: double.parse(expected.toStringAsFixed(2)),
      actualCounted: actualCashCounted,
      difference: roundedDiff,
      discrepancyStatus: discrepancy,
    );
  }
}
