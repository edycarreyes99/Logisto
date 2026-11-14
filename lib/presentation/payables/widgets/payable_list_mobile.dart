import 'package:flutter/material.dart';
import '../../../domain/models/account_payable_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// Mobile card list for accounts payable supplier debts.
class PayableListMobile extends StatelessWidget {
  final List<AccountPayableModel> payables;
  final ValueChanged<AccountPayableModel> onPay;

  const PayableListMobile({
    super.key,
    required this.payables,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: payables.map((p) => _buildCard(p, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    AccountPayableModel p,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isSettled = p.isSettled;
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        title: Text(
          p.supplierName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${p.invoiceNumber} • Due ${p.dueDate.toString().split(' ').first}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${p.remainingBalance.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSettled
                    ? AppColors.success
                    : theme.colorScheme.error,
              ),
            ),
            const SizedBox(width: 8),
            if (!isSettled)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => onPay(p),
                child: Text(l10n.pay),
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
