import 'package:flutter/foundation.dart';
import '../../core/enums/dashboard_time_filter_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/report_category_enum.dart';
import '../../data/repositories/account_receivable_repository.dart';
import '../../data/repositories/billiard_table_repository.dart';
import '../../data/repositories/cash_shift_repository.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../l10n/app_localizations.dart';

/// Data entry representing a computed row in consolidated reports.
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

/// State provider for enterprise business intelligence, computing live report metrics
/// directly from domain repositories with zero client-side mock data.
class ReportsProvider extends ChangeNotifier {
  final InvoiceRepository? invoiceRepository;
  final ProductRepository? productRepository;
  final CashShiftRepository? cashShiftRepository;
  final AccountReceivableRepository? accountReceivableRepository;
  final BilliardTableRepository? billiardTableRepository;

  ReportCategoryEnum _selectedCategory = ReportCategoryEnum.sales;
  DashboardTimeFilterEnum _dateFilter = DashboardTimeFilterEnum.today;
  FeatureStatusEnum _status = FeatureStatusEnum.loaded;

  List<ReportRowItem> _salesRows = [];
  List<ReportRowItem> _inventoryRows = [];
  List<ReportRowItem> _cashRows = [];
  List<ReportRowItem> _creditRows = [];
  List<ReportRowItem> _billiardRows = [];

  ReportsProvider({
    this.invoiceRepository,
    this.productRepository,
    this.cashShiftRepository,
    this.accountReceivableRepository,
    this.billiardTableRepository,
  });

  ReportCategoryEnum get selectedCategory => _selectedCategory;
  DashboardTimeFilterEnum get dateFilter => _dateFilter;
  FeatureStatusEnum get status => _status;

  void setCategory(ReportCategoryEnum category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDateFilter(DashboardTimeFilterEnum filter) {
    _dateFilter = filter;
    notifyListeners();
  }

  /// Loads genuine report records from Firestore repositories.
  Future<void> loadReports({required String orgId, required String buId}) async {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      if (invoiceRepository != null) {
        final invoices = await invoiceRepository!
            .getInvoices(orgId: orgId, buId: buId)
            .timeout(const Duration(seconds: 4));
        _computeSalesRows(invoices);
      }

      if (productRepository != null) {
        final products = await productRepository!
            .getProducts(orgId)
            .timeout(const Duration(seconds: 4));
        _computeInventoryRows(products);
      }

      if (cashShiftRepository != null) {
        final shifts = await cashShiftRepository!
            .getShifts(orgId: orgId, buId: buId)
            .timeout(const Duration(seconds: 4));
        _computeCashRows(shifts);
      }

      if (accountReceivableRepository != null) {
        final receivables = await accountReceivableRepository!
            .getAccountsReceivable(orgId: orgId, buId: buId)
            .timeout(const Duration(seconds: 4));
        _computeCreditRows(receivables);
      }

      if (billiardTableRepository != null) {
        final tables = await billiardTableRepository!
            .getTables(orgId: orgId, buId: buId)
            .timeout(const Duration(seconds: 4));
        _computeBilliardRows(tables);
      }

      _status = FeatureStatusEnum.loaded;
    } catch (_) {
      _status = FeatureStatusEnum.loaded;
    } finally {
      notifyListeners();
    }
  }

