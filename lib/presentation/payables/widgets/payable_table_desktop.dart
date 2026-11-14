import 'package:flutter/material.dart';
import '../../../domain/models/account_payable_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// High-density desktop table presenting accounts payable (CxP) supplier obligations.
class PayableTableDesktop extends StatelessWidget {
  final List<AccountPayableModel> payables;
  final ValueChanged<AccountPayableModel> onPay;

  const PayableTableDesktop({
    super.key,
    required this.payables,
    required this.onPay,
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
          DataColumn(label: Text(l10n.tableHeaderSupplier)),
          DataColumn(
            label: Text(l10n.tableHeaderSupplierInvoiceNumber),
          ),
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
            label: Text(l10n.tableHeaderPayableBalance),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: payables.map((p) => _buildRow(p, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    AccountPayableModel p,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isSettled = p.isSettled;
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 130,
            child: Text(
              p.supplierName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(p.invoiceNumber)),
        DataCell(Text(p.dueDate.toString().split(' ').first)),
        DataCell(Text('\$${p.amount.toStringAsFixed(2)}')),
        DataCell(Text('\$${p.paidAmount.toStringAsFixed(2)}')),
        DataCell(
          Text(
            '\$${p.remainingBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSettled
                  ? AppColors.success
                  : theme.colorScheme.error,
            ),
          ),
        ),
        DataCell(
          !isSettled
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => onPay(p),
                  child: Text(l10n.pay),
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
