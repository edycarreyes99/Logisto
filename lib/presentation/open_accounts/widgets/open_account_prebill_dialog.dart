import 'package:flutter/material.dart';
import '../../../domain/models/open_account_model.dart';
import '../../../l10n/app_localizations.dart';

/// Modal dialog previewing the pre-bill receipt slip before collection.
class OpenAccountPrebillDialog extends StatelessWidget {
  final OpenAccountModel account;

  const OpenAccountPrebillDialog({super.key, required this.account});

  /// Displays the dialog.
  static Future<void> show(BuildContext context, OpenAccountModel account) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => OpenAccountPrebillDialog(account: account),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, size: 24),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.preBillPreviewCode(account.code))),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.customerLabel(account.customerDisplayName),
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 16),
              ...account.items.map((i) => _buildItemRow(i, theme)),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.totalToCollect,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${account.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  Widget _buildItemRow(AccountItemModel item, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('${item.quantity.toInt()}x ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(item.name, overflow: TextOverflow.ellipsis)),
          Text('\$${item.total.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
