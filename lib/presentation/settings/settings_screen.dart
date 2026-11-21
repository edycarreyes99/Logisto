import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/settings_section_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/logisto_scaffold.dart';
import 'settings_provider.dart';
import 'widgets/appearance_settings_card.dart';
import 'widgets/org_settings_card.dart';
import 'widgets/printer_settings_card.dart';
import 'widgets/rbac_matrix_card.dart';
import 'printer_management_provider.dart';

/// Screen for managing corporate preferences, appearance, tax parameters, exchange rates,
/// and RBAC security policies.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = locator<SettingsProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return LogistoScaffold(
      title: l10n.settingsAndRbac,
      body: BsContainer.fluid(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTabBar(l10n, theme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ListenableBuilder(
                  listenable: _provider,
                  builder: (context, _) => _buildActiveSection(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTabBar(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListenableBuilder(
          listenable: _provider,
          builder: (context, _) {
            return Row(
              children: [
                _buildSectionBtn(
                  section: SettingsSectionEnum.organization,
                  label: l10n.corporateAndFiscal,
                  icon: Icons.business_outlined,
                ),
                const SizedBox(width: 8),
                _buildSectionBtn(
                  section: SettingsSectionEnum.printers,
                  label: l10n.printersSectionTitle,
                  icon: Icons.print_outlined,
                ),
                const SizedBox(width: 8),
                _buildSectionBtn(
                  section: SettingsSectionEnum.appearance,
                  label: l10n.appearance,
                  icon: Icons.palette_outlined,
                ),
                const SizedBox(width: 8),
                _buildSectionBtn(
                  section: SettingsSectionEnum.rbac,
                  label: l10n.rbacSecurity,
                  icon: Icons.security_outlined,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActiveSection() {
    switch (_provider.selectedSection) {
      case SettingsSectionEnum.printers:
        final printerProvider = locator<PrinterManagementProvider>();
        return ListenableBuilder(
          listenable: printerProvider,
          builder: (context, _) =>
              PrinterSettingsCard(provider: printerProvider),
        );
      case SettingsSectionEnum.appearance:
        return AppearanceSettingsCard(provider: _provider);
      case SettingsSectionEnum.rbac:
        return RbacMatrixCard(provider: _provider);
      case SettingsSectionEnum.organization:
        return OrgSettingsCard(provider: _provider);
    }
  }

  Widget _buildSectionBtn({
    required SettingsSectionEnum section,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _provider.selectedSection == section;
    if (isSelected) {
      return FilledButton.icon(
        style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
        icon: Icon(icon, size: 16),
        label: Text(label),
        onPressed: () => _provider.setSection(section),
      );
    }
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () => _provider.setSection(section),
    );
  }
}
