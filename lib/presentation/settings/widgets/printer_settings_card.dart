import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../printer_management_provider.dart';
import 'active_printer_card.dart';
import 'discovered_printers_list.dart';
import 'printer_alias_edit_dialog.dart';
import 'printer_preferences_card.dart';

/// Embedded settings card for configuring receipts and managing connected printers.
class PrinterSettingsCard extends StatelessWidget {
  final PrinterManagementProvider provider;

  const PrinterSettingsCard({
    super.key,
    required this.provider,
  });

  void _showAliasDialog(BuildContext context) {
    PrinterAliasEditDialog.show(context, provider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStatusBanners(context),
        ActivePrinterCard(
          provider: provider,
          onEditAlias: () => _showAliasDialog(context),
        ),
        const SizedBox(height: 16),
        PrinterPreferencesCard(provider: provider),
        const SizedBox(height: 24),
        _buildDiscoveryHeader(context, l10n),
        const SizedBox(height: 12),
        DiscoveredPrintersList(provider: provider),
      ],
    );
  }

  Widget _buildStatusBanners(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildDiscoveryHeader(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.discoveredPrinters,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.printerManagementSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
        FilledButton.tonalIcon(
          onPressed: provider.isScanning ? null : provider.scanForPrinters,
          icon: provider.isScanning
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded, size: 18),
          label: Text(provider.isScanning ? l10n.scanningPrinters : l10n.scanBluetoothPrinters),
        ),
      ],
    );
  }
}
