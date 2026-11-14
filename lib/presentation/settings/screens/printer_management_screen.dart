import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/printer_device_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/logisto_scaffold.dart';
import '../printer_management_provider.dart';

/// Screen enabling discovery, alias configuration, paper format selection,
/// and test-printing for thermal, dot-matrix, USB, and Bluetooth receipt printers.
class PrinterManagementScreen extends StatefulWidget {
  const PrinterManagementScreen({super.key});

  @override
  State<PrinterManagementScreen> createState() => _PrinterManagementScreenState();
}

class _PrinterManagementScreenState extends State<PrinterManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrinterManagementProvider>().scanForPrinters();
    });
  }

  void _showAliasEditDialog(BuildContext context, PrinterManagementProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final currentAlias = provider.savedPrinter?.customAlias ?? '';
    final controller = TextEditingController(text: currentAlias);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.editPrinterAlias),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.printerAliasLabel,
                  hintText: l10n.printerAliasPlaceholder,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                await provider.updatePrinterAlias(controller.text);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = context.watch<PrinterManagementProvider>();
    final activePrinter = provider.savedPrinter;

    return LogistoScaffold(
      title: l10n.printerManagementTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status messages banner
            if (provider.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: provider.clearMessages,
                    ),
                  ],
                ),
              ),

            if (provider.successMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.successMessage!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: provider.clearMessages,
                    ),
                  ],
                ),
              ),

            // Active / Connected Printer Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: activePrinter != null
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.print_rounded,
                            color: activePrinter != null
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.activePrinter,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                activePrinter != null
                                    ? activePrinter.displayName
                                    : l10n.noActivePrinter,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (activePrinter != null) ...[
                          Chip(
                            avatar: Icon(
                              activePrinter.connectionType == PrinterConnectionType.usb
                                  ? Icons.usb_rounded
                                  : Icons.bluetooth_rounded,
                              size: 16,
                              color: activePrinter.connectionType == PrinterConnectionType.usb
                                  ? Colors.teal
                                  : Colors.blue,
                            ),
                            label: Text(
                              activePrinter.connectionType.storageKey.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                            backgroundColor: activePrinter.connectionType == PrinterConnectionType.usb
                                ? Colors.teal.shade50
                                : Colors.blue.shade50,
                            side: BorderSide.none,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: l10n.editPrinterAlias,
                            onPressed: () => _showAliasEditDialog(context, provider),
                          ),
                        ],
                      ],
                    ),
                    if (activePrinter != null) ...[
                      const Divider(height: 24),
                      if (activePrinter.customAlias.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Text('Hardware: ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                              Text(activePrinter.rawName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                        ),
                      if (activePrinter.macAddress.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Text('${l10n.macAddressLabel}: ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                              Text(activePrinter.macAddress, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      // Format selector
                      Row(
                        children: [
                          Text('${l10n.printerTypeLabel}: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          DropdownButton<PrinterHardwareType>(
                            value: activePrinter.hardwareType,
                            underline: const SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: PrinterHardwareType.thermal80mm,
                                child: Text(l10n.printerTypeThermal80),
                              ),
                              DropdownMenuItem(
                                value: PrinterHardwareType.thermal58mm,
                                child: Text(l10n.printerTypeThermal58),
                              ),
                              DropdownMenuItem(
                                value: PrinterHardwareType.dotMatrix,
                                child: Text(l10n.printerTypeDotMatrix),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) provider.updateHardwareType(val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonalIcon(
                            icon: provider.isPrintingTest
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.receipt_long_rounded, size: 18),
                            label: Text(l10n.printTestTicket),
                            onPressed: provider.isPrintingTest ? null : provider.printTestTicket,
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.link_off_rounded, size: 18),
                            label: Text(l10n.disconnectPrinter),
                            onPressed: provider.disconnectSavedPrinter,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Printing Preferences Card (Auto-print)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: SwitchListTile.adaptive(
                title: Text(l10n.autoPrintOnSaleLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.autoPrintOnSaleSubtitle),
                value: provider.autoPrintOnSale,
                onChanged: provider.toggleAutoPrint,
              ),
            ),
            const SizedBox(height: 24),

            // Discovered / Nearby Devices Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.discoveredPrinters,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${provider.discoveredPrinters.length} dispositivos detectados',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                FilledButton.icon(
                  icon: provider.isScanning
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(l10n.scanBluetoothPrinters),
                  onPressed: provider.isScanning ? null : provider.scanForPrinters,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // List of discovered devices
            if (provider.isScanning && provider.discoveredPrinters.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(l10n.scanningPrinters),
                    ],
                  ),
                ),
              )
            else if (provider.discoveredPrinters.isEmpty)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        Icon(Icons.print_disabled_rounded, size: 40, color: theme.colorScheme.outline),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noDiscoveredPrinters,
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...provider.discoveredPrinters.map((device) {
                final isCurrent = activePrinter != null &&
                    (activePrinter.id == device.id || activePrinter.rawName == device.rawName);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: device.connectionType == PrinterConnectionType.usb
                            ? Colors.teal.shade50
                            : Colors.blue.shade50,
                        child: Icon(
                          device.connectionType == PrinterConnectionType.usb
                              ? Icons.usb_rounded
                              : Icons.bluetooth_rounded,
                          color: device.connectionType == PrinterConnectionType.usb
                              ? Colors.teal
                              : Colors.blue,
                        ),
                      ),
                      title: Text(
                        device.rawName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (device.macAddress.isNotEmpty)
                            Text(
                              device.macAddress,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                            ),
                          Text(
                            device.connectionType == PrinterConnectionType.usb
                                ? 'USB Direct Print'
                                : 'Bluetooth Thermal / Matrix',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      trailing: isCurrent
                          ? const Chip(
                              label: Text('Activa', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              backgroundColor: Color(0xFFE8F5E9),
                              side: BorderSide.none,
                            )
                          : FilledButton.tonal(
                              onPressed: () async {
                                await provider.selectPrinter(device);
                              },
                              child: Text(l10n.connectPrinter),
                            ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
