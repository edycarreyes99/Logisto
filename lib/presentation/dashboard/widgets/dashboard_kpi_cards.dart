import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/dashboard_metrics_model.dart';
import '../../../l10n/app_localizations.dart';

/// Top executive KPI summary row featuring 6 adaptive metric cards.
class DashboardKpiCards extends StatelessWidget {
  final DashboardMetricsModel metrics;

  const DashboardKpiCards({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BsRow(
      children: _buildKpiColumns(theme, l10n),
    );
  }

  List<BsCol> _buildKpiColumns(ThemeData theme, AppLocalizations l10n) {
    return [
      _buildCol(
        theme,
        l10n.todaySales,
        '\$${metrics.todaySales.toStringAsFixed(2)}',
        l10n.kpiRealtime,
        theme.colorScheme.primaryContainer,
        theme.colorScheme.onPrimaryContainer,
      ),
      _buildCol(
        theme,
        l10n.weekSales,
        '\$${metrics.weekSales.toStringAsFixed(2)}',
        l10n.kpiSynced,
        theme.colorScheme.secondaryContainer,
        theme.colorScheme.onSecondaryContainer,
      ),
      _buildCol(
        theme,
        l10n.monthSales,
        '\$${metrics.monthSales.toStringAsFixed(2)}',
        l10n.kpiMonthly,
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
      _buildCol(
        theme,
        l10n.activeCash,
        '\$${metrics.activeCashBalance.toStringAsFixed(2)}',
        l10n.activeShift,
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurfaceVariant,
      ),
      _buildCol(
        theme,
        l10n.openTabs,
        '\$${metrics.openAccountsBalance.toStringAsFixed(2)}',
        l10n.kpiPending,
        theme.colorScheme.errorContainer,
        theme.colorScheme.onErrorContainer,
      ),
      _buildCol(
        theme,
        l10n.totalProducts,
        '${metrics.totalProductsCount}',
        l10n.kpiCatalog,
        theme.colorScheme.surfaceContainerHighest,
        theme.colorScheme.onSurfaceVariant,
      ),
    ];
  }

  BsCol _buildCol(
    ThemeData theme,
    String title,
    String value,
    String badgeLabel,
    Color containerColor,
    Color onContainerColor,
  ) {
    return BsCol(
      config: const BsColConfig(xs: 12, sm: 6, md: 4, lg: 2),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    badgeLabel,
                    style: TextStyle(fontSize: 11, color: onContainerColor),
                  ),
                  backgroundColor: containerColor,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  side: BorderSide.none,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
