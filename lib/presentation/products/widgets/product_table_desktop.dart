import 'package:flutter/material.dart';
import '../../../domain/models/product_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/enum_localization_extensions.dart';

/// Desktop high-density tabular presentation for master products catalog.
class ProductTableDesktop extends StatelessWidget {
  final List<ProductModel> products;
  final ValueChanged<ProductModel> onEdit;
  final ValueChanged<String> onDelete;

  const ProductTableDesktop({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.tableHeaderSkuBarcode)),
          DataColumn(label: Text(l10n.productName)),
          DataColumn(label: Text(l10n.productType)),
          DataColumn(
            label: Text(l10n.costPrice),
            numeric: true,
          ),
          DataColumn(
            label: Text(l10n.salePrice),
            numeric: true,
          ),
          DataColumn(label: Text(l10n.tableHeaderActions)),
        ],
        rows: products.map((p) => _buildRow(p, l10n, context)).toList(),
      ),
    );
  }

  DataRow _buildRow(
    ProductModel p,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    return DataRow(
      cells: [
        DataCell(
          Text(
            '${p.sku}\n${p.barcode}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            p.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(
          Chip(
            label: Text(
              p.productType.localizedTitle(l10n),
              style: const TextStyle(fontSize: 11),
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(Text('\$${p.costPrice.toStringAsFixed(2)}')),
        DataCell(
          Text(
            '\$${p.salePrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => onEdit(p),
                child: Text(l10n.edit),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: theme.colorScheme.error,
                ),
                onPressed: () => onDelete(p.id),
                child: Text(l10n.delete),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
