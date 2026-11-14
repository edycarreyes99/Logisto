import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../data/firestore/firestore_client.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/dashboard_metrics_model.dart';
import '../../domain/models/invoice_model.dart';

/// State provider managing dashboard KPI cards, time range filter,
/// and live Firestore metrics and top selling product aggregates.
class DashboardProvider extends ChangeNotifier {
  final FirestoreClient? client;
  final InvoiceRepository? invoiceRepository;
  final ProductRepository? productRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String _timeFilter = 'Today';
  DashboardMetricsModel _metrics = const DashboardMetricsModel();
  List<Map<String, dynamic>> _topProducts = const [];

  DashboardProvider({
    this.client,
    this.invoiceRepository,
    this.productRepository,
  });

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get timeFilter => _timeFilter;
  DashboardMetricsModel get metrics => _metrics;
  List<Map<String, dynamic>> get topProducts => List.unmodifiable(_topProducts);

  void setTimeFilter(String filter) {
    _timeFilter = filter;
    notifyListeners();
  }

  Future<void> loadDashboard({
    required String orgId,
    required String buId,
  }) async {
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final todayKey = DateTime.now().toIso8601String().substring(0, 10);
      if (client != null) {
        try {
          final aggDoc = await client!
              .aggregations(orgId, buId)
              .doc('daily_$todayKey')
              .get()
              .timeout(const Duration(seconds: 4));
          if (aggDoc.exists && aggDoc.data() != null) {
            _metrics = DashboardMetricsModel.fromMap(aggDoc.data()!);
          }
        } catch (_) {}
      }

      // Query live invoices if invoiceRepository is available
      if (invoiceRepository != null) {
        try {
          final invoices = await invoiceRepository!
              .getInvoices(
                orgId: orgId,
                buId: buId,
              )
              .timeout(const Duration(seconds: 4));
          if (invoices.isNotEmpty) {
            _computeLiveMetrics(invoices);
          }
        } catch (_) {}
      }

      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  void _computeLiveMetrics(List<InvoiceModel> invoices) {
    final now = DateTime.now();
    double todayTotal = 0.0;
    double weekTotal = 0.0;
    double monthTotal = 0.0;
    final Map<String, double> categoryMap = {};
    final Map<PaymentMethodEnum, double> tenderMap = {};
    final Map<String, Map<String, dynamic>> productStats = {};

    for (final inv in invoices) {
      final daysDiff = now.difference(inv.issuedAt).inDays;
      if (daysDiff == 0) todayTotal += inv.total;
      if (daysDiff <= 7) weekTotal += inv.total;
      if (daysDiff <= 30) monthTotal += inv.total;

      for (final tender in inv.payments) {
        tenderMap[tender.method] =
            (tenderMap[tender.method] ?? 0.0) + tender.amount;
      }

      for (final item in inv.items) {
        final existing =
            productStats[item.productId] ??
            {
              'sku': item.productId,
              'name': item.name,
              'category': 'General',
              'units': 0,
              'total': 0.0,
            };
        existing['units'] = (existing['units'] as int) + item.quantity.toInt();
        existing['total'] = (existing['total'] as double) + item.total;
        productStats[item.productId] = existing;
      }
    }

    _metrics = DashboardMetricsModel(
      todaySales: todayTotal > 0 ? todayTotal : _metrics.todaySales,
      yesterdaySales: _metrics.yesterdaySales,
      weekSales: weekTotal > 0 ? weekTotal : _metrics.weekSales,
      monthSales: monthTotal > 0 ? monthTotal : _metrics.monthSales,
      activeCashBalance: _metrics.activeCashBalance,
      openAccountsBalance: _metrics.openAccountsBalance,
      totalProductsCount: _metrics.totalProductsCount > 0
          ? _metrics.totalProductsCount
          : productStats.length,
      totalCustomersCount: _metrics.totalCustomersCount,
      salesByCategory: categoryMap.isNotEmpty
          ? categoryMap
          : _metrics.salesByCategory,
      salesByPaymentMethod: tenderMap.isNotEmpty
          ? tenderMap
          : _metrics.salesByPaymentMethod,
    );

    final sorted = productStats.values.toList()
      ..sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));
    _topProducts = sorted.take(10).toList();
  }
}
