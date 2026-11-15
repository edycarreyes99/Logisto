import 'package:flutter/material.dart';
import '../../../../domain/models/printer_device_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../printer_management_provider.dart';

/// Sub-widget displaying the currently paired active printer and quick action controls.
class ActivePrinterCard extends StatelessWidget {
  final PrinterManagementProvider provider;
  final VoidCallback onEditAlias;

  const ActivePrinterCard({
    super.key,
    required this.provider,
    required this.onEditAlias,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final activePrinter = provider.savedPrinter;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
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
                          ? AppColors.success
                          : theme.colorScheme.primary,
                    ),
                    label: Text(
                      activePrinter.connectionType.storageKey.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    backgroundColor: activePrinter.connectionType == PrinterConnectionType.usb
                        ? AppColors.successContainerLight
                        : theme.colorScheme.primaryContainer,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l10n.editPrinterAlias,
                    onPressed: onEditAlias,
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
                      Text('${l10n.hardwareLabel}: ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
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
    );
  }
}
