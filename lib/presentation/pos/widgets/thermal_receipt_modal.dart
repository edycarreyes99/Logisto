import 'package:flutter/material.dart';
import '../../../domain/models/invoice_model.dart';
import '../../../domain/models/printer_device_model.dart';
import '../../../domain/services/printer_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../locator.dart';
import '../../settings/printer_management_provider.dart';

/// Interactive modal displaying the receipt and offering immediate thermal/matrix printing,
/// OS preview dialog, and PDF sharing.
class ThermalReceiptModal extends StatefulWidget {
  final InvoiceModel invoice;
  final String organizationName;
  final String branchName;
  final VoidCallback onNewSale;

  const ThermalReceiptModal({
    super.key,
    required this.invoice,
    required this.organizationName,
    required this.branchName,
    required this.onNewSale,
  });

  @override
  State<ThermalReceiptModal> createState() => _ThermalReceiptModalState();
}

class _ThermalReceiptModalState extends State<ThermalReceiptModal> {
  bool _isPrinting = false;

  Future<void> _handleDirectPrint(BuildContext context) async {
    setState(() => _isPrinting = true);
    final printerService = locator<IPrinterService>();
    try {
      await printerService.printReceipt(
        invoice: widget.invoice,
        businessName: widget.organizationName,
        branchName: widget.branchName,
      );
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  Future<void> _handlePreview(BuildContext context) async {
    final printerService = locator<IPrinterService>();
    await printerService.openPrintDialog(
      invoice: widget.invoice,
      businessName: widget.organizationName,
      branchName: widget.branchName,
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    final printerService = locator<IPrinterService>();
    await printerService.shareReceiptPdf(
      invoice: widget.invoice,
      businessName: widget.organizationName,
      branchName: widget.branchName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final printerProvider = locator<PrinterManagementProvider>();
    final activePrinter = printerProvider.savedPrinter;

    return AlertDialog(
      title: _buildTitle(l10n, activePrinter?.displayName),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activePrinter != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        activePrinter.connectionType == PrinterConnectionType.usb
                            ? Icons.usb_rounded
                            : Icons.bluetooth_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Impresora: ${activePrinter.displayName}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: _buildReceiptContent(l10n),
              ),
            ],
          ),
        ),
      ),
      actions: _buildActions(context, l10n),
    );
  }

  Widget _buildTitle(AppLocalizations l10n, String? printerName) {
    return Row(
      children: [
        const Icon(Icons.receipt_long_rounded),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.salesReceipt,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, AppLocalizations l10n) {
    return [
      IconButton(
        icon: const Icon(Icons.share_outlined),
        tooltip: l10n.shareVoucher,
        onPressed: () => _handleShare(context),
      ),
      IconButton(
        icon: const Icon(Icons.preview_outlined),
        tooltip: l10n.previewVoucher,
        onPressed: () => _handlePreview(context),
      ),
      OutlinedButton.icon(
        icon: _isPrinting
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.print_rounded, size: 18),
        label: Text(l10n.printTicket),
        onPressed: _isPrinting ? null : () => _handleDirectPrint(context),
      ),
      FilledButton.icon(
        icon: const Icon(Icons.add_shopping_cart, size: 18),
        label: Text(l10n.newSaleAction),
        onPressed: () {
          Navigator.of(context).pop();
          widget.onNewSale();
        },
      ),
    ];
  }

  Widget _buildReceiptContent(AppLocalizations l10n) {
    final invoice = widget.invoice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            widget.organizationName.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Center(
          child: Text(
            widget.branchName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FAC: ${invoice.invoiceNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              '${invoice.issuedAt.hour}:${invoice.issuedAt.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        Text(
          '${l10n.customer}: ${invoice.customerDisplayName}',
          style: const TextStyle(fontSize: 12),
        ),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        ...invoice.items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity.toInt()}x ${item.name}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  '\$${item.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.subtotalLabel),
            Text('\$${invoice.subtotal.toStringAsFixed(2)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.tax15Percent),
            Text('\$${invoice.taxAmount.toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.total,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              '\$${invoice.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '------------------------------------------------',
          textAlign: TextAlign.center,
        ),
        ...invoice.payments.map((p) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${p.method.storageKey.toUpperCase()}:',
                style: const TextStyle(fontSize: 11),
              ),
              Text(
                '\$${p.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          );
        }),
        const SizedBox(height: 12),
        Center(
          child: Text(
            l10n.thankYouForBusiness,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
