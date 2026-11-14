import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../domain/models/business_unit_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../auth/logout_dialog.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../context/business_context_provider.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import 'business_unit_selector_provider.dart';
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
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadBusinessUnits(orgId);
    });
  }

  void _refresh() {
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    _provider.loadBusinessUnits(orgId);
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showInfo(context, l10n.refresh);
  }

  void _handleSelectUnit(BusinessUnitModel unit) async {
    await _provider.selectUnit(unit);
    if (mounted) {
      AppFeedback.showSuccess(context, unit.name);
    }
    locator<NavigationProvider>().navigateTo(AppRoutes.dashboard);
  }

  void _showAddUnitModal(AppLocalizations l10n) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            l10n.registerNewBranch,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.branchName,
                  hintText: l10n.branchName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                decoration: InputDecoration(
                  labelText: l10n.physicalAddress,
                  hintText: l10n.physicalAddress,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(l10n.createBranch),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final orgId =
                          _contextProvider.activeOrganization?.id ??
                          DatabaseSeeder.defaultOrgId;
                      final bName = nameCtrl.text;
                      await _provider.addUnit(
                        orgId: orgId,
                        name: bName,
                        type: BusinessTypeEnum.retail,
                        address: addressCtrl.text,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          '${l10n.createBranch}: $bName',
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _buildHeader(l10n),
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

  PreferredSizeWidget _buildHeader(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.selectOperatingBusinessUnit,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
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
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildUnitGrid() {
    if (_provider.status == FeatureStatusEnum.loading &&
        _provider.units.isEmpty) {
      return const AppSkeletonKpiGrid(cardCount: 3);
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
