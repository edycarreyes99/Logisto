import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/logisto_scaffold.dart';
import '../printer_management_provider.dart';
import '../widgets/active_printer_card.dart';
import '../widgets/discovered_printers_list.dart';
import '../widgets/printer_alias_edit_dialog.dart';
import '../widgets/printer_preferences_card.dart';

/// Screen enabling discovery, alias configuration, paper format selection,
/// and test-printing for thermal, dot-matrix, USB, and Bluetooth receipt printers.
class PrinterManagementScreen extends StatefulWidget {
  const PrinterManagementScreen({super.key});

  @override
  State<PrinterManagementScreen> createState() =>
      _PrinterManagementScreenState();
}

class _PrinterManagementScreenState extends State<PrinterManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrinterManagementProvider>().scanForPrinters();
    });
  }

  void _showAliasDialog(
    BuildContext context,
    PrinterManagementProvider provider,
  ) {
    PrinterAliasEditDialog.show(context, provider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<PrinterManagementProvider>();

    return LogistoScaffold(
      title: l10n.printerManagementTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusBanners(context, provider),
            ActivePrinterCard(
              provider: provider,
              onEditAlias: () => _showAliasDialog(context, provider),
            ),
            const SizedBox(height: 16),
            PrinterPreferencesCard(provider: provider),
            const SizedBox(height: 24),
            _buildDiscoveryHeader(context, provider, l10n),
            const SizedBox(height: 12),
            DiscoveredPrintersList(provider: provider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanners(
    BuildContext context,
    PrinterManagementProvider provider,
  ) {
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
                Icon(
                  Icons.error_outline_rounded,
                  color: theme.colorScheme.onErrorContainer,
                ),
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
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green,
                ),
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

  Widget _buildDiscoveryHeader(
    BuildContext context,
    PrinterManagementProvider provider,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.discoveredPrinters,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.printerManagementSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
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
          label: Text(
            provider.isScanning
                ? l10n.scanningPrinters
                : l10n.scanBluetoothPrinters,
          ),
        ),
      ],
    );
  }
}
