import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/audit_action_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/enum_localization_extensions.dart';
import '../context/business_context_provider.dart';
import 'audit_log_provider.dart';
import 'widgets/audit_log_list_mobile.dart';
import 'widgets/audit_log_table_desktop.dart';

/// Screen for immutable security audit logging, suspicious operations,
/// and activity trail monitoring.
class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  late final AuditLogProvider _provider;
  late final BusinessContextProvider _contextProvider;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = locator<AuditLogProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadAuditLogs(orgId);
    });
  }

  void _refresh() {
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    _provider.loadAuditLogs(orgId);
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showInfo(context, l10n.refresh);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    return BsContainer.fluid(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(l10n, theme, isDesktop),
          _buildActionFilterBar(l10n, theme, isDesktop),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ListenableBuilder(
                listenable: _provider,
                builder: (context, _) {
                  if (_provider.status == FeatureStatusEnum.loading &&
                      _provider.logs.isEmpty) {
                    return isDesktop
                        ? const AppSkeletonTable(rowCount: 6, columnCount: 5)
                        : const AppSkeletonList(itemCount: 4);
                  }
                  return isDesktop
                      ? AuditLogTableDesktop(logs: _provider.filteredLogs)
                      : AuditLogListMobile(logs: _provider.filteredLogs);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    AppLocalizations l10n,
    ThemeData theme,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.audit,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.refresh,
                onPressed: _refresh,
              ),
              if (isDesktop)
                SizedBox(
                  width: 260,
                  height: 40,
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: l10n.filterAuditLogsPlaceholder,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: _provider.setSearchQuery,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionFilterBar(
    AppLocalizations l10n,
    ThemeData theme,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: theme.colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isDesktop) ...[
            SizedBox(
              height: 40,
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: l10n.filterAuditLogsPlaceholder,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _provider.setSearchQuery,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterBtn(
                label: l10n.allEvents,
                isSelected: _provider.selectedActionFilter == null,
                onPressed: () => _provider.setActionFilter(null),
              ),
              ...AuditActionEnum.values.map((action) {
                return _buildFilterBtn(
                  label: action.localizedTitle(l10n),
                  isSelected: _provider.selectedActionFilter == action,
                  onPressed: () => _provider.setActionFilter(action),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    if (isSelected) {
      return FilledButton(
        style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
        onPressed: onPressed,
        child: Text(label),
      );
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
