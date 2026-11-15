import 'package:flutter/material.dart';
import '../../../core/enums/user_status_enum.dart';
import '../../../domain/models/user_profile_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// High-density desktop table rendering enterprise users and their assigned roles.
class UserTableDesktop extends StatelessWidget {
  final List<UserProfileModel> users;
  final ValueChanged<UserProfileModel> onEditRole;

  const UserTableDesktop({
    super.key,
    required this.users,
    required this.onEditRole,
  });

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
            columnSpacing: 16,
            horizontalMargin: 8,
            columns: [
              DataColumn(label: Text(l10n.tableHeaderUserName)),
              DataColumn(label: Text(l10n.tableHeaderUserEmail)),
              DataColumn(label: Text(l10n.tableHeaderSuperAdmin)),
              DataColumn(label: Text(l10n.tableHeaderAssignedBranches)),
              DataColumn(label: Text(l10n.tableHeaderStatus)),
              DataColumn(label: Text(l10n.tableHeaderActions)),
            ],
            rows: users.map((u) => _buildRow(u, l10n, theme)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(
    UserProfileModel user,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final branchCount = user.businessUnitRoles.length;
    final isActive = user.status == UserStatusEnum.active;

    return DataRow(
      cells: [
        DataCell(
          Text(
            user.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        DataCell(Text(user.email)),
        DataCell(
          Chip(
            label: Text(
              user.isSuperAdmin ? l10n.yes : l10n.no,
              style: TextStyle(
                fontSize: 11,
                color: user.isSuperAdmin
                    ? (theme.brightness == Brightness.dark
                          ? AppColors.onWarningContainerDark
                          : AppColors.onWarningContainerLight)
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            backgroundColor: user.isSuperAdmin
                ? (theme.brightness == Brightness.dark
                      ? AppColors.warningContainerDark
                      : AppColors.warningContainerLight)
                : theme.colorScheme.surfaceContainerHighest,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(Text(l10n.branchCountLabel(branchCount))),
        DataCell(
          Chip(
            label: Text(
              isActive ? l10n.statusActive : l10n.statusInactive,
              style: TextStyle(
                fontSize: 11,
                color: isActive
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onErrorContainer,
              ),
            ),
            backgroundColor: isActive
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.errorContainer,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => onEditRole(user),
            child: Text(l10n.edit),
          ),
        ),
      ],
    );
  }
}
