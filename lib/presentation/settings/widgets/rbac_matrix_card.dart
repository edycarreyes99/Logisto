import 'package:flutter/material.dart';
import '../../../domain/models/rbac_permission_model.dart';
import '../../../l10n/app_localizations.dart';
import '../settings_provider.dart';

/// Card rendering granular RBAC macro modules and micro permissions matrix.
class RbacMatrixCard extends StatelessWidget {
  final SettingsProvider provider;

  const RbacMatrixCard({super.key, required this.provider});

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
              l10n.rbacSecurityMatrix,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTable(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(AppLocalizations l10n, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        horizontalMargin: 8,
        columns: [
          DataColumn(label: Text(l10n.tableHeaderRoleKey)),
          DataColumn(
            label: Text(l10n.tableHeaderAccessibleModules),
          ),
          DataColumn(
            label: Text(l10n.tableHeaderSensitivePermissions),
          ),
        ],
        rows: provider.rbacRoles
            .map((r) => _buildRow(l10n, r, theme))
            .toList(),
      ),
    );
  }

  DataRow _buildRow(
    AppLocalizations l10n,
    RbacPermissionModel role,
    ThemeData theme,
  ) {
    final isSuperAdmin = role.roleKey == 'SUPER_ADMIN_ORG';
    return DataRow(
      cells: [
        DataCell(
          Chip(
            label: Text(
              role.roleKey,
              style: TextStyle(
                fontSize: 11,
                color: isSuperAdmin
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            backgroundColor: isSuperAdmin
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(
          Text(
            role.macroModules.join(', '),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            role.microPermissions.isEmpty
                ? l10n.noneRequiresSupervisorPin
                : role.microPermissions.join(', '),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
