import 'package:flutter/material.dart';
import '../../../core/enums/account_origin_type_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../open_accounts_provider.dart';

/// Modal dialog for opening a new customer or counter tab.
class OpenNewTabDialog extends StatefulWidget {
  final OpenAccountsProvider provider;

  const OpenNewTabDialog({super.key, required this.provider});

  /// Displays the dialog.
  static Future<void> show(
    BuildContext context,
    OpenAccountsProvider provider,
  ) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => OpenNewTabDialog(provider: provider),
    );
  }

  @override
  State<OpenNewTabDialog> createState() => _OpenNewTabDialogState();
}

class _OpenNewTabDialogState extends State<OpenNewTabDialog> {
  final _nameCtrl = TextEditingController();
  AccountOriginTypeEnum _selectedOrigin = AccountOriginTypeEnum.counter;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave(AppLocalizations l10n) async {
    setState(() => _isSaving = true);
    final tabName = _nameCtrl.text.trim().isEmpty
        ? _selectedOrigin.localizedTitle(l10n)
        : _nameCtrl.text.trim();

    try {
      await widget.provider.createNewAccount(
        name: tabName,
        originType: _selectedOrigin,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.openNewTabTitle),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.customerTableAliasPlaceholder,
                hintText: l10n.customerTableAliasPlaceholder,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<AccountOriginTypeEnum>(
              segments: [
                ButtonSegment(
                  value: AccountOriginTypeEnum.counter,
                  label: Text(AccountOriginTypeEnum.counter.localizedTitle(l10n)),
                  icon: const Icon(Icons.storefront_outlined),
                ),
                ButtonSegment(
                  value: AccountOriginTypeEnum.table,
                  label: Text(AccountOriginTypeEnum.table.localizedTitle(l10n)),
                  icon: const Icon(Icons.table_restaurant_outlined),
                ),
                ButtonSegment(
                  value: AccountOriginTypeEnum.freeName,
                  label: Text(AccountOriginTypeEnum.freeName.localizedTitle(l10n)),
                  icon: const Icon(Icons.person_outline),
                ),
              ],
              selected: {_selectedOrigin},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) {
                  setState(() => _selectedOrigin = set.first);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.check, size: 18),
          label: Text(l10n.openTabAction),
          onPressed: _isSaving ? null : () => _handleSave(l10n),
        ),
      ],
    );
  }
}
