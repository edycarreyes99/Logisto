import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Interactive operations card built with Flutter Material Design 3.
/// Conforms to RULE-UI-006 and RULE-UI-001.
class ControlPanelCard extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const ControlPanelCard({
    super.key,
    required this.searchController,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.operationalControls,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: l10n.filterLogsOrTelemetry,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            _buildActions(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          onPressed: onIncrement,
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.increment),
        ),
        OutlinedButton(
          onPressed: onReset,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
          ),
          child: Text(l10n.reset),
        ),
      ],
    );
  }
}
