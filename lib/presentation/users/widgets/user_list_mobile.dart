import 'package:flutter/material.dart';
import '../../../domain/models/user_profile_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

/// Touch-friendly mobile list for enterprise user administration.
class UserListMobile extends StatelessWidget {
  final List<UserProfileModel> users;
  final ValueChanged<UserProfileModel> onEditRole;

  const UserListMobile({
    super.key,
    required this.users,
    required this.onEditRole,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: users.map((u) => _buildCard(u, l10n, theme)).toList(),
    );
  }

  Widget _buildCard(
    UserProfileModel user,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(user.email, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      user.isSuperAdmin ? l10n.superAdminShort : l10n.staff,
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
                ],
              ),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () => onEditRole(user),
              child: Text(l10n.roles),
            ),
          ],
        ),
      ),
    );
  }
}
