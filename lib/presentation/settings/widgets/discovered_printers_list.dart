import 'package:flutter/material.dart';
import '../../../../domain/models/printer_device_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../printer_management_provider.dart';

/// Sub-widget rendering scanned/discovered USB and Bluetooth printer devices.
class DiscoveredPrintersList extends StatelessWidget {
  final PrinterManagementProvider provider;

  const DiscoveredPrintersList({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final activePrinter = provider.savedPrinter;

    if (provider.isScanning && provider.discoveredPrinters.isEmpty) {
      return Center(
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
      );
    }

    if (provider.discoveredPrinters.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
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
      );
    }

    return Column(
      children: provider.discoveredPrinters.map((device) {
        final isCurrent = activePrinter != null &&
            (activePrinter.id == device.id || activePrinter.rawName == device.rawName);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: device.connectionType == PrinterConnectionType.usb
                    ? AppColors.successContainerLight
                    : theme.colorScheme.primaryContainer,
                child: Icon(
                  device.connectionType == PrinterConnectionType.usb
                      ? Icons.usb_rounded
                      : Icons.bluetooth_rounded,
                  color: device.connectionType == PrinterConnectionType.usb
                      ? AppColors.success
                      : theme.colorScheme.primary,
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
                  ? Chip(
                      label: Text(
                        l10n.activeChipLabel,
                        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppColors.successContainerLight,
                      side: BorderSide.none,
                    )
                  : FilledButton.tonal(
                      onPressed: () => provider.selectPrinter(device),
                      child: Text(l10n.connectPrinter),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
