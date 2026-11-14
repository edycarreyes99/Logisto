import 'package:flutter/material.dart';
import '../../../core/enums/invoice_status_enum.dart';
import '../../../domain/models/invoice_model.dart';
import '../../../l10n/app_localizations.dart';

/// Mobile card list for sales invoice history.
class InvoiceListMobile extends StatelessWidget {
  final List<InvoiceModel> invoices;
  final ValueChanged<InvoiceModel> onView;

  const InvoiceListMobile({
    super.key,
    required this.invoices,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: invoices.map((inv) => _buildCard(inv, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    InvoiceModel inv,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isVoid = inv.status == InvoiceStatusEnum.cancelled;
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        onTap: () => onView(inv),
        title: Text(
          inv.invoiceNumber,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          inv.customerDisplayName,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${inv.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text(
                isVoid
                    ? l10n.cancelled.toUpperCase()
                    : l10n.paid.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
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
          ],
        ),
      ),
    );
  }
}
