import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../auth/logout_dialog.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/enum_localization_extensions.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'dashboard_provider.dart';
import 'widgets/dashboard_kpi_cards.dart';
import 'widgets/top_selling_table.dart';

/// Executive dashboard screen rendering aggregated KPIs, revenue breakdown,
/// and top selling product tables.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<DashboardProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadDashboard(orgId: orgId, buId: buId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return LogistoScaffold(
      title: l10n.dashboard,
      actions: _buildHeaderActions(l10n, theme),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) {
              if (_provider.status == FeatureStatusEnum.loading) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSkeletonKpiGrid(cardCount: 6),
                    SizedBox(height: 16),
                    AppSkeletonTable(rowCount: 5, columnCount: 3),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardKpiCards(metrics: _provider.metrics),
                  const SizedBox(height: 16),
                  _buildBreakdownRow(l10n),
                  const SizedBox(height: 16),
                  TopSellingTable(items: _provider.topProducts),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeaderActions(AppLocalizations l10n, ThemeData theme) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final filters = [
      ('Today', l10n.filterToday),
      ('Week', l10n.filterWeek),
      ('Month', l10n.filterMonth),
    ];
    return [
      IconButton(
        icon: const Icon(Icons.refresh_rounded),
        tooltip: l10n.refresh,
        onPressed: () async {
          final orgId = _contextProvider.activeOrganization?.id ?? '';
          final buId = _contextProvider.activeBusinessUnit?.id ?? '';
          if (orgId.isNotEmpty) {
            await _provider.loadDashboard(orgId: orgId, buId: buId);
            if (mounted) {
              AppFeedback.showSuccess(context, 'Dashboard sincronizado');
            }
          }
        },
      ),
      if (!isDesktop)
        PopupMenuButton<String>(
          icon: const Icon(Icons.calendar_today_outlined, size: 20),
          tooltip: l10n.filterToday,
          initialValue: _provider.timeFilter,
          onSelected: _provider.setTimeFilter,
          itemBuilder: (context) => filters
              .map((entry) => PopupMenuItem(
                    value: entry.$1,
                    child: Text(entry.$2),
                  ))
              .toList(),
        )
      else
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: filters.map((entry) {
              final isSel = _provider.timeFilter == entry.$1;
              return isSel
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () => _provider.setTimeFilter(entry.$1),
                      child: Text(entry.$2),
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () => _provider.setTimeFilter(entry.$1),
                      child: Text(entry.$2),
                    );
            }).toList(),
          ),
        ),
      if (!isDesktop)
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          tooltip: l10n.logout,
          color: theme.colorScheme.error,
          onPressed: () => showLogoutDialog(context),
        ),
    ];
  }

  Widget _buildBreakdownRow(AppLocalizations l10n) {
    return BsRow(
      children: [
        BsCol(
          config: const BsColConfig(xs: 12, md: 6),
          child: _buildTenderCard(l10n),
        ),
        BsCol(
          config: const BsColConfig(xs: 12, md: 6),
          child: _buildRevenueCard(l10n),
        ),
      ],
    );
  }

  Widget _buildRevenueCard(AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.revenueByCategory,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 20),
            ..._provider.metrics.salesByCategory.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(e.key, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${e.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTenderCard(AppLocalizations l10n) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.revenueByTender,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 20),
            ..._provider.metrics.salesByPaymentMethod.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        e.key.localizedTitle(l10n),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${e.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
