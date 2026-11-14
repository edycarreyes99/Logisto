import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Mobile card list for warehouse stock levels.
class WarehouseStockListMobile extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final ValueChanged<Map<String, dynamic>> onTransfer;

  const WarehouseStockListMobile({
    super.key,
    required this.items,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: items.map((item) => _buildItemCard(item, l10n, theme)).toList(),
    );
  }

  Widget _buildItemCard(
    Map<String, dynamic> item,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isLow = item['isLowStock'] as bool;
    final current = item['currentQuantity'] as double;
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(child: _buildDetailsColumn(item, l10n)),
            const SizedBox(width: 8),
            _buildActionColumn(item, isLow, current, l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsColumn(
    Map<String, dynamic> item,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${item['sku']} • ${l10n.minStockCount((item['minStock'] as double).toInt())}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionColumn(
    Map<String, dynamic> item,
    bool isLow,
    double current,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Chip(
          label: Text(
            l10n.inStockCount(current.toInt()),
            style: TextStyle(
              fontSize: 11,
              color: isLow
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: isLow
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.primaryContainer,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
        const SizedBox(height: 4),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () => onTransfer(item),
          child: Text(l10n.transfer),
        ),
      ],
    );
  }
}