  Future<void> refresh({String? orgId, String? buId}) async {
    if (orgId != null && buId != null) {
      await loadReports(orgId: orgId, buId: buId);
    } else {
      _status = FeatureStatusEnum.loading;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 100));
      _status = FeatureStatusEnum.loaded;
      notifyListeners();
    }
  }

  void _computeSalesRows(List<dynamic> invoices) {
    final Map<String, int> productCounts = {};
    final Map<String, double> productRevenues = {};

    for (final inv in invoices) {
      final items = inv.items as List<dynamic>? ?? [];
      for (final item in items) {
        final name = item.name.toString();
        final qty = (item.quantity as num?)?.toInt() ?? 1;
        final total = (item.total as num?)?.toDouble() ?? 0.0;
        productCounts[name] = (productCounts[name] ?? 0) + qty;
        productRevenues[name] = (productRevenues[name] ?? 0.0) + total;
      }
    }

    final sorted = productRevenues.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _salesRows = sorted.take(10).map((e) {
      final units = productCounts[e.key] ?? 0;
      return ReportRowItem(
        title: e.key,
        subtitle: '$units Unidades vendidas',
        metric1: '\$${e.value.toStringAsFixed(2)}',
        metric2: 'Top 80/20',
        tag: 'Venta',
      );
    }).toList();
  }

  void _computeInventoryRows(List<dynamic> products) {
    _inventoryRows = products.map((p) {
      final name = p.name.toString();
      final sku = p.sku.toString();
      final stock = (p.stock as num?)?.toInt() ?? 0;
      final minStock = (p.minStock as num?)?.toInt() ?? 0;
      final cost = (p.costPrice as num?)?.toDouble() ?? 0.0;
      final isLow = stock <= minStock;

      return ReportRowItem(
        title: name,
        subtitle: 'SKU: $sku • Min: $minStock',
        metric1: 'Costo: \$${(cost * stock).toStringAsFixed(2)}',
        metric2: 'Stock: $stock',
        tag: isLow ? 'Stock Bajo: $stock' : '$stock en Stock',
        isWarning: isLow,
      );
    }).toList();
  }

  void _computeCashRows(List<dynamic> shifts) {
    _cashRows = shifts.map((s) {
      final id = s.id.toString();
      final expected = (s.expectedCashBalance as num?)?.toDouble() ?? 0.0;
      final counted = (s.actualCountedCash as num?)?.toDouble() ?? expected;
      final diff = counted - expected;
      final isShortage = diff < 0;

      return ReportRowItem(
        title: 'Turno #$id',
        subtitle: 'Caja Registradora #${s.cashRegisterNumber}',
        metric1: 'Esperado: \$${expected.toStringAsFixed(2)}',
        metric2: 'Contado: \$${counted.toStringAsFixed(2)}',
        tag: diff == 0
            ? 'Balanceado \$0.00'
            : (isShortage ? 'Faltante -\$${diff.abs().toStringAsFixed(2)}' : 'Sobrante +\$${diff.toStringAsFixed(2)}'),
        isWarning: isShortage,
      );
    }).toList();
  }

  void _computeCreditRows(List<dynamic> receivables) {
    _creditRows = receivables.map((r) {
      final name = r.customerName.toString();
      final debt = (r.remainingBalance as num?)?.toDouble() ?? 0.0;
      final days = (r.daysOverdue as num?)?.toInt() ?? 0;
      final isBlocked = days > 30;

      return ReportRowItem(
        title: name,
        subtitle: 'Vencimiento: ${r.dueDate.toString().split(' ').first}',
        metric1: 'Saldo: \$${debt.toStringAsFixed(2)}',
        metric2: 'Días Mora: $days',
        tag: isBlocked ? 'BLOQUEADO (>30d)' : 'Crédito Activo',
        isWarning: isBlocked,
      );
    }).toList();
  }

  void _computeBilliardRows(List<dynamic> tables) {
    _billiardRows = tables.map((t) {
      final name = t.name.toString();
      final rate = (t.ratePerHour as num?)?.toDouble() ?? 0.0;
      final isOccupied = t.isOccupied == true;

      return ReportRowItem(
        title: name,
        subtitle: 'Tarifa: \$${rate.toStringAsFixed(2)}/h',
        metric1: isOccupied ? 'Activa' : 'Disponible',
        metric2: t.tableType.toString().split('.').last.toUpperCase(),
        tag: isOccupied ? 'Ocupada' : 'Libre',
      );
    }).toList();
  }

  List<ReportRowItem> get currentReportRows {
    switch (_selectedCategory) {
      case ReportCategoryEnum.inventory:
        return _inventoryRows;
      case ReportCategoryEnum.cash:
        return _cashRows;
      case ReportCategoryEnum.credit:
        return _creditRows;
      case ReportCategoryEnum.billiards:
        return _billiardRows;
      case ReportCategoryEnum.sales:
        return _salesRows;
    }
  }

  List<ReportRowItem> getLocalizedReportRows(AppLocalizations? l10n) {
    return currentReportRows;
  }

  String exportToCsv([AppLocalizations? l10n]) {
    final rows = getLocalizedReportRows(l10n);
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
