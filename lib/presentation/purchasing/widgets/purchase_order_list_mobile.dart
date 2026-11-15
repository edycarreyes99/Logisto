import 'package:flutter/material.dart';
import '../../../core/enums/purchase_order_status_enum.dart';
import '../../../domain/models/purchase_order_model.dart';
import '../../../l10n/app_localizations.dart';

/// Mobile card list for purchase orders.
class PurchaseOrderListMobile extends StatelessWidget {
  final List<PurchaseOrderModel> orders;
  final ValueChanged<String> onReceive;

  const PurchaseOrderListMobile({
    super.key,
    required this.orders,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: orders.map((po) => _buildCard(po, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    PurchaseOrderModel po,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isReceived = po.status == PurchaseOrderStatusEnum.received;
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        title: Text(
          po.supplierName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${po.id} • ${po.orderDate.toString().split(' ').first}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${po.totalCost.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            if (!isReceived)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => onReceive(po.id),
                child: Text(l10n.receive),
              )
            else
              Chip(
                label: Text(
                  l10n.delivered,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                backgroundColor: theme.colorScheme.primaryContainer,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}
