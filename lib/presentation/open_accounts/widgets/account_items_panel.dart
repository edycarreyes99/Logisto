import 'package:flutter/material.dart';
import '../../../domain/models/open_account_model.dart';
import '../../../l10n/app_localizations.dart';

/// Right panel displaying active open account order details, item quantities, and total.
class AccountItemsPanel extends StatelessWidget {
  final OpenAccountModel? account;
  final Function(int index, double delta) onAdjustQuantity;
  final VoidCallback onCheckout;
  final VoidCallback onPreBill;

  const AccountItemsPanel({
    super.key,
    required this.account,
    required this.onAdjustQuantity,
    required this.onCheckout,
    required this.onPreBill,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (account == null) {
      return _buildEmptyCard(l10n, theme);
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(theme),
            const Divider(height: 20),
            _buildItemsList(l10n),
            const Divider(height: 24),
            _buildSummaryFooter(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(AppLocalizations l10n, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.activeTabOrder,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            Text(
              l10n.noTabSelectedPrompt,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${account!.code} • ${account!.customerDisplayName}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text(
            account!.originType.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.primaryContainer,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          side: BorderSide.none,
        ),
      ],
    );
  }

  Widget _buildItemsList(AppLocalizations l10n) {
    if (account!.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(l10n.noConsumablesLoaded),
      );
    }

    return Column(
      children: account!.items.asMap().entries.map((entry) {
        final idx = entry.key;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      l10n.priceEach(item.unitPrice.toStringAsFixed(2)),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildQtyControls(idx, item, l10n),
              const SizedBox(width: 12),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQtyControls(
    int idx,
    AccountItemModel item,
    AppLocalizations l10n,
  ) {
    if (item.isBilliardTime) {
      return Chip(
        label: Text(l10n.timerAction, style: const TextStyle(fontSize: 11)),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 16),
          visualDensity: VisualDensity.compact,
          onPressed: () => onAdjustQuantity(idx, -1.0),
        ),
        Text(
          '${item.quantity.toInt()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 16),
          visualDensity: VisualDensity.compact,
          onPressed: () => onAdjustQuantity(idx, 1.0),
        ),
      ],
    );
  }

  Widget _buildSummaryFooter(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.accountTotal,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${account!.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.receipt, size: 18),
              label: Text(l10n.preBillPrint),
              onPressed: onPreBill,
            ),
            FilledButton.icon(
              icon: const Icon(Icons.credit_card, size: 18),
              label: Text(l10n.proceedToCheckout),
              onPressed: onCheckout,
            ),
          ],
        ),
      ],
    );
  }
}
