import '../../core/enums/shift_status_enum.dart';

/// Pure domain model representing an operational cashier shift session.
class CashShiftModel {
  final String id;
  final String buId;
  final int cashRegisterNumber;
  final String cashierUserId;
  final DateTime openedAt;
  final DateTime? closedAt;
  final double openingBalance;
  final double cashSales;
  final double cardSales;
  final double creditSales;
  final double cashWithdrawals;
  final double cashInjections;
  final double expectedCashBalance;
  final double? actualCashCounted;
  final double? difference;
  final ShiftDiscrepancyEnum discrepancyStatus;
  final ShiftStatusEnum status;
  final String? supervisorApprovalUserId;

  const CashShiftModel({
    required this.id,
    required this.buId,
    required this.cashRegisterNumber,
    required this.cashierUserId,
    required this.openedAt,
    this.closedAt,
    required this.openingBalance,
    this.cashSales = 0.0,
    this.cardSales = 0.0,
    this.creditSales = 0.0,
    this.cashWithdrawals = 0.0,
    this.cashInjections = 0.0,
    required this.expectedCashBalance,
    this.actualCashCounted,
    this.difference,
    this.discrepancyStatus = ShiftDiscrepancyEnum.balanced,
    required this.status,
    this.supervisorApprovalUserId,
  });

  /// Computes the expected cash balance: Opening + Cash Sales + Injections - Withdrawals.
  static double computeExpectedBalance({
    required double opening,
    required double sales,
    required double injections,
    required double withdrawals,
  }) {
    return opening + sales + injections - withdrawals;
  }

  CashShiftModel copyWith({
    String? id,
    String? buId,
    int? cashRegisterNumber,
    String? cashierUserId,
    DateTime? openedAt,
    DateTime? closedAt,
    double? openingBalance,
    double? cashSales,
    double? cardSales,
    double? creditSales,
    double? cashWithdrawals,
    double? cashInjections,
    double? expectedCashBalance,
    double? actualCashCounted,
    double? difference,
    ShiftDiscrepancyEnum? discrepancyStatus,
    ShiftStatusEnum? status,
    String? supervisorApprovalUserId,
  }) {
    return CashShiftModel(
      id: id ?? this.id,
      buId: buId ?? this.buId,
      cashRegisterNumber: cashRegisterNumber ?? this.cashRegisterNumber,
      cashierUserId: cashierUserId ?? this.cashierUserId,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      openingBalance: openingBalance ?? this.openingBalance,
      cashSales: cashSales ?? this.cashSales,
      cardSales: cardSales ?? this.cardSales,
      creditSales: creditSales ?? this.creditSales,
      cashWithdrawals: cashWithdrawals ?? this.cashWithdrawals,
      cashInjections: cashInjections ?? this.cashInjections,
      expectedCashBalance: expectedCashBalance ?? this.expectedCashBalance,
      actualCashCounted: actualCashCounted ?? this.actualCashCounted,
      difference: difference ?? this.difference,
      discrepancyStatus: discrepancyStatus ?? this.discrepancyStatus,
      status: status ?? this.status,
      supervisorApprovalUserId:
          supervisorApprovalUserId ?? this.supervisorApprovalUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'cashRegisterNumber': cashRegisterNumber,
      'cashierUserId': cashierUserId,
      'openedAt': openedAt.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'openingBalance': openingBalance,
      'cashSales': cashSales,
      'cardSales': cardSales,
      'creditSales': creditSales,
      'cashWithdrawals': cashWithdrawals,
      'cashInjections': cashInjections,
      'expectedCashBalance': expectedCashBalance,
      'actualCashCounted': actualCashCounted,
      'difference': difference,
      'discrepancyStatus': discrepancyStatus.storageKey,
      'status': status.storageKey,
      'supervisorApprovalUserId': supervisorApprovalUserId,
    };
  }

  factory CashShiftModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return CashShiftModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      cashRegisterNumber: (map['cashRegisterNumber'] as num?)?.toInt() ?? 1,
      cashierUserId: map['cashierUserId'] as String? ?? '',
      openedAt: map['openedAt'] != null
          ? DateTime.tryParse(map['openedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      closedAt: map['closedAt'] != null
          ? DateTime.tryParse(map['closedAt'].toString())
          : null,
      openingBalance: (map['openingBalance'] as num?)?.toDouble() ?? 0.0,
      cashSales: (map['cashSales'] as num?)?.toDouble() ?? 0.0,
      cardSales: (map['cardSales'] as num?)?.toDouble() ?? 0.0,
      creditSales: (map['creditSales'] as num?)?.toDouble() ?? 0.0,
      cashWithdrawals: (map['cashWithdrawals'] as num?)?.toDouble() ?? 0.0,
      cashInjections: (map['cashInjections'] as num?)?.toDouble() ?? 0.0,
      expectedCashBalance:
          (map['expectedCashBalance'] as num?)?.toDouble() ?? 0.0,
      actualCashCounted: (map['actualCashCounted'] as num?)?.toDouble(),
      difference: (map['difference'] as num?)?.toDouble(),
      discrepancyStatus: ShiftDiscrepancyEnum.fromStorageKey(
        map['discrepancyStatus'] as String?,
      ),
      status: ShiftStatusEnum.fromStorageKey(map['status'] as String?),
      supervisorApprovalUserId: map['supervisorApprovalUserId'] as String?,
    );
  }
}
