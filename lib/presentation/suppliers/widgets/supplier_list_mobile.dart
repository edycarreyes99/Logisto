import 'package:flutter/material.dart';
import '../../../domain/models/supplier_model.dart';
import '../../../l10n/app_localizations.dart';

/// Mobile card list for commercial suppliers.
class SupplierListMobile extends StatelessWidget {
  final List<SupplierModel> suppliers;
  final ValueChanged<SupplierModel> onEdit;

  const SupplierListMobile({
    super.key,
    required this.suppliers,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: suppliers.map((s) => _buildCard(s, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    SupplierModel s,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        title: Text(
          s.companyName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${s.contactPerson} • ${s.phone}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.supplierDueAmount(
                s.currentPayableBalance.toStringAsFixed(2),
              ),
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
              onPressed: () => onEdit(s),
            ),
          ],
        ),
      ),
    );
  }
}
