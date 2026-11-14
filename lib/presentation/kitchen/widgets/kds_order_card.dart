import 'package:flutter/material.dart';
import '../../../core/enums/kds_status_enum.dart';
import '../../../domain/models/kitchen_order_model.dart';
import '../../../l10n/app_localizations.dart';

/// Card rendering an active kitchen/bar preparation ticket with item notes and status actions.
class KdsOrderCard extends StatelessWidget {
  final KitchenOrderModel order;
  final VoidCallback onAdvance;

  const KdsOrderCard({super.key, required this.order, required this.onAdvance});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final elapsedMin = DateTime.now().difference(order.createdAt).inMinutes;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(elapsedMin, l10n, theme),
            const Divider(height: 20),
            ...order.items.map((item) => _buildItemLine(item, l10n, theme)),
            const SizedBox(height: 16),
            _buildActionButton(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(
    int elapsedMin,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${order.orderCode} • ${order.tableOrTabName}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildStatusBadge(elapsedMin, l10n, theme),
      ],
    );
  }

  Widget _buildStatusBadge(
    int elapsedMin,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    Color bg;
    Color fg;
    String label;
    switch (order.status) {
      case KdsStatusEnum.pending:
        bg = theme.colorScheme.errorContainer;
        fg = theme.colorScheme.onErrorContainer;
        label = l10n.kdsMinutesPending(elapsedMin);
      case KdsStatusEnum.preparing:
        bg = theme.colorScheme.tertiaryContainer;
        fg = theme.colorScheme.onTertiaryContainer;
        label = l10n.kdsMinutesCooking(elapsedMin);
      case KdsStatusEnum.ready:
        bg = theme.colorScheme.primaryContainer;
        fg = theme.colorScheme.onPrimaryContainer;
        label = l10n.readyToServe;
      case KdsStatusEnum.served:
        bg = theme.colorScheme.surfaceContainerHighest;
        fg = theme.colorScheme.onSurfaceVariant;
        label = l10n.served;
      case KdsStatusEnum.cancelled:
        bg = theme.colorScheme.errorContainer;
        fg = theme.colorScheme.onErrorContainer;
        label = l10n.cancelled;
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

  Widget _buildItemLine(
    KitchenOrderItemModel item,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.quantity.toInt()}x ${item.productName}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          if (item.notes != null && item.notes!.isNotEmpty)
            Text(
              l10n.kdsNote(item.notes!),
              style: TextStyle(fontSize: 12, color: theme.colorScheme.error),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(AppLocalizations l10n, ThemeData theme) {
    switch (order.status) {
      case KdsStatusEnum.pending:
        return FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
          ),
          icon: const Icon(Icons.play_circle_outline, size: 18),
          label: Text(l10n.startPreparation),
          onPressed: onAdvance,
        );
      case KdsStatusEnum.preparing:
        return FilledButton.icon(
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: Text(l10n.markReady),
          onPressed: onAdvance,
        );
      case KdsStatusEnum.ready:
        return FilledButton.icon(
          icon: const Icon(Icons.notifications_active_outlined, size: 18),
          label: Text(l10n.markServed),
          onPressed: onAdvance,
        );
      case KdsStatusEnum.served:
        return Text(
          l10n.orderCompleted,
          style: TextStyle(color: theme.colorScheme.outline),
        );
      case KdsStatusEnum.cancelled:
        return Text(
          l10n.orderCancelled,
          style: TextStyle(color: theme.colorScheme.error),
        );
    }
  }
}
