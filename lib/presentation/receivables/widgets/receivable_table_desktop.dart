import 'package:flutter/material.dart';
import '../../../domain/models/account_receivable_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// High-density desktop table presenting accounts receivable (CxC) balances and overdue flags.
class ReceivableTableDesktop extends StatelessWidget {
  final List<AccountReceivableModel> receivables;
  final ValueChanged<AccountReceivableModel> onCollect;

  const ReceivableTableDesktop({
    super.key,
    required this.receivables,
    required this.onCollect,
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
          DataColumn(label: Text(l10n.tableHeaderCustomerName)),
          DataColumn(label: Text(l10n.tableHeaderDueDate)),
          DataColumn(
            label: Text(l10n.tableHeaderTotalDebt),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderPaidToDate),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderBalanceDue),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: receivables.map((r) => _buildRow(l10n, r, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    AppLocalizations l10n,
    AccountReceivableModel r,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isOverdue = r.isOverdue;
    final isPaid = r.isPaid;
    return DataRow(
      cells: [
        DataCell(
          Text(
            r.invoiceNumber,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          SizedBox(
            width: 130,
            child: Text(
              r.customerName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(r.dueDate.toString().split(' ').first)),
        DataCell(Text('\$${r.totalAmount.toStringAsFixed(2)}')),
        DataCell(Text('\$${r.paidAmount.toStringAsFixed(2)}')),
        DataCell(
          Text(
            '\$${r.balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPaid
                  ? AppColors.success
                  : (isOverdue ? theme.colorScheme.error : AppColors.warning),
            ),
          ),
        ),
        DataCell(
          !isPaid
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => onCollect(r),
                  child: Text(l10n.collect),
                )
              : Chip(
                  label: Text(
                    l10n.settled,
                    style: const TextStyle(fontSize: 11),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
        ),
      ],
    );
  }
}
