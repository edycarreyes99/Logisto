import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/purchase_order_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'purchase_order_provider.dart';
import 'widgets/purchase_order_list_mobile.dart';
import 'widgets/purchase_order_table_desktop.dart';

/// Screen managing supplier purchase orders, inbound goods reception,
/// and inventory valuation updates.
class PurchaseOrderScreen extends StatefulWidget {
  const PurchaseOrderScreen({super.key});

  @override
  State<PurchaseOrderScreen> createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  late final PurchaseOrderProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<PurchaseOrderProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadOrders(orgId: orgId, buId: buId);
      });
    }
  }

  void _showCreateOrderModal() {
    final l10n = AppLocalizations.of(context)!;
    final supplierCtrl = TextEditingController(text: 'Compañía Cervecera');
    final amountCtrl = TextEditingController(text: '300.00');

    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            l10n.createPurchaseOrder,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: supplierCtrl,
                decoration: InputDecoration(
                  labelText: l10n.supplierName,
                  hintText: l10n.supplierName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                decoration: InputDecoration(
                  labelText: l10n.estimatedTotalOrderValue,
                  hintText: l10n.estimatedTotalOrderValue,
                  border: const OutlineInputBorder(),
                  prefixText: '\$ ',
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
              label: Text(l10n.issueOrder),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final buId = _contextProvider.activeBusinessUnit?.id ?? '';
                      final total = double.tryParse(amountCtrl.text) ?? 100.0;
                      final order = PurchaseOrderModel(
                        id: 'PO-${DateTime.now().millisecondsSinceEpoch % 10000}',
                        buId: buId,
                        supplierId: 'sup_01',
                        supplierName: supplierCtrl.text,
                        orderDate: DateTime.now(),
                        totalAmount: total,
                        status: 'pending',
                      );
                      await _provider.createOrder(order);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Orden de compra #${order.id} creada',
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
      title: l10n.purchasing,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: FilledButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.createPurchaseOrderAction),
            onPressed: _showCreateOrderModal,
          ),
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
    final orders = _provider.orders;
    final theme = Theme.of(context);

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
        child: orders.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    l10n.noPurchaseOrdersRecorded,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            : (isDesktop
                ? PurchaseOrderTableDesktop(
                    orders: orders,
                    onReceive: (id) {
                      _provider.receiveGoods(id);
                      AppFeedback.showSuccess(context, 'Mercancía recibida en almacén');
                    },
                  )
                : PurchaseOrderListMobile(
                    orders: orders,
                    onReceive: (id) {
                      _provider.receiveGoods(id);
                      AppFeedback.showSuccess(context, 'Mercancía recibida en almacén');
                    },
                  )),
      ),
    );
  }
}
