import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../reports_provider.dart';

/// Desktop high-density table displaying business intelligence report rows.
class ReportsTableDesktop extends StatelessWidget {
  final List<ReportRowItem> rows;
  final String title;

  const ReportsTableDesktop({
    super.key,
    required this.rows,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 12,
                columns: [
                  DataColumn(label: Text(l10n.tableHeaderItemConcept)),
                  DataColumn(label: Text(l10n.tableHeaderDetailsSku)),
                  DataColumn(label: Text(l10n.tableHeaderMetric1)),
                  DataColumn(label: Text(l10n.tableHeaderMetric2)),
                  DataColumn(label: Text(l10n.tableHeaderStatusRatio)),
                ],
                rows: rows.map((r) => _buildRow(r, theme)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(ReportRowItem r, ThemeData theme) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            r.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(
          Text(r.subtitle, style: const TextStyle(fontSize: 12)),
        ),
        DataCell(Text(r.metric1)),
        DataCell(Text(r.metric2)),
        DataCell(
          Chip(
            label: Text(
              r.tag,
              style: TextStyle(
                fontSize: 11,
                color: r.isWarning
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            backgroundColor: r.isWarning
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
