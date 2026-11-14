import 'package:flutter/material.dart';
import '../../../domain/models/stock_movement_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../common/enum_localization_extensions.dart';

/// Touch-friendly mobile list for inventory Kardex movements.
class KardexListMobile extends StatelessWidget {
  final List<StockMovementModel> movements;

  const KardexListMobile({super.key, required this.movements});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (movements.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: Text(l10n.noKardexMovements)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: movements.map((m) => _buildCard(m, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    StockMovementModel m,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isPositive = m.quantity > 0;
    final qtyFormatted =
        '${isPositive ? "+" : ""}${l10n.unitsCount(m.quantity.toInt())}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    m.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    m.movementType.localizedTitle(l10n).toUpperCase(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    qtyFormatted,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPositive
                          ? AppColors.success
                          : theme.colorScheme.error,
                    ),
                  ),
                ),
                Text(
                  'Val: \$${m.totalCost.abs().toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (m.notes != null || m.referenceId != null) ...[
              const SizedBox(height: 4),
              Text(
                m.notes ?? m.referenceId!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
            const SizedBox(height: 2),
            Text(
              '${m.timestamp.year}-${m.timestamp.month.toString().padLeft(2, '0')}-${m.timestamp.day.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
