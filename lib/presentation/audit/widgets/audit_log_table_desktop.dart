import 'package:flutter/material.dart';
import '../../../core/enums/audit_action_enum.dart';
import '../../../domain/models/audit_log_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../common/enum_localization_extensions.dart';

/// Desktop high-density table rendering immutable security audit trail entries.
class AuditLogTableDesktop extends StatelessWidget {
  final List<AuditLogModel> logs;

  const AuditLogTableDesktop({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 12,
            horizontalMargin: 8,
            columns: [
              DataColumn(label: Text(l10n.tableHeaderTimestamp)),
              DataColumn(label: Text(l10n.tableHeaderUser)),
              DataColumn(label: Text(l10n.tableHeaderAction)),
              DataColumn(label: Text(l10n.tableHeaderDescription)),
              DataColumn(label: Text(l10n.tableHeaderBeforeAfter)),
              DataColumn(label: Text(l10n.tableHeaderClientIp)),
            ],
            rows: logs.map((log) => _buildRow(log, l10n, theme)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(
    AuditLogModel entry,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';
    final beforeAfter = entry.previousValue != null && entry.newValue != null
        ? '${entry.previousValue} -> ${entry.newValue}'
        : '-';

    return DataRow(
      cells: [
        DataCell(
          Text(
            timeStr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(entry.userDisplayName)),
        DataCell(_buildActionChip(entry.action, l10n, theme)),
        DataCell(
          SizedBox(
            width: 260,
            child: Text(
              entry.description,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Text(beforeAfter, style: const TextStyle(fontSize: 11)),
        ),
        DataCell(
          Text(
            entry.clientIp ?? l10n.unknown,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(
    AuditActionEnum action,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final isDanger = action == AuditActionEnum.voidItem ||
        action == AuditActionEnum.voidInvoice;
    final isWarning = action == AuditActionEnum.applyDiscount;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDanger
        ? theme.colorScheme.errorContainer
        : (isWarning
            ? (isDark ? AppColors.warningContainerDark : AppColors.warningContainerLight)
            : theme.colorScheme.primaryContainer);
    final textColor = isDanger
        ? theme.colorScheme.onErrorContainer
        : (isWarning
            ? (isDark ? AppColors.onWarningContainerDark : AppColors.onWarningContainerLight)
            : theme.colorScheme.onPrimaryContainer);

    return Chip(
      label: Text(
        action.localizedTitle(l10n).toUpperCase(),
        style: TextStyle(fontSize: 10, color: textColor),
      ),
      backgroundColor: bgColor,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
