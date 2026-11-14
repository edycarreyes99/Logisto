import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import 'reports_provider.dart';
import 'widgets/reports_list_mobile.dart';
import 'widgets/reports_table_desktop.dart';

/// Screen for generating, analyzing, and exporting business intelligence,
/// sales, inventory, cash cut, and credit aging reports.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late final ReportsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = locator<ReportsProvider>();
  }

  String _getCategoryTitle(AppLocalizations l10n, String category) {
    switch (category) {
      case 'inventory':
        return l10n.reportInventoryValuation;
      case 'cash':
        return l10n.reportCashDrawerCuts;
      case 'credit':
        return l10n.reportReceivablesAging;
      case 'billiards':
        return l10n.reportBilliardsUtilization;
      case 'sales':
      default:
        return l10n.reportSalesPareto;
    }
  }

  void _showExportSuccessModal() {
    final l10n = AppLocalizations.of(context)!;
    final csv = _provider.exportToCsv(l10n);
    final theme = Theme.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.reportExportedSuccessfully),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.csvReportGenerated('${csv.split("\n").length - 1}')),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                csv,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
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
          _buildHeader(l10n, theme),
          _buildFilterBar(l10n, theme),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ListenableBuilder(
                listenable: _provider,
                builder: (context, _) {
                  if (_provider.status == FeatureStatusEnum.loading) {
                    return isDesktop
                        ? const AppSkeletonTable(rowCount: 6, columnCount: 4)
                        : const AppSkeletonList(itemCount: 4);
                  }
                  return isDesktop
                      ? ReportsTableDesktop(
                          rows: _provider.getLocalizedReportRows(l10n),
                          title: _getCategoryTitle(
                            l10n,
                            _provider.selectedCategory,
                          ),
                        )
                      : ReportsListMobile(
                          rows: _provider.getLocalizedReportRows(l10n),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          Text(
            l10n.reportsAndBi,
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
                onPressed: () {
                  AppFeedback.showInfo(context, l10n.refresh);
                },
              ),
              FilledButton.icon(
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: Text(l10n.exportCsv),
                onPressed: _showExportSuccessModal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: theme.colorScheme.surfaceContainerLowest,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCatBtn('sales', l10n.salesReport8020, Icons.bar_chart),
            const SizedBox(width: 8),
            _buildCatBtn('inventory', l10n.inventory, Icons.inventory_2_outlined),
            const SizedBox(width: 8),
            _buildCatBtn('cash', l10n.cashShifts, Icons.point_of_sale_outlined),
            const SizedBox(width: 8),
            _buildCatBtn('credit', l10n.creditAging, Icons.account_balance_wallet_outlined),
            const SizedBox(width: 8),
            _buildCatBtn('billiards', l10n.billiards, Icons.sports_esports_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildCatBtn(String key, String label, IconData icon) {
    final isSel = _provider.selectedCategory == key;
    if (isSel) {
      return FilledButton.icon(
        icon: Icon(icon, size: 16),
        label: Text(label),
        onPressed: () => _provider.setCategory(key),
      );
    }
    return OutlinedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () => _provider.setCategory(key),
    );
  }
}
