import 'package:flutter/material.dart';
import '../../../core/enums/purchase_order_status_enum.dart';
import '../../../domain/models/purchase_order_model.dart';
import '../../../l10n/app_localizations.dart';

/// High-density desktop table for inbound purchase orders.
class PurchaseOrderTableDesktop extends StatelessWidget {
  final List<PurchaseOrderModel> orders;
  final ValueChanged<String> onReceive;

  const PurchaseOrderTableDesktop({
    super.key,
    required this.orders,
    required this.onReceive,
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
          DataColumn(label: Text(l10n.tableHeaderOrderRef)),
          DataColumn(label: Text(l10n.tableHeaderSupplier)),
          DataColumn(label: Text(l10n.tableHeaderOrderDate)),
          DataColumn(label: Text(l10n.tableHeaderTotalValue), numeric: true),
          DataColumn(label: Text(l10n.tableHeaderStatus)),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: orders.map((po) => _buildRow(po, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    PurchaseOrderModel po,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isReceived = po.status == PurchaseOrderStatusEnum.received;
    return DataRow(
      cells: [
        DataCell(
          Text(po.id, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(
            po.supplierName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(Text(po.orderDate.toString().split(' ').first)),
        DataCell(
          Text(
            '\$${po.totalCost.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              isReceived ? l10n.statusReceived : l10n.statusPending,
              style: TextStyle(
                fontSize: 11,
                color: isReceived
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onTertiaryContainer,
              ),
            ),
            backgroundColor: isReceived
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.tertiaryContainer,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(
          !isReceived
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => onReceive(po.id),
                  child: Text(l10n.receive),
                )
              : Text(
                  l10n.delivered,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
        ),
      ],
    );
  }
}
