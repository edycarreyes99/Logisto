import 'package:flutter/material.dart';
import '../../../core/enums/table_status_enum.dart';
import '../../../domain/models/billiard_table_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/enum_localization_extensions.dart';
import '../billiard_provider.dart';

/// Card rendering billiard table status, elapsed session timer,
/// real-time accrued charge, and station control actions.
class BilliardTableCard extends StatelessWidget {
  final BilliardTableModel table;
  final BilliardProvider provider;
  final VoidCallback onStart;
  final VoidCallback onTransfer;

  const BilliardTableCard({
    super.key,
    required this.table,
    required this.provider,
    required this.onStart,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final charge = provider.calculateCurrentCharge(table);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(l10n, theme),
            const Divider(height: 20),
            Text(
              l10n.tableRatePerHour(
                table.hourlyRate.toStringAsFixed(2),
                table.tableType.localizedTitle(l10n).toUpperCase(),
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildSessionInfo(l10n, theme, charge),
            const SizedBox(height: 16),
            _buildActionButtons(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionInfo(
    AppLocalizations l10n,
    ThemeData theme,
    double charge,
  ) {
    if (table.currentSession != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tablePlayerLabel(
              table.currentSession!.customerName ?? l10n.counterDefault,
            ),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.tableAccruedAmount(charge.toStringAsFixed(2)),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return Text(
      l10n.tableReady,
      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            table.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildStatusBadge(l10n, theme),
      ],
    );
  }

  Widget _buildStatusBadge(AppLocalizations l10n, ThemeData theme) {
    Color bg;
    Color fg;
    String label;
    switch (table.status) {
      case TableStatusEnum.available:
        bg = theme.colorScheme.primaryContainer;
        fg = theme.colorScheme.onPrimaryContainer;
        label = l10n.tableStatusAvailable;
      case TableStatusEnum.occupied:
        bg = theme.colorScheme.errorContainer;
        fg = theme.colorScheme.onErrorContainer;
        label = l10n.tableStatusOccupied;
      case TableStatusEnum.paused:
        bg = theme.colorScheme.tertiaryContainer;
        fg = theme.colorScheme.onTertiaryContainer;
        label = l10n.tableStatusPaused;
      case TableStatusEnum.billing:
        bg = theme.colorScheme.secondaryContainer;
        fg = theme.colorScheme.onSecondaryContainer;
        label = l10n.tableStatusBilling;
    }
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
      backgroundColor: bg,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      side: BorderSide.none,
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, ThemeData theme) {
    if (table.status == TableStatusEnum.available) {
      return FilledButton.icon(
        icon: const Icon(Icons.play_arrow, size: 18),
        label: Text(l10n.startTable),
        onPressed: onStart,
      );
    }

    final isPaused = table.status == TableStatusEnum.paused;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        FilledButton.tonal(
          style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
          onPressed: () => isPaused
              ? provider.resumeSession(table.id)
              : provider.pauseSession(table.id),
          child: Text(isPaused ? l10n.resumeTable : l10n.pauseTable),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
          onPressed: onTransfer,
          child: Text(l10n.transfer),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () => provider.stopSession(table.id),
          child: Text(l10n.stopSession),
        ),
      ],
    );
  }
}
