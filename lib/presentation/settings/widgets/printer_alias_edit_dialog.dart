import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../printer_management_provider.dart';

/// Modal dialog for editing the friendly alias of a saved printer.
class PrinterAliasEditDialog extends StatefulWidget {
  final PrinterManagementProvider provider;

  const PrinterAliasEditDialog({super.key, required this.provider});

  static Future<void> show(BuildContext context, PrinterManagementProvider provider) {
    return showDialog(
      context: context,
      builder: (ctx) => PrinterAliasEditDialog(provider: provider),
    );
  }

  @override
  State<PrinterAliasEditDialog> createState() => _PrinterAliasEditDialogState();
}

class _PrinterAliasEditDialogState extends State<PrinterAliasEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.provider.savedPrinter?.customAlias ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.editPrinterAlias),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
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
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () async {
            await widget.provider.updatePrinterAlias(_controller.text);
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
