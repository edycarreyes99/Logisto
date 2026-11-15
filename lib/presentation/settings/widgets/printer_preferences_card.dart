import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../printer_management_provider.dart';

/// Sub-widget rendering the auto-print toggle switch for receipt dispatch.
class PrinterPreferencesCard extends StatelessWidget {
  final PrinterManagementProvider provider;

  const PrinterPreferencesCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderOf(context).withValues(alpha: 0.5)),
      ),
      child: SwitchListTile.adaptive(
        title: Text(
          l10n.autoPrintOnSaleLabel,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.autoPrintOnSaleSubtitle),
        value: provider.autoPrintOnSale,
        onChanged: provider.toggleAutoPrint,
      ),
    );
  }
}
