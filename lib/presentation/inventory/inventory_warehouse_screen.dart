import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/warehouse_view_mode_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'inventory_warehouse_provider.dart';
import 'widgets/kardex_list_mobile.dart';
import 'widgets/kardex_table_desktop.dart';
import 'widgets/warehouse_stock_list_mobile.dart';
import 'widgets/warehouse_stock_table_desktop.dart';

/// Screen managing multi-warehouse physical stock, low-stock warnings,
/// internal transfer dispatches, and permanent Kardex ledger auditing.
class InventoryWarehouseScreen extends StatefulWidget {
  final WarehouseViewModeEnum? initialView;

  const InventoryWarehouseScreen({super.key, this.initialView});

  @override
  State<InventoryWarehouseScreen> createState() =>
      _InventoryWarehouseScreenState();
}

class _InventoryWarehouseScreenState extends State<InventoryWarehouseScreen> {
  late final InventoryWarehouseProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<InventoryWarehouseProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    if (widget.initialView != null) {
      _provider.setViewMode(widget.initialView!);
    }
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadWarehouses(orgId: orgId, buId: buId);
      });
    }
  }

  void _showTransferModal(Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context)!;
    final qtyCtrl = TextEditingController(text: '12');
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.internalTransferTitle(item['name'] as String)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.transferSourceBodega),
              Text(l10n.transferDestBarra),
              const SizedBox(height: 12),
              TextField(
                controller: qtyCtrl,
                decoration: InputDecoration(
                  labelText: l10n.transferQuantityPlaceholder,
                  hintText: l10n.transferQuantityPlaceholder,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
              label: Text(l10n.confirmTransferGuide),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final qty = double.tryParse(qtyCtrl.text) ?? 1.0;
                      await _provider.transferStock(
                        fromWhId: 'wh_main',
                        toWhId: 'wh_bar',
                        productId: item['productId'] as String,
                        quantity: qty,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Transferencia interna de $qty unidades confirmada',
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _showAdjustModal(Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context)!;
    final qtyCtrl = TextEditingController(text: '${item['currentQuantity']}');
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(l10n.stockAdjustmentTitle(item['name'] as String)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.auditedStockCountPrompt),
              const SizedBox(height: 12),
              TextField(
                controller: qtyCtrl,
                decoration: InputDecoration(
                  labelText: l10n.newTotalQuantity,
                  hintText: l10n.newTotalQuantity,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
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
              label: Text(l10n.saveAdjustment),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
                      await _provider.adjustStock(
                        productId: item['productId'] as String,
                        newQuantity: qty,
                        reason: l10n.auditPhysicalCountReason,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Ajuste de inventario aplicado a ${item['name']}',
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
    final bottomTabs = PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: Text(l10n.stockLevels),
                selected: _provider.viewMode == WarehouseViewModeEnum.stock,
                onSelected: (_) => _provider.setViewMode(WarehouseViewModeEnum.stock),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text(l10n.kardexLedger),
                selected: _provider.viewMode == WarehouseViewModeEnum.kardex,
                onSelected: (_) => _provider.setViewMode(WarehouseViewModeEnum.kardex),
              ),
              if (_provider.viewMode == WarehouseViewModeEnum.stock) ...[
                const SizedBox(width: 16),
                ..._provider.warehouses.map((wh) {
                  final isSel = _provider.selectedWarehouse?.id == wh.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(wh.name),
                      selected: isSel,
                      onSelected: (_) => _provider.selectWarehouse(wh),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );

    return LogistoScaffold(
      title: l10n.warehouses,
      bottom: bottomTabs,
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _provider.viewMode == WarehouseViewModeEnum.kardex
                ? _buildKardexView(l10n)
                : _buildStockMatrix(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildStockMatrix(AppLocalizations l10n) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final items = _provider.stockItems;

    if (_provider.status == FeatureStatusEnum.loading) {
      return Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? const AppSkeletonTable(rowCount: 5, columnCount: 5)
              : const AppSkeletonList(itemCount: 4),
        ),
      );
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.stockLevelsWarehouse(
                _provider.selectedWarehouse?.name ?? l10n.mainWarehouse,
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 24),
            if (isDesktop)
              WarehouseStockTableDesktop(
                items: items,
                onTransfer: _showTransferModal,
                onAdjust: _showAdjustModal,
              )
            else
              WarehouseStockListMobile(
                items: items,
                onTransfer: _showTransferModal,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKardexView(AppLocalizations l10n) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final movements = _provider.movements;

    if (_provider.status == FeatureStatusEnum.loading) {
      return Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? const AppSkeletonTable(rowCount: 6, columnCount: 6)
              : const AppSkeletonList(itemCount: 4),
        ),
      );
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.kardexLedgerHeader,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 24),
            if (isDesktop)
              KardexTableDesktop(movements: movements)
            else
              KardexListMobile(movements: movements),
          ],
        ),
      ),
    );
  }
}
