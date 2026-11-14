import 'package:flutter/material.dart';
import '../../../core/enums/language_enum.dart';
import '../../../core/enums/theme_mode_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/logout_dialog.dart';
import '../settings_provider.dart';

/// Card providing dynamic runtime toggles for application Theme (Light/Dark)
/// and bilingual Language (Spanish/English).
class AppearanceSettingsCard extends StatelessWidget {
  final SettingsProvider provider;

  const AppearanceSettingsCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearanceAndLanguage,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.themeMode,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildThemeWrap(l10n),
            const SizedBox(height: 20),
            Text(
              l10n.languageLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildLanguageWrap(l10n),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              l10n.logout,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.logoutConfirmation,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(
                  color: theme.colorScheme.error.withValues(alpha: 0.5),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(l10n.logout),
              onPressed: () => showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeWrap(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      children: [
        _buildChoiceBtn(
          label: l10n.themeLight,
          icon: Icons.light_mode,
          isSelected: provider.themeMode == ThemeModeEnum.light,
          onPressed: () => provider.setThemeMode(ThemeModeEnum.light),
        ),
        _buildChoiceBtn(
          label: l10n.themeDark,
          icon: Icons.dark_mode,
          isSelected: provider.themeMode == ThemeModeEnum.dark,
          onPressed: () => provider.setThemeMode(ThemeModeEnum.dark),
        ),
      ],
    );
  }

  Widget _buildLanguageWrap(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      children: [
        _buildChoiceBtn(
          label: l10n.langSpanish,
          icon: Icons.translate,
          isSelected: provider.language == LanguageEnum.es,
          onPressed: () => provider.setLanguage(LanguageEnum.es),
        ),
        _buildChoiceBtn(
          label: l10n.langEnglish,
          icon: Icons.translate,
          isSelected: provider.language == LanguageEnum.en,
          onPressed: () => provider.setLanguage(LanguageEnum.en),
        ),
      ],
    );
  }

  Widget _buildChoiceBtn({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    if (isSelected) {
      return FilledButton.icon(
        style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
        icon: Icon(icon, size: 16),
        label: Text(label),
        onPressed: onPressed,
      );
    }
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
