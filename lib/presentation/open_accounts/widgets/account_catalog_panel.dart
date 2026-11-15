import 'package:flutter/material.dart';
import '../../../domain/models/product_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// Middle panel rendering the quick-add catalog items for rapid tab loading.
class AccountCatalogPanel extends StatefulWidget {
  final List<ProductModel> products;
  final ValueChanged<ProductModel> onAddProduct;

  const AccountCatalogPanel({
    super.key,
    required this.products,
    required this.onAddProduct,
  });

  @override
  State<AccountCatalogPanel> createState() => _AccountCatalogPanelState();
}

class _AccountCatalogPanelState extends State<AccountCatalogPanel> {
  String _selectedCategory = 'all';
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final filtered = _getFilteredProducts();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(l10n, theme),
            const SizedBox(height: 8),
            _buildSearchAndFilters(l10n),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              _buildEmptyView(l10n, theme)
            else
              _buildProductsWrap(filtered),
          ],
        ),
      ),
    );
  }

  List<ProductModel> _getFilteredProducts() {
    return widget.products.where((p) {
      final matchesCategory = _selectedCategory == 'all' || p.categoryId == _selectedCategory;
      final matchesSearch = _search.isEmpty ||
          p.name.toLowerCase().contains(_search.toLowerCase()) ||
          p.sku.toLowerCase().contains(_search.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            l10n.fastCatalogTitle,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${widget.products.length} ${l10n.products}',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(AppLocalizations l10n) {
    final categories = _extractCategories(l10n);

    return Column(
      children: [
        TextField(
          controller: _searchCtrl,
          onChanged: (val) => setState(() => _search = val.trim()),
          decoration: InputDecoration(
            hintText: l10n.searchPlaceholder,
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        if (categories.length > 1) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedCategory == cat.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    label: Text(cat.label, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    visualDensity: VisualDensity.compact,
                    onSelected: (_) => setState(() => _selectedCategory = cat.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  List<_CategoryOption> _extractCategories(AppLocalizations l10n) {
    final set = <String>{};
    for (final p in widget.products) {
      if (p.categoryId.isNotEmpty) set.add(p.categoryId);
    }
    return [
      _CategoryOption(id: 'all', label: l10n.allCategories),
      ...set.map((cat) => _CategoryOption(id: cat, label: cat.toUpperCase())),
    ];
  }

  Widget _buildProductsWrap(List<ProductModel> products) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: products.map((product) {
        final displayName = product.name.length > 20
            ? '${product.name.substring(0, 18)}...'
            : product.name;
        return ActionChip(
          avatar: const Icon(Icons.add_circle_outline, size: 16),
          label: Text('$displayName (\$${product.salePrice.toStringAsFixed(2)})'),
          onPressed: () => widget.onAddProduct(product),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyView(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Text(
          l10n.noProductsAvailablePrompt,
          style: TextStyle(color: theme.colorScheme.outline),
        ),
      ),
    );
  }
}

class _CategoryOption {
  final String id;
  final String label;
  const _CategoryOption({required this.id, required this.label});
}
