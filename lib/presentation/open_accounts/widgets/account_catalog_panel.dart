import 'package:flutter/material.dart';
import '../../../domain/models/product_model.dart';
import '../../../l10n/app_localizations.dart';

/// Left panel rendering the quick-add catalog items for rapid tab loading.
class AccountCatalogPanel extends StatelessWidget {
  final List<ProductModel> products;
  final ValueChanged<ProductModel> onAddProduct;

  const AccountCatalogPanel({
    super.key,
    required this.products,
    required this.onAddProduct,
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
            Text(
              l10n.fastCatalogTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            Text(
              l10n.fastCatalogPrompt,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            _buildProductsWrap(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: products.map((product) {
        final displayName = product.name.length > 24
            ? '${product.name.substring(0, 22)}...'
            : product.name;
        return ActionChip(
          avatar: const Icon(Icons.add_circle_outline, size: 16),
          label: Text(
            '$displayName (\$${product.salePrice.toStringAsFixed(2)})',
          ),
          onPressed: () => onAddProduct(product),
        );
      }).toList(),
    );
  }
}
