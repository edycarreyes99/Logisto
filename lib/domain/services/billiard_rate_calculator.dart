import '../models/billiard_table_model.dart';

/// Pure domain service calculating exact billiard rental usage charges and rate conversions.
class BilliardRateCalculator {
  const BilliardRateCalculator();

  /// Calculates the payable charge in dollars based on accumulated seconds and table rules.
  ///
  /// - If [elapsedSeconds] is within [table.graceMinutes], the charge is 0.0.
  /// - If [elapsedSeconds] exceeds grace period but is less than [table.minimumMinutes],
  ///   the minimum fraction fee is charged.
  /// - Otherwise, exact pro-rated seconds are charged based on [table.hourlyRate] / 3600.
  double calculateCharge({
    required BilliardTableModel table,
    required int elapsedSeconds,
  }) {
    if (elapsedSeconds <= 0) return 0.0;

    final elapsedMinutes = elapsedSeconds / 60.0;

    // Grace period check: Free if stopped within grace minutes
    if (elapsedMinutes < table.graceMinutes) {
      return 0.0;
    }

    // Minimum charge check: Charge at least minimumMinutes
    if (elapsedMinutes < table.minimumMinutes) {
      final minHours = table.minimumMinutes / 60.0;
      final charge = minHours * table.hourlyRate;
      return double.parse(charge.toStringAsFixed(2));
    }

    // Exact proportional second calculation
    final exactHours = elapsedSeconds / 3600.0;
    final charge = exactHours * table.hourlyRate;
    return double.parse(charge.toStringAsFixed(2));
  }

  /// Recomputes accumulated charge when moving players from [sourceTable] to [targetTable].
  /// Preserves elapsed time and recalculates based on new table's rate and rules.
  double calculateTransferCharge({
    required BilliardTableModel sourceTable,
    required BilliardTableModel targetTable,
    required int elapsedSeconds,
  }) {
    return calculateCharge(table: targetTable, elapsedSeconds: elapsedSeconds);
  }

  /// Calculates combined charge when time was split across tables:
  /// [sourceSeconds] played on [sourceTable], plus [targetSeconds] played on [targetTable].
  double calculateSplitTransferCharge({
    required BilliardTableModel sourceTable,
    required int sourceSeconds,
    required BilliardTableModel targetTable,
    required int targetSeconds,
  }) {
    final sourceCharge = calculateCharge(
      table: sourceTable,
      elapsedSeconds: sourceSeconds,
    );
    final targetCharge = calculateCharge(
      table: targetTable,
      elapsedSeconds: targetSeconds,
    );
    return double.parse((sourceCharge + targetCharge).toStringAsFixed(2));
  }
}
