import 'package:flutter/material.dart';
import '../../../domain/models/open_account_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

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
      return _buildEmptyCard(l10n, theme, context);
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(theme, l10n),
            const Divider(height: 16),
            _buildItemsList(l10n, theme),
            const Divider(height: 20),
            _buildSummaryFooter(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(AppLocalizations l10n, ThemeData theme, BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.touch_app_outlined, size: 36, color: theme.colorScheme.outline),
              const SizedBox(height: 8),
              Text(
                l10n.activeTabOrder,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.noTabSelectedPrompt,
                style: TextStyle(color: theme.colorScheme.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(ThemeData theme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account!.code,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                account!.customerDisplayName,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Chip(
          label: Text(
            account!.originType.localizedTitle(l10n),
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

  Widget _buildItemsList(AppLocalizations l10n, ThemeData theme) {
    if (account!.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            l10n.emptyOrderPrompt,
            style: TextStyle(color: theme.colorScheme.outline, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < account!.items.length; i++) ...[
          if (i > 0) const Divider(height: 12),
          _buildItemRow(i, account!.items[i], theme),
        ],
      ],
    );
  }

  Widget _buildItemRow(int idx, AccountItemModel item, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '\$${item.unitPrice.toStringAsFixed(2)} ea',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 20),
          visualDensity: VisualDensity.compact,
          onPressed: () => onAdjustQuantity(idx, -1),
        ),
        Text(
          item.quantity.toInt().toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 20),
          visualDensity: VisualDensity.compact,
          onPressed: () => onAdjustQuantity(idx, 1),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '\$${item.total.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryFooter(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.totalToCollect,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${account!.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.receipt_long, size: 16),
              label: Text(l10n.preBillPrint),
              onPressed: account!.items.isNotEmpty ? onPreBill : null,
            ),
            FilledButton.icon(
              icon: const Icon(Icons.point_of_sale, size: 16),
              label: Text(l10n.proceedToCheckout),
              onPressed: account!.items.isNotEmpty ? onCheckout : null,
            ),
          ],
        ),
      ],
    );
  }
}
