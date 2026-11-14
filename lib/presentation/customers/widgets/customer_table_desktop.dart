import 'package:flutter/material.dart';
import '../../../domain/models/customer_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// High-density desktop table presenting customer accounts, credit headroom, and debt balance.
class CustomerTableDesktop extends StatelessWidget {
  final List<CustomerModel> customers;
  final ValueChanged<CustomerModel> onEdit;
  final ValueChanged<String> onToggleBlock;

  const CustomerTableDesktop({
    super.key,
    required this.customers,
    required this.onEdit,
    required this.onToggleBlock,
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
          DataColumn(label: Text(l10n.tableHeaderTaxId)),
          DataColumn(label: Text(l10n.tableHeaderCustomerName)),
          DataColumn(label: Text(l10n.phone)),
          DataColumn(
            label: Text(l10n.creditLimit),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.currentDebt),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.tableHeaderAvailableHeadroom),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderStatus)),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: customers.map((c) => _buildRow(c, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    CustomerModel c,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return DataRow(
      cells: [
        DataCell(Text(c.taxId, style: const TextStyle(fontSize: 12))),
        DataCell(
          SizedBox(
            width: 130,
            child: Text(
              c.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(c.phone)),
        DataCell(Text('\$${c.creditLimit.toStringAsFixed(2)}')),
        DataCell(
          Text(
            '\$${c.currentDebtBalance.toStringAsFixed(2)}',
            style: TextStyle(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataCell(
          Text(
            '\$${c.availableCredit.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              c.isCreditBlocked
                  ? l10n.creditBlockedStatus
                  : l10n.creditActiveStatus,
              style: const TextStyle(fontSize: 11),
            ),
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
                onPressed: () => onEdit(c),
                child: Text(l10n.edit),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: c.isCreditBlocked
                      ? AppColors.success
                      : theme.colorScheme.error,
                ),
                onPressed: () => onToggleBlock(c.id),
                child: Text(c.isCreditBlocked ? l10n.unblock : l10n.block),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
