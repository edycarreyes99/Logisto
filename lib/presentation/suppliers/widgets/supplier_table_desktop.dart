import 'package:flutter/material.dart';
import '../../../domain/models/supplier_model.dart';
import '../../../l10n/app_localizations.dart';

/// High-density desktop table presenting commercial supplier accounts.
class SupplierTableDesktop extends StatelessWidget {
  final List<SupplierModel> suppliers;
  final ValueChanged<SupplierModel> onEdit;

  const SupplierTableDesktop({
    super.key,
    required this.suppliers,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.tableHeaderCompanyName)),
          DataColumn(label: Text(l10n.tableHeaderRucTaxId)),
          DataColumn(label: Text(l10n.tableHeaderContactPerson)),
          DataColumn(label: Text(l10n.tableHeaderPhone)),
          DataColumn(label: Text(l10n.tableHeaderCreditTerms)),
          DataColumn(
            label: Text(l10n.tableHeaderPayableBalance),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: suppliers.map((s) => _buildRow(l10n, s, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    AppLocalizations l10n,
    SupplierModel s,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return DataRow(
      cells: [
        DataCell(
          Text(
            s.companyName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(Text(s.taxId, style: const TextStyle(fontSize: 12))),
        DataCell(Text(s.contactPerson)),
        DataCell(Text(s.phone)),
        DataCell(
          Chip(
            label: Text(
              l10n.daysCount(s.creditDays),
              style: const TextStyle(fontSize: 11),
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(
          Text(
            '\$${s.currentPayableBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
        ),
        DataCell(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => onEdit(s),
            child: Text(l10n.edit),
          ),
        ),
      ],
    );
  }
}
