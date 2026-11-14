import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/invoice_model.dart';
import '../../domain/services/printer_service.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'invoice_history_provider.dart';
import 'widgets/invoice_list_mobile.dart';
import 'widgets/invoice_table_desktop.dart';

/// Screen listing historical invoices, audit details, and cancellation workflows.
class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key});

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  late final InvoiceHistoryProvider _provider;
  late final BusinessContextProvider _contextProvider;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = locator<InvoiceHistoryProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadInvoices(orgId: orgId, buId: buId);
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showDetailModal(InvoiceModel inv) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.invoiceTitle(inv.invoiceNumber),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.customerLabel(inv.customerDisplayName)),
              Text(l10n.cashierLabel(inv.cashierUserId)),
              const SizedBox(height: 12),
              Text(
                l10n.itemsBilled,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 12),
              ...inv.items.map(
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${i.quantity.toInt()}x ${i.name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('\$${i.total.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.totalPaid,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${inv.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            icon: const Icon(Icons.print_rounded, size: 16),
            label: Text(l10n.reprintVoucher),
            onPressed: () {
              final printerService = locator<IPrinterService>();
              printerService.printReceipt(
                invoice: inv,
                businessName: _contextProvider.activeOrganization?.commercialName,
                branchName: _contextProvider.activeBusinessUnit?.name,
              );
              AppFeedback.showSuccess(context, 'Enviando voucher a impresión...');
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 18),
            tooltip: l10n.shareVoucher,
            onPressed: () {
              final printerService = locator<IPrinterService>();
              printerService.shareReceiptPdf(
                invoice: inv,
                businessName: _contextProvider.activeOrganization?.commercialName,
                branchName: _contextProvider.activeBusinessUnit?.name,
              );
            },
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showVoidModal(String id) {
    final l10n = AppLocalizations.of(context)!;
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            l10n.voidInvoiceTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(l10n.voidInvoiceDesc),
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
                  : const Icon(Icons.cancel_outlined, size: 18),
              label: Text(l10n.confirmVoid),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      await _provider.voidInvoice(id);
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showWarning(
                          context,
                          'Factura anulada en el sistema',
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
      title: l10n.invoices,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: l10n.refresh,
          onPressed: () {
            final orgId = _contextProvider.activeOrganization?.id ?? '';
            final buId = _contextProvider.activeBusinessUnit?.id ?? '';
            if (orgId.isNotEmpty) {
              _provider.loadInvoices(orgId: orgId, buId: buId);
              AppFeedback.showSuccess(context, 'Historial de facturas actualizado');
            }
          },
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
    final invoices = _provider.filteredInvoices;
    final theme = Theme.of(context);

    if (_provider.status == FeatureStatusEnum.loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 280,
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: l10n.searchInvoiceOrCustomer,
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
        SizedBox(
          width: 280,
          child: TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: l10n.searchInvoiceOrCustomer,
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
            child: invoices.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        l10n.noInvoicesRecorded,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : (isDesktop
                    ? InvoiceTableDesktop(
                        invoices: invoices,
                        onView: _showDetailModal,
                        onVoid: _showVoidModal,
                      )
                    : InvoiceListMobile(
                        invoices: invoices,
                        onView: _showDetailModal,
                      )),
          ),
        ),
      ],
    );
  }
}
