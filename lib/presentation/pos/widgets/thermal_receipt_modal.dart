import 'package:flutter/material.dart';
import '../../../domain/models/invoice_model.dart';
import '../../../l10n/app_localizations.dart';

/// Simulated 80mm ESC/POS thermal receipt modal for sales and billing verification.
class ThermalReceiptModal extends StatelessWidget {
  final InvoiceModel invoice;
  final String organizationName;
  final String branchName;
  final VoidCallback onNewSale;

  const ThermalReceiptModal({
    super.key,
    required this.invoice,
    required this.organizationName,
    required this.branchName,
    required this.onNewSale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: _buildTitle(l10n),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: _buildReceiptContent(l10n),
          ),
        ),
      ),
      actions: _buildActions(context, l10n),
    );
  }

  Widget _buildTitle(AppLocalizations l10n) {
    return Row(
      children: [
        const Icon(Icons.receipt_long),
        const SizedBox(width: 8),
        Text(
          l10n.salesReceipt,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, AppLocalizations l10n) {
    return [
      OutlinedButton.icon(
        icon: const Icon(Icons.print, size: 18),
        label: Text(l10n.printAction),
        onPressed: () => Navigator.of(context).pop(),
      ),
      FilledButton.icon(
        icon: const Icon(Icons.add_shopping_cart, size: 18),
        label: Text(l10n.newSaleAction),
        onPressed: () {
          Navigator.of(context).pop();
          onNewSale();
        },
      ),
    ];
  }

  Widget _buildReceiptContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            organizationName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Center(
          child: Text(
            branchName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const Center(
          child: Text(
            'RUC: J0310000012345 • Tel: +505 2270-1234',
            style: TextStyle(fontSize: 11),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FAC: ${invoice.invoiceNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              '${invoice.issuedAt.hour}:${invoice.issuedAt.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        Text(
          '${l10n.customer}: ${invoice.customerDisplayName}',
          style: const TextStyle(fontSize: 12),
        ),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        ...invoice.items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity.toInt()}x ${item.name}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  '\$${item.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.subtotalLabel),
            Text('\$${invoice.subtotal.toStringAsFixed(2)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.tax15Percent),
            Text('\$${invoice.taxAmount.toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.total,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '\$${invoice.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        ...invoice.payments.map((p) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${p.method.storageKey.toUpperCase()}:',
                style: const TextStyle(fontSize: 11),
              ),
              Text(
                '\$${p.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          );
        }),
        const SizedBox(height: 12),
        Center(
          child: Text(
            l10n.thankYouForBusiness,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
