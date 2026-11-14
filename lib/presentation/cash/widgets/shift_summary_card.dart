import 'package:flutter/material.dart';
import '../../../domain/models/cash_shift_model.dart';
import '../../../l10n/app_localizations.dart';

/// Card rendering live operational cashier shift totals and cash drawer balance.
class ShiftSummaryCard extends StatelessWidget {
  final CashShiftModel shift;
  final VoidCallback onAddMovement;
  final VoidCallback onCloseShift;

  const ShiftSummaryCard({
    super.key,
    required this.shift,
    required this.onAddMovement,
    required this.onCloseShift,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(l10n, theme),
            const Divider(height: 24),
            _buildMetricsGrid(l10n),
            const SizedBox(height: 16),
            _buildActionButtons(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            l10n.registerActiveShift(shift.cashRegisterNumber),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text(
            l10n.shiftOpen,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontSize: 12,
            ),
          ),
          backgroundColor: theme.colorScheme.primaryContainer,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(AppLocalizations l10n) {
    return Column(
      children: [
        _buildRow(
          l10n.openingFloatBase,
          '\$${shift.openingBalance.toStringAsFixed(2)}',
        ),
        _buildRow(
          l10n.cashSalesLabel,
          '+\$${shift.cashSales.toStringAsFixed(2)}',
        ),
        _buildRow(
          l10n.cardSalesLabel,
          '\$${shift.cardSales.toStringAsFixed(2)}',
        ),
        _buildRow(
          l10n.cashInjectionsLabel,
          '+\$${shift.cashInjections.toStringAsFixed(2)}',
        ),
        _buildRow(
          l10n.withdrawalsLabel,
          '-\$${shift.cashWithdrawals.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 8),
        _buildRow(
          l10n.calculatedCashInTill,
          '\$${shift.expectedCashBalance.toStringAsFixed(2)}',
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.swap_horiz, size: 18),
          label: Text(l10n.cashMovementButton),
          onPressed: onAddMovement,
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          icon: const Icon(Icons.lock, size: 18),
          label: Text(l10n.closeShiftBlindDropButton),
          onPressed: onCloseShift,
        ),
      ],
    );
  }
}
