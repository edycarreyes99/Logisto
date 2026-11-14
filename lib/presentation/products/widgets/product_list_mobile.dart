import 'package:flutter/material.dart';
import '../../../domain/models/product_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/enum_localization_extensions.dart';

/// Mobile touch-optimized card list for product catalog.
class ProductListMobile extends StatelessWidget {
  final List<ProductModel> products;
  final ValueChanged<ProductModel> onEdit;

  const ProductListMobile({
    super.key,
    required this.products,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: products.map((p) => _buildCard(p, l10n)).toList(),
    );
  }

  Widget _buildCard(ProductModel p, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: ListTile(
        title: Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${p.sku} • ${p.productType.localizedTitle(l10n)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${p.salePrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit, size: 14),
              label: Text(l10n.edit),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () => onEdit(p),
            ),
          ],
        ),
      ),
    );
  }
}
