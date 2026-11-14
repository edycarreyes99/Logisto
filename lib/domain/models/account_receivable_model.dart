import '../../core/enums/payment_method_enum.dart';

/// Pure domain model for an individual debt payment / abono against a receivable.
class CreditPaymentModel {
  final String id;
  final String receivableId;
  final double amount;
  final PaymentMethodEnum method;
  final String? reference;
  final String cashierUserId;
  final DateTime receivedAt;

  const CreditPaymentModel({
    required this.id,
    required this.receivableId,
    required this.amount,
    required this.method,
    this.reference,
    required this.cashierUserId,
    required this.receivedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receivableId': receivableId,
      'amount': amount,
      'method': method.storageKey,
      'reference': reference,
      'cashierUserId': cashierUserId,
      'receivedAt': receivedAt.toIso8601String(),
    };
  }

  factory CreditPaymentModel.fromMap(Map<String, dynamic> map) {
    return CreditPaymentModel(
      id: map['id'] as String? ?? '',
      receivableId: map['receivableId'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      method: PaymentMethodEnum.fromStorageKey(map['method'] as String?),
      reference: map['reference'] as String?,
      cashierUserId: map['cashierUserId'] as String? ?? '',
      receivedAt: map['receivedAt'] != null
          ? DateTime.tryParse(map['receivedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

/// Pure domain model representing an open debt receivable from a customer.
class AccountReceivableModel {
  final String id;
  final String buId;
  final String customerId;
  final String customerName;
  final String invoiceId;
  final String invoiceNumber;
  final double originalAmount;
  final double pendingAmount;
  final DateTime dueDate;
  final DateTime createdAt;
  final List<CreditPaymentModel> payments;

  const AccountReceivableModel({
    required this.id,
    required this.buId,
    required this.customerId,
    required this.customerName,
    required this.invoiceId,
    required this.invoiceNumber,
    required this.originalAmount,
    required this.pendingAmount,
    required this.dueDate,
    required this.createdAt,
    this.payments = const [],
  });

  /// True when current date has passed the due date and debt remains unsettled.
  bool get isOverdue => pendingAmount > 0 && DateTime.now().isAfter(dueDate);

  /// Total original invoiced debt amount.
  double get totalAmount => originalAmount;

  /// Remaining unpaid debt balance.
  double get balance => pendingAmount;

  /// Amount paid towards this receivable to date.
  double get paidAmount {
    final paid = originalAmount - pendingAmount;
    return paid > 0 ? paid : 0.0;
  }

  /// Whether the receivable is completely settled.
  bool get isPaid => pendingAmount <= 0.0001;

  AccountReceivableModel copyWith({
    String? id,
    String? buId,
    String? customerId,
    String? customerName,
    String? invoiceId,
    String? invoiceNumber,
    double? originalAmount,
    double? pendingAmount,
    DateTime? dueDate,
    DateTime? createdAt,
    List<CreditPaymentModel>? payments,
  }) {
    return AccountReceivableModel(
      id: id ?? this.id,
      buId: buId ?? this.buId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      originalAmount: originalAmount ?? this.originalAmount,
      pendingAmount: pendingAmount ?? this.pendingAmount,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      payments: payments ?? this.payments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'customerId': customerId,
      'customerName': customerName,
      'invoiceId': invoiceId,
      'invoiceNumber': invoiceNumber,
      'originalAmount': originalAmount,
      'pendingAmount': pendingAmount,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'payments': payments.map((e) => e.toMap()).toList(),
    };
  }

  factory AccountReceivableModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    final rawPayments = map['payments'] as List<dynamic>? ?? [];
    return AccountReceivableModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      customerId: map['customerId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? '',
      invoiceId: map['invoiceId'] as String? ?? '',
      invoiceNumber: map['invoiceNumber'] as String? ?? '',
      originalAmount: (map['originalAmount'] as num?)?.toDouble() ?? 0.0,
      pendingAmount: (map['pendingAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      payments: rawPayments
          .map(
            (e) =>
                CreditPaymentModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
    );
  }
}
