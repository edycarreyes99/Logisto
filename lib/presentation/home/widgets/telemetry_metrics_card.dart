import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Telemetry metrics display card built with Flutter Material Design 3.
/// Conforms to RULE-UI-006 and RULE-UI-001.
class TelemetryMetricsCard extends StatelessWidget {
  final int counter;

  const TelemetryMetricsCard({super.key, required this.counter});

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
              l10n.telemetryAndStatus,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTasksRow(l10n, theme),
            const SizedBox(height: 12),
            _buildStatusBanner(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksRow(AppLocalizations l10n, ThemeData theme) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text(l10n.processedTasks, style: theme.textTheme.bodyMedium),
        Chip(
          label: Text('$counter'),
          backgroundColor: theme.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBanner(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.telemetryNodeOperational,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
