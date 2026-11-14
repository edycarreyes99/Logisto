import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// High-density desktop stock matrix for physical warehouse inventory.
class WarehouseStockTableDesktop extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final ValueChanged<Map<String, dynamic>> onTransfer;
  final ValueChanged<Map<String, dynamic>> onAdjust;

  const WarehouseStockTableDesktop({
    super.key,
    required this.items,
    required this.onTransfer,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        horizontalMargin: 8,
        columns: [
          DataColumn(label: Text(l10n.tableHeaderSku)),
          DataColumn(label: Text(l10n.tableHeaderProductItem)),
          DataColumn(
            label: Text(l10n.tableHeaderAvailableStock),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderReserved),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderMinStock),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderStatus)),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: items.map((item) => _buildRow(item, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    Map<String, dynamic> item,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isLow = item['isLowStock'] as bool;
    final current = item['currentQuantity'] as double;
    final reserved = item['reservedQuantity'] as double;
    return DataRow(
      cells: [
        DataCell(Text(item['sku'] as String)),
        DataCell(
          SizedBox(
            width: 140,
            child: Text(
              item['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(
            l10n.unitsCount((current - reserved).toInt()),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(l10n.unitsCount(reserved.toInt()))),
        DataCell(
          Text(l10n.unitsCount((item['minStock'] as double).toInt())),
        ),
        DataCell(
          Chip(
            label: Text(
              isLow ? l10n.stockStatusLow : l10n.stockStatusOptimal,
              style: TextStyle(
                fontSize: 11,
                color: isLow
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            backgroundColor: isLow
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => onTransfer(item),
                child: Text(l10n.transfer),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => onAdjust(item),
                child: Text(l10n.adjust),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
