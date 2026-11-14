import 'package:flutter/material.dart';
import '../../../domain/models/customer_model.dart';
import '../../../l10n/app_localizations.dart';

/// Mobile card list for customer accounts and debt status.
class CustomerListMobile extends StatelessWidget {
  final List<CustomerModel> customers;
  final ValueChanged<CustomerModel> onEdit;

  const CustomerListMobile({
    super.key,
    required this.customers,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: customers.map((c) => _buildCard(c, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    CustomerModel c,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        title: Text(
          c.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${c.taxId} • ${c.phone}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.customerDebtAmount(c.currentDebtBalance.toStringAsFixed(2)),
              style: TextStyle(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit, size: 14),
              label: Text(l10n.edit),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () => onEdit(c),
            ),
          ],
        ),
      ),
    );
  }
}
