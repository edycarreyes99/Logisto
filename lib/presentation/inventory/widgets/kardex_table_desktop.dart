import 'package:flutter/material.dart';
import '../../../domain/models/stock_movement_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../common/enum_localization_extensions.dart';

/// High-density desktop table rendering immutable inventory Kardex movement ledger.
class KardexTableDesktop extends StatelessWidget {
  final List<StockMovementModel> movements;

  const KardexTableDesktop({super.key, required this.movements});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (movements.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: Text(l10n.noKardexMovements)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        horizontalMargin: 8,
        columns: [
          DataColumn(label: Text(l10n.tableHeaderTimestamp)),
          DataColumn(label: Text(l10n.tableHeaderProduct)),
          DataColumn(label: Text(l10n.tableHeaderMovementType)),
          DataColumn(
            label: Text(l10n.tableHeaderQuantity),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderUnitCost),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderTotalValue),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderReferenceNotes)),
        ],
        rows: movements.map((m) => _buildRow(m, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    StockMovementModel m,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isPositive = m.quantity > 0;
    final qtyFormatted =
        '${isPositive ? "+" : ""}${l10n.unitsCount(m.quantity.toInt())}';
    final totalFormatted = '\$${m.totalCost.abs().toStringAsFixed(2)}';

    return DataRow(
      cells: [
        DataCell(
          Text(
            '${m.timestamp.year}-${m.timestamp.month.toString().padLeft(2, '0')}-${m.timestamp.day.toString().padLeft(2, '0')} ${m.timestamp.hour.toString().padLeft(2, '0')}:${m.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            m.productName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              m.movementType.localizedTitle(l10n).toUpperCase(),
              style: const TextStyle(fontSize: 11),
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(
          Text(
            qtyFormatted,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPositive ? AppColors.success : theme.colorScheme.error,
            ),
          ),
        ),
        DataCell(Text('\$${m.unitCost.toStringAsFixed(2)}')),
        DataCell(
          Text(
            totalFormatted,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(
          Text(
            m.notes ?? m.referenceId ?? 'N/A',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
