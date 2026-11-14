import 'package:flutter/material.dart';
import '../../../domain/models/account_receivable_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// Mobile card list for accounts receivable balances.
class ReceivableListMobile extends StatelessWidget {
  final List<AccountReceivableModel> receivables;
  final ValueChanged<AccountReceivableModel> onCollect;

  const ReceivableListMobile({
    super.key,
    required this.receivables,
    required this.onCollect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: receivables.map((r) => _buildCard(r, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    AccountReceivableModel r,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isPaid = r.isPaid;
    final isOverdue = r.isOverdue;
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        title: Text(
          r.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${r.invoiceNumber} • ${l10n.dueDate} ${r.dueDate.toString().split(' ').first}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${r.balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isPaid
                    ? AppColors.success
                    : (isOverdue ? theme.colorScheme.error : AppColors.warning),
              ),
            ),
            const SizedBox(width: 8),
            if (!isPaid)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => onCollect(r),
                child: Text(l10n.collect),
              )
            else
              Chip(
                label: Text(
                  l10n.paid,
                  style: const TextStyle(fontSize: 11),
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}
