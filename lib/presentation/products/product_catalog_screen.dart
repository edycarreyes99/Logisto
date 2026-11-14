import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/product_type_enum.dart';
import '../../domain/models/product_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/enum_localization_extensions.dart';
import '../context/business_context_provider.dart';
import 'product_catalog_provider.dart';
import 'widgets/product_list_mobile.dart';
import 'widgets/product_table_desktop.dart';

/// Master catalog screen managing products, combos, recipes, and prices.
class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  late final ProductCatalogProvider _provider;
  late final BusinessContextProvider _contextProvider;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = locator<ProductCatalogProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId =
        _contextProvider.activeOrganization?.id ?? 'org_logisto_matriz';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadProducts(orgId);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showProductModal([ProductModel? existing]) {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final skuCtrl = TextEditingController(text: existing?.sku ?? '');
    final barcodeCtrl = TextEditingController(text: existing?.barcode ?? '');
    final costCtrl = TextEditingController(
      text: existing != null ? '${existing.costPrice}' : '1.00',
    );
    final saleCtrl = TextEditingController(
      text: existing != null ? '${existing.salePrice}' : '2.00',
    );
    ProductTypeEnum selectedType =
        existing?.productType ?? ProductTypeEnum.standard;

    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            existing == null ? l10n.createProduct : l10n.editProduct,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.productName,
                    hintText: l10n.productNamePrompt,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: skuCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.sku,
                          hintText: 'SKU-001',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: barcodeCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.barcode,
                          hintText: '7434000101',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: costCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.costPrice,
                          hintText: '1.00',
                          border: const OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: saleCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.salePrice,
                          hintText: '2.50',
                          border: const OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.productType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: ProductTypeEnum.values.map((t) {
                    final isSel = selectedType == t;
                    return ChoiceChip(
                      label: Text(t.localizedTitle(l10n)),
                      selected: isSel,
                      onSelected: (_) => setModalState(() => selectedType = t),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(l10n.saveProduct),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final orgId =
                          _contextProvider.activeOrganization?.id ??
                          'org_logisto_matriz';
                      final cost = double.tryParse(costCtrl.text) ?? 1.0;
                      final sale = double.tryParse(saleCtrl.text) ?? 2.0;
                      final item = ProductModel(
                        id:
                            existing?.id ??
                            'prod_${DateTime.now().millisecondsSinceEpoch}',
                        orgId: orgId,
                        sku: skuCtrl.text.isEmpty ? 'SKU-001' : skuCtrl.text,
                        barcode: barcodeCtrl.text.isEmpty
                            ? '0000000000'
                            : barcodeCtrl.text,
                        name: nameCtrl.text.isEmpty
                            ? l10n.defaultProductName
                            : nameCtrl.text,
                        categoryId: 'general',
                        productType: selectedType,
                        costPrice: cost,
                        salePrice: sale,
                      );
                      await _provider.saveProduct(orgId: orgId, product: item);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Producto "${item.name}" guardado exitosamente',
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.products,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.refresh,
            onPressed: () {
              final orgId =
                  _contextProvider.activeOrganization?.id ?? 'org_logisto_matriz';
              _provider.loadProducts(orgId);
              AppFeedback.showSuccess(context, 'Catálogo de productos sincronizado');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FilledButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.newProduct),
              onPressed: () => _showProductModal(),
            ),
          ),
        ],
      ),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _buildBody(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final products = _provider.filteredProducts;
    final orgId =
        _contextProvider.activeOrganization?.id ?? 'org_logisto_matriz';
    final theme = Theme.of(context);

    if (_provider.status == FeatureStatusEnum.loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilterBar(l10n),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isDesktop
                  ? const AppSkeletonTable(rowCount: 6, columnCount: 6)
                  : const AppSkeletonList(itemCount: 4),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilterBar(l10n),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: products.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.noProductsRegistered,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : (isDesktop
                    ? ProductTableDesktop(
                        products: products,
                        onEdit: _showProductModal,
                        onDelete: (id) {
                          _provider.deleteProduct(
                            orgId: orgId,
                            productId: id,
                          );
                          AppFeedback.showSuccess(
                            context,
                            l10n.recordDeletedSuccess,
                          );
                        },
                      )
                    : ProductListMobile(
                        products: products,
                        onEdit: _showProductModal,
                      )),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 260,
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: l10n.searchPlaceholder,
              prefixIcon: const Icon(Icons.search, size: 20),
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onChanged: _provider.setSearchQuery,
          ),
        ),
        ...ProductTypeEnum.values.map((type) {
          final isSel = _provider.typeFilter == type;
          return FilterChip(
            label: Text(type.storageKey.toUpperCase()),
            selected: isSel,
            onSelected: (_) => _provider.setTypeFilter(isSel ? null : type),
          );
        }),
      ],
    );
  }
}
