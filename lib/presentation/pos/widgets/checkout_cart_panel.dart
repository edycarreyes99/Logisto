import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../pos_checkout_provider.dart';

/// Left panel rendering the current sale cart items, tax calculation, and balance.
class CheckoutCartPanel extends StatelessWidget {
  final PosCheckoutProvider provider;
  final VoidCallback? onAddProduct;

  const CheckoutCartPanel({
    super.key,
    required this.provider,
    this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderRow(l10n),
            const Divider(height: 24),
            if (provider.cartItems.isEmpty)
              _buildEmptyCart(context, l10n)
            else ...[
              _buildItemsTable(l10n),
              const Divider(height: 24),
              _buildFinancialSummary(l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            l10n.saleSummaryAndItems,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onAddProduct != null)
          FilledButton.tonalIcon(
            icon: const Icon(Icons.add, size: 16),
            label: Text(l10n.addItem),
            onPressed: onAddProduct,
          ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.remove_shopping_cart_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.cartIsEmptyPrompt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        columns: [
          DataColumn(label: Text(l10n.tableHeaderItem)),
          DataColumn(label: Text(l10n.tableHeaderQuantity)),
          DataColumn(
            label: Text(l10n.tableHeaderPrice),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.total),
            numeric: true,
          ),
          const DataColumn(label: Text('')),
        ],
        rows: provider.cartItems.map((item) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => provider.updateItemQuantity(
                        item.productId,
                        item.quantity - 1,
                      ),
                    ),
                    Text(
                      '${item.quantity.toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => provider.updateItemQuantity(
                        item.productId,
                        item.quantity + 1,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text('\$${item.unitPrice.toStringAsFixed(2)}')),
              DataCell(
                Text(
                  '\$${item.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: AppColors.error,
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      provider.removeItemFromCart(item.productId),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFinancialSummary(AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.subtotalLabel),
            Text('\$${provider.subtotal.toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.tax15Percent),
            Text('\$${provider.taxAmount.toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.totalAmountLabel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${provider.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
