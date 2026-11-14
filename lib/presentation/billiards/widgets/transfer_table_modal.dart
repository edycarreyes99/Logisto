import 'package:flutter/material.dart';
import '../../../core/enums/table_status_enum.dart';
import '../../../domain/models/billiard_table_model.dart';
import '../../../l10n/app_localizations.dart';
import '../billiard_provider.dart';

/// Modal dialog for transferring an active billiard game to another station.
class TransferTableModal extends StatefulWidget {
  final BilliardTableModel sourceTable;
  final BilliardProvider provider;

  const TransferTableModal({
    super.key,
    required this.sourceTable,
    required this.provider,
  });

  @override
  State<TransferTableModal> createState() => _TransferTableModalState();
}

class _TransferTableModalState extends State<TransferTableModal> {
  String? _selectedTargetId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final available = widget.provider.tables
        .where(
          (t) =>
              t.id != widget.sourceTable.id &&
              t.status == TableStatusEnum.available,
        )
        .toList();

    return AlertDialog(
      title: Text(
        l10n.transferTableNamed(widget.sourceTable.name),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: _buildBody(available, l10n),
      actions: _buildActions(l10n),
    );
  }

  Widget _buildBody(List<BilliardTableModel> available, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.selectDestinationTablePrompt),
        const SizedBox(height: 16),
        if (available.isEmpty)
          Card(
            color: theme.colorScheme.tertiaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                l10n.noTablesAvailableForTransfer,
                style: TextStyle(color: theme.colorScheme.onTertiaryContainer),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: available.map((target) {
              final isSel = _selectedTargetId == target.id;
              return ChoiceChip(
                label: Text(target.name),
                selected: isSel,
                onSelected: (val) {
                  setState(() => _selectedTargetId = val ? target.id : null);
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  List<Widget> _buildActions(AppLocalizations l10n) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l10n.cancel),
      ),
      FilledButton(
        onPressed: _selectedTargetId == null
            ? null
            : () {
                widget.provider.transferTable(
                  fromTableId: widget.sourceTable.id,
                  toTableId: _selectedTargetId!,
                );
                Navigator.of(context).pop();
              },
        child: Text(l10n.confirmTransfer),
      ),
    ];
  }
}
