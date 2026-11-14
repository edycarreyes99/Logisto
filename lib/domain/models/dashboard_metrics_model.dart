import '../../core/enums/payment_method_enum.dart';

/// Pure domain model for executive analytics and aggregated KPI metrics.
class DashboardMetricsModel {
  final double todaySales;
  final double yesterdaySales;
  final double weekSales;
  final double monthSales;
  final double activeCashBalance;
  final double openAccountsBalance;
  final int totalProductsCount;
  final int totalCustomersCount;
  final Map<String, double> salesByCategory;
  final Map<PaymentMethodEnum, double> salesByPaymentMethod;

  const DashboardMetricsModel({
    this.todaySales = 0.0,
    this.yesterdaySales = 0.0,
    this.weekSales = 0.0,
    this.monthSales = 0.0,
    this.activeCashBalance = 0.0,
    this.openAccountsBalance = 0.0,
    this.totalProductsCount = 0,
    this.totalCustomersCount = 0,
    this.salesByCategory = const {},
    this.salesByPaymentMethod = const {},
  });

  /// Calculates percentage sales growth compared to previous day.
  double get dailyGrowthPercentage {
    if (yesterdaySales == 0.0) return todaySales > 0 ? 100.0 : 0.0;
    return ((todaySales - yesterdaySales) / yesterdaySales) * 100.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'todaySales': todaySales,
      'yesterdaySales': yesterdaySales,
      'weekSales': weekSales,
      'monthSales': monthSales,
      'activeCashBalance': activeCashBalance,
      'openAccountsBalance': openAccountsBalance,
      'totalProductsCount': totalProductsCount,
      'totalCustomersCount': totalCustomersCount,
      'salesByCategory': salesByCategory,
      'salesByPaymentMethod': salesByPaymentMethod.map(
        (key, value) => MapEntry(key.storageKey, value),
      ),
    };
  }

  factory DashboardMetricsModel.fromMap(Map<String, dynamic> map) {
    final rawByCat = map['salesByCategory'] as Map<String, dynamic>? ?? {};
    final rawByMethod =
        map['salesByPaymentMethod'] as Map<String, dynamic>? ?? {};

    return DashboardMetricsModel(
      todaySales: (map['todaySales'] as num?)?.toDouble() ?? 0.0,
      yesterdaySales: (map['yesterdaySales'] as num?)?.toDouble() ?? 0.0,
      weekSales: (map['weekSales'] as num?)?.toDouble() ?? 0.0,
      monthSales: (map['monthSales'] as num?)?.toDouble() ?? 0.0,
      activeCashBalance: (map['activeCashBalance'] as num?)?.toDouble() ?? 0.0,
      openAccountsBalance:
          (map['openAccountsBalance'] as num?)?.toDouble() ?? 0.0,
      totalProductsCount: (map['totalProductsCount'] as num?)?.toInt() ?? 0,
      totalCustomersCount: (map['totalCustomersCount'] as num?)?.toInt() ?? 0,
      salesByCategory: rawByCat.map(
        (key, value) => MapEntry(key, (value as num?)?.toDouble() ?? 0.0),
      ),
      salesByPaymentMethod: rawByMethod.map(
        (key, value) => MapEntry(
          PaymentMethodEnum.fromStorageKey(key),
          (value as num?)?.toDouble() ?? 0.0,
        ),
      ),
    );
  }
}
