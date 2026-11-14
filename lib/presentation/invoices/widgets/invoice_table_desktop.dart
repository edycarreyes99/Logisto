import 'package:flutter/material.dart';
import '../../../core/enums/invoice_status_enum.dart';
import '../../../domain/models/invoice_model.dart';
import '../../../l10n/app_localizations.dart';

/// High-density desktop table presenting historical invoices.
class InvoiceTableDesktop extends StatelessWidget {
  final List<InvoiceModel> invoices;
  final ValueChanged<InvoiceModel> onView;
  final ValueChanged<String> onVoid;

  const InvoiceTableDesktop({
    super.key,
    required this.invoices,
    required this.onView,
    required this.onVoid,
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
          DataColumn(label: Text(l10n.tableHeaderInvoiceNumber)),
          DataColumn(label: Text(l10n.tableHeaderCustomer)),
          DataColumn(label: Text(l10n.tableHeaderCashier)),
          DataColumn(
            label: Text(l10n.tableHeaderTotalAmount),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderStatus)),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: invoices.map((inv) => _buildRow(inv, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    InvoiceModel inv,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isVoid = inv.status == InvoiceStatusEnum.cancelled;
    return DataRow(
      cells: [
        DataCell(
          Text(
            inv.invoiceNumber,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          SizedBox(
            width: 130,
            child: Text(
              inv.customerDisplayName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(inv.cashierUserId)),
        DataCell(
          Text(
            '\$${inv.totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              isVoid ? l10n.cancelled.toUpperCase() : l10n.paid.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: isVoid
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            backgroundColor: isVoid
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
                onPressed: () => onView(inv),
                child: Text(l10n.view),
              ),
              if (!isVoid) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: () => onVoid(inv.id),
                  child: Text(l10n.voidAction),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
