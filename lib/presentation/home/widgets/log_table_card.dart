import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Data card rendering system telemetry using adaptive presentation.
/// Renders a [DataTable] on wider displays and [ListTile] widgets on compact screens.
/// Conforms to RULE-UI-006, RULE-UI-007, and RULE-UI-001.
class LogTableCard extends StatelessWidget {
  const LogTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < BsBreakpoints.lg;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.liveEventStream,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              isCompact ? _buildMobileList(l10n) : _buildDesktopTable(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTable(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.tableHeaderService)),
          DataColumn(label: Text(l10n.tableHeaderTarget)),
          DataColumn(label: Text(l10n.tableHeaderStatus)),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(Text(l10n.serviceCore)),
              DataCell(Text(l10n.targetDarwinWin32)),
              DataCell(Chip(label: Text(l10n.statusActive))),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text(l10n.serviceWeb)),
              DataCell(Text(l10n.targetWasmMobile)),
              DataCell(Chip(label: Text(l10n.statusReady))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(AppLocalizations l10n) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.serviceCore,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(l10n.targetDarwinWin32),
          trailing: Chip(label: Text(l10n.statusActive)),
        ),
        const Divider(height: 1),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            l10n.serviceWeb,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(l10n.targetWasmMobile),
          trailing: Chip(label: Text(l10n.statusReady)),
        ),
      ],
    );
  }
}
