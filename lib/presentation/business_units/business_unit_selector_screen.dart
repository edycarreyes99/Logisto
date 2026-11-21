import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/business_unit_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../auth/logout_dialog.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import 'business_unit_selector_provider.dart';
import 'widgets/add_business_unit_dialog.dart';
import 'widgets/business_unit_card.dart';

/// Workspace branch selector allowing operators to switch operational context
/// between physical branches, kitchens, bars, or remote stores.
class BusinessUnitSelectorScreen extends StatefulWidget {
  const BusinessUnitSelectorScreen({super.key});

  @override
  State<BusinessUnitSelectorScreen> createState() =>
      _BusinessUnitSelectorScreenState();
}

class _BusinessUnitSelectorScreenState
    extends State<BusinessUnitSelectorScreen> {
  late final BusinessUnitSelectorProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<BusinessUnitSelectorProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadBusinessUnits(orgId);
      });
    }
  }

  void _refresh() {
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    if (orgId.isNotEmpty) {
      _provider.loadBusinessUnits(orgId);
      final l10n = AppLocalizations.of(context)!;
      AppFeedback.showInfo(context, l10n.refresh);
    }
  }

  void _handleSelectUnit(BusinessUnitModel unit) async {
    await _provider.selectUnit(unit);
    if (mounted) {
      AppFeedback.showSuccess(context, unit.name);
    }
    locator<NavigationProvider>().navigateTo(AppRoutes.dashboard);
  }

  void _showAddUnitModal(AppLocalizations l10n) {
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    showDialog<void>(
      context: context,
      builder: (ctx) => AddBusinessUnitDialog(
        provider: _provider,
        orgId: orgId,
        onSuccess: () {
          if (mounted) {
            AppFeedback.showSuccess(
              context,
              l10n.createBranch,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasActiveUnit = _contextProvider.activeBusinessUnit != null;

    return LogistoScaffold(
      title: l10n.selectOperatingBusinessUnit,
      isChild: hasActiveUnit,
      onBack: () => locator<NavigationProvider>().navigateTo(AppRoutes.dashboard),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.refresh,
          onPressed: _refresh,
        ),
        FilledButton.icon(
          onPressed: () => _showAddUnitModal(l10n),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l10n.addBranch),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          color: Theme.of(context).colorScheme.error,
          tooltip: l10n.logout,
          onPressed: () => showLogoutDialog(context),
        ),
      ],
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _buildUnitGrid(),
          ),
        ),
      ),
    );
  }

  Widget _buildUnitGrid() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_provider.status == FeatureStatusEnum.loading &&
        _provider.units.isEmpty) {
      return const AppSkeletonKpiGrid(cardCount: 3);
    }

    if (_provider.units.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.store_mall_directory_outlined,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.noBusinessUnitsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Text(
                  l10n.noBusinessUnitsDesc,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _showAddUnitModal(l10n),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.createFirstBusinessUnit),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final activeId = _contextProvider.activeBusinessUnit?.id;
    return BsRow(
      children: _provider.units.map((unit) {
        return BsCol(
          config: const BsColConfig(xs: 12, sm: 6, md: 6, lg: 4),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: BusinessUnitCard(
              unit: unit,
              isSelected: unit.id == activeId,
              onSelect: () => _handleSelectUnit(unit),
            ),
          ),
        );
      }).toList(),
    );
  }
}
