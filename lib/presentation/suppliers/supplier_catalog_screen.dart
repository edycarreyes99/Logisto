import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/supplier_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'supplier_catalog_provider.dart';
import 'widgets/supplier_list_mobile.dart';
import 'widgets/supplier_table_desktop.dart';

/// Screen managing corporate supplier directory, purchase terms,
/// and payable balances.
class SupplierCatalogScreen extends StatefulWidget {
  const SupplierCatalogScreen({super.key});

  @override
  State<SupplierCatalogScreen> createState() => _SupplierCatalogScreenState();
}

class _SupplierCatalogScreenState extends State<SupplierCatalogScreen> {
  late final SupplierCatalogProvider _provider;
  late final BusinessContextProvider _contextProvider;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = locator<SupplierCatalogProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadSuppliers(orgId);
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showSupplierModal([SupplierModel? existing]) {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(text: existing?.companyName ?? '');
    final taxCtrl = TextEditingController(text: existing?.taxId ?? '');
    final contactCtrl = TextEditingController(
      text: existing?.contactPerson ?? '',
    );
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final daysCtrl = TextEditingController(
      text: existing != null ? '${existing.creditDays}' : '30',
    );

    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            existing == null ? l10n.registerSupplier : l10n.editSupplier,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.companyLegalName,
                    hintText: l10n.companyLegalName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: taxCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.rucTaxIdPlaceholder,
                    hintText: l10n.rucTaxIdPlaceholder,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.contactRepresentative,
                    hintText: l10n.contactRepresentative,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.placeholderPhone,
                    hintText: l10n.placeholderPhone,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: daysCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.creditDaysExample,
                    hintText: l10n.creditDaysExample,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
              label: Text(l10n.saveSupplier),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final orgId = _contextProvider.activeOrganization?.id ?? '';
                      final days = int.tryParse(daysCtrl.text) ?? 30;
                      final sup = SupplierModel(
                        id:
                            existing?.id ??
                            'sup_${DateTime.now().millisecondsSinceEpoch}',
                        orgId: orgId,
                        companyName: nameCtrl.text.isEmpty
                            ? l10n.defaultSupplierName
                            : nameCtrl.text,
                        taxId: taxCtrl.text.isEmpty ? 'J00000000' : taxCtrl.text,
                        contactPerson: contactCtrl.text.isEmpty
                            ? l10n.defaultContactName
                            : contactCtrl.text,
                        phone: phoneCtrl.text.isEmpty ? '555-0000' : phoneCtrl.text,
                        creditDays: days,
                        currentPayableBalance:
                            existing?.currentPayableBalance ?? 0.0,
                      );
                      await _provider.saveSupplier(orgId: orgId, supplier: sup);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Proveedor "${sup.companyName}" guardado exitosamente',
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
    return LogistoScaffold(
      title: l10n.suppliers,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: l10n.refresh,
          onPressed: () {
            final orgId = _contextProvider.activeOrganization?.id ?? '';
            if (orgId.isNotEmpty) {
              _provider.loadSuppliers(orgId);
              AppFeedback.showSuccess(context, 'Directorio de proveedores sincronizado');
            }
          },
        ),
        FilledButton.icon(
          icon: const Icon(Icons.add_business, size: 18),
          label: Text(l10n.registerSupplier),
          onPressed: () => _showSupplierModal(),
        ),
      ],
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
    final suppliers = _provider.filteredSuppliers;
    final theme = Theme.of(context);

    if (_provider.status == FeatureStatusEnum.loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: l10n.searchSupplierPlaceholder,
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
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isDesktop
                  ? const AppSkeletonTable(rowCount: 5, columnCount: 5)
                  : const AppSkeletonList(itemCount: 4),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: l10n.searchSupplierPlaceholder,
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
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: suppliers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        l10n.noSuppliersFound,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : (isDesktop
                    ? SupplierTableDesktop(
                        suppliers: suppliers,
                        onEdit: _showSupplierModal,
                      )
                    : SupplierListMobile(
                        suppliers: suppliers,
                        onEdit: _showSupplierModal,
                      )),
          ),
        ),
      ],
    );
  }
}
