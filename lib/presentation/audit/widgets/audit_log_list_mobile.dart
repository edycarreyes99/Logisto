import 'package:flutter/material.dart';
import '../../../core/enums/audit_action_enum.dart';
import '../../../domain/models/audit_log_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../common/enum_localization_extensions.dart';

/// Touch-friendly mobile list for enterprise audit logs.
class AuditLogListMobile extends StatelessWidget {
  final List<AuditLogModel> logs;

  const AuditLogListMobile({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: logs.map((l) => _buildCard(l, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    AuditLogModel entry,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final timeStr =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.userDisplayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionChip(entry.action, l10n, theme),
              ],
            ),
            const SizedBox(height: 4),
            Text(entry.description, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timeStr, style: const TextStyle(fontSize: 11)),
                Text(
                  'IP: ${entry.clientIp ?? "-"}',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
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
