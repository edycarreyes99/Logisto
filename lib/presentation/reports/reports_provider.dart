import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../l10n/app_localizations.dart';

/// Data entry representing a row in consolidated reports.
class ReportRowItem {
  final String title;
  final String subtitle;
  final String metric1;
  final String metric2;
  final String tag;
  final bool isWarning;

  const ReportRowItem({
    required this.title,
    required this.subtitle,
    required this.metric1,
    required this.metric2,
    required this.tag,
    this.isWarning = false,
  });
}

/// State provider for enterprise business intelligence, consolidated operational reports,
/// and data exports.
class ReportsProvider extends ChangeNotifier {
  String _selectedCategory = 'sales';
  String _dateFilter = 'Today';
  FeatureStatusEnum _status = FeatureStatusEnum.loaded;

  String get selectedCategory => _selectedCategory;
  String get dateFilter => _dateFilter;
  FeatureStatusEnum get status => _status;

  Future<void> refresh() async {
    _status = FeatureStatusEnum.loading;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    _status = FeatureStatusEnum.loaded;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDateFilter(String filter) {
    _dateFilter = filter;
    notifyListeners();
  }

  String get categoryTitle {
    switch (_selectedCategory) {
      case 'inventory':
        return 'Inventory Valuation & Reorder Point';
      case 'cash':
        return 'Cash Drawer Cuts (Z-Report Audit)';
      case 'credit':
        return 'Accounts Receivable & Aging (CxC)';
      case 'billiards':
        return 'Billiard Station Utilization & Hourly Rent';
      case 'sales':
      default:
        return 'Sales & Pareto Contribution (80/20)';
    }
  }

  List<ReportRowItem> get currentReportRows {
    switch (_selectedCategory) {
      case 'inventory':
        return const [
          ReportRowItem(
            title: 'Cerveza Toña 350ml Botella',
            subtitle: 'SKU: BEV-TONA-350 • Min: 48 units',
            metric1: 'Cost Val: \$144.00',
            metric2: 'Sale Val: \$252.00',
            tag: '144 In Stock',
          ),
          ReportRowItem(
            title: 'Ron Flor de Caña 7 Años',
            subtitle: 'SKU: LIQ-FDC-7Y • Min: 12 units',
            metric1: 'Cost Val: \$70.00',
            metric2: 'Sale Val: \$140.00',
            tag: 'Low Stock: 5 Units',
            isWarning: true,
          ),
          ReportRowItem(
            title: 'Botella de Agua Pura 500ml',
            subtitle: 'SKU: BEV-WAT-500 • Min: 24 units',
            metric1: 'Cost Val: \$25.00',
            metric2: 'Sale Val: \$60.00',
            tag: '60 In Stock',
          ),
        ];
      case 'cash':
        return const [
          ReportRowItem(
            title: 'Shift #101 • Cashier: Juan Pérez',
            subtitle: 'Opened 08:00 AM • Closed 04:00 PM',
            metric1: 'Expected: \$400.00',
            metric2: 'Counted: \$398.00',
            tag: 'Shortage -\$2.00',
            isWarning: true,
          ),
          ReportRowItem(
            title: 'Shift #102 • Cashier: Carlos Machado',
            subtitle: 'Opened 04:00 PM • Closed 11:30 PM',
            metric1: 'Expected: \$620.00',
            metric2: 'Counted: \$620.00',
            tag: 'Balanced \$0.00',
          ),
        ];
      case 'credit':
        return const [
          ReportRowItem(
            title: 'Roberto Gómez',
            subtitle: 'RUC: 001-150490-0002U • Limit: \$300.00',
            metric1: 'Current Debt: \$45.50',
            metric2: 'Days Overdue: 4',
            tag: 'Active Credit',
          ),
          ReportRowItem(
            title: 'Empresa Distribuidora ABC',
            subtitle: 'RUC: J0310009988 • Limit: \$1,500.00',
            metric1: 'Current Debt: \$1,450.00',
            metric2: 'Days Overdue: 38',
            tag: 'BLOCKED (Mora >30d)',
            isWarning: true,
          ),
        ];
      case 'billiards':
        return const [
          ReportRowItem(
            title: 'Mesa 1 - Diamante (Pool)',
            subtitle: 'Rate: \$10.00/h • 6.5 Hours Active',
            metric1: 'Time Sales: \$65.00',
            metric2: 'Bar Consumed: \$112.50',
            tag: 'Occupancy: 81%',
          ),
          ReportRowItem(
            title: 'Mesa 2 - Brunswick (Pool)',
            subtitle: 'Rate: \$10.00/h • 4.2 Hours Active',
            metric1: 'Time Sales: \$42.00',
            metric2: 'Bar Consumed: \$58.00',
            tag: 'Occupancy: 52%',
          ),
          ReportRowItem(
            title: 'Mesa 3 - Carambola VIP',
            subtitle: 'Rate: \$14.00/h • 2.0 Hours Active',
            metric1: 'Time Sales: \$28.00',
            metric2: 'Bar Consumed: \$45.00',
            tag: 'Occupancy: 25%',
          ),
        ];
      case 'sales':
      default:
        return const [
          ReportRowItem(
            title: 'Cerveza Toña 350ml (Beverages)',
            subtitle: 'Pareto Rank #1 • 84 Units Sold',
            metric1: 'Revenue: \$147.00',
            metric2: 'Margin: 42.8%',
            tag: 'Top 80%',
          ),
          ReportRowItem(
            title: 'Mojito Cubano Artesanal (Cocktails)',
            subtitle: 'Pareto Rank #2 • 32 Units Sold',
            metric1: 'Revenue: \$144.00',
            metric2: 'Margin: 61.1%',
            tag: 'Top 80%',
          ),
          ReportRowItem(
            title: 'Alitas BBQ Crujientes (Food)',
            subtitle: 'Pareto Rank #3 • 20 Units Sold',
            metric1: 'Revenue: \$120.00',
            metric2: 'Margin: 52.0%',
            tag: 'Top 80%',
          ),
        ];
    }
  }

  List<ReportRowItem> getLocalizedReportRows(AppLocalizations l10n) {
    switch (_selectedCategory) {
      case 'inventory':
        return [
          ReportRowItem(
            title: 'Cerveza Toña 350ml Botella',
            subtitle: l10n.reportSubSkuMin('BEV-TONA-350', 48),
            metric1: l10n.reportMetricCostVal('144.00'),
            metric2: l10n.reportMetricSaleVal('252.00'),
            tag: l10n.reportTagInStock(144),
          ),
          ReportRowItem(
            title: 'Ron Flor de Caña 7 Años',
            subtitle: l10n.reportSubSkuMin('LIQ-FDC-7Y', 12),
            metric1: l10n.reportMetricCostVal('70.00'),
            metric2: l10n.reportMetricSaleVal('140.00'),
            tag: l10n.reportTagLowStock(5),
            isWarning: true,
          ),
          ReportRowItem(
            title: 'Botella de Agua Pura 500ml',
            subtitle: l10n.reportSubSkuMin('BEV-WAT-500', 24),
            metric1: l10n.reportMetricCostVal('25.00'),
            metric2: l10n.reportMetricSaleVal('60.00'),
            tag: l10n.reportTagInStock(60),
          ),
        ];
      case 'cash':
        return [
          ReportRowItem(
            title: l10n.reportShiftCashier('101', 'Juan Pérez'),
            subtitle: l10n.reportSubShiftHours('08:00 AM', '04:00 PM'),
            metric1: l10n.reportMetricExpected('400.00'),
            metric2: l10n.reportMetricCounted('398.00'),
            tag: l10n.reportTagShortage('2.00'),
            isWarning: true,
          ),
          ReportRowItem(
            title: l10n.reportShiftCashier('102', 'Carlos Machado'),
            subtitle: l10n.reportSubShiftHours('04:00 PM', '11:30 PM'),
            metric1: l10n.reportMetricExpected('620.00'),
            metric2: l10n.reportMetricCounted('620.00'),
            tag: l10n.reportTagBalanced,
          ),
        ];
      case 'credit':
        return [
          ReportRowItem(
            title: 'Roberto Gómez',
            subtitle: l10n.reportSubRucLimit('001-150490-0002U', '300.00'),
            metric1: l10n.reportMetricCurrentDebt('45.50'),
            metric2: l10n.reportMetricDaysOverdue(4),
            tag: l10n.reportTagActiveCredit,
          ),
          ReportRowItem(
            title: 'Empresa Distribuidora ABC',
            subtitle: l10n.reportSubRucLimit('J0310009988', '1,500.00'),
            metric1: l10n.reportMetricCurrentDebt('1,450.00'),
            metric2: l10n.reportMetricDaysOverdue(38),
            tag: l10n.reportTagBlockedOverdue,
            isWarning: true,
          ),
        ];
      case 'billiards':
        return [
          ReportRowItem(
            title: 'Mesa 1 - Diamante (Pool)',
            subtitle: l10n.reportSubTableRateHours('10.00', '6.5'),
            metric1: l10n.reportMetricTimeSales('65.00'),
            metric2: l10n.reportMetricBarConsumed('112.50'),
            tag: l10n.reportTagOccupancy(81),
          ),
          ReportRowItem(
            title: 'Mesa 2 - Brunswick (Pool)',
            subtitle: l10n.reportSubTableRateHours('10.00', '4.2'),
            metric1: l10n.reportMetricTimeSales('42.00'),
            metric2: l10n.reportMetricBarConsumed('58.00'),
            tag: l10n.reportTagOccupancy(52),
          ),
          ReportRowItem(
            title: 'Mesa 3 - Carambola VIP',
            subtitle: l10n.reportSubTableRateHours('14.00', '2.0'),
            metric1: l10n.reportMetricTimeSales('28.00'),
            metric2: l10n.reportMetricBarConsumed('45.00'),
            tag: l10n.reportTagOccupancy(25),
          ),
        ];
      case 'sales':
      default:
        return [
          ReportRowItem(
            title: 'Cerveza Toña 350ml (${l10n.categoryBeverages})',
            subtitle: l10n.reportSubParetoRankUnits(1, 84),
            metric1: l10n.reportMetricRevenue('147.00'),
            metric2: l10n.reportMetricMargin('42.8'),
            tag: l10n.reportTagTopPareto,
          ),
          ReportRowItem(
            title: 'Mojito Cubano Artesanal (${l10n.categoryCocktails})',
            subtitle: l10n.reportSubParetoRankUnits(2, 32),
            metric1: l10n.reportMetricRevenue('144.00'),
            metric2: l10n.reportMetricMargin('61.1'),
            tag: l10n.reportTagTopPareto,
          ),
          ReportRowItem(
            title: 'Alitas BBQ Crujientes (${l10n.categoryFood})',
            subtitle: l10n.reportSubParetoRankUnits(3, 20),
            metric1: l10n.reportMetricRevenue('120.00'),
            metric2: l10n.reportMetricMargin('52.0'),
            tag: l10n.reportTagTopPareto,
          ),
        ];
    }
  }

  String exportToCsv([AppLocalizations? l10n]) {
    final rows = l10n != null
        ? getLocalizedReportRows(l10n)
        : currentReportRows;
    final buffer = StringBuffer();
    final header = l10n != null
        ? '${l10n.tableHeaderItemConcept},${l10n.tableHeaderDetailsSku},${l10n.tableHeaderMetric1},${l10n.tableHeaderMetric2},${l10n.tableHeaderStatusRatio}'
        : 'Title,Details,Metric1,Metric2,Status';
    buffer.writeln(header);
    for (final r in rows) {
      buffer.writeln(
        '"${r.title}","${r.subtitle}","${r.metric1}","${r.metric2}","${r.tag}"',
      );
    }
    return buffer.toString();
  }
}
