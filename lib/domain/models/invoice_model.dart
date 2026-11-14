import '../../core/enums/invoice_status_enum.dart';
import '../../core/enums/payment_method_enum.dart';

/// Pure domain model for an individual payment tender entry in a sales checkout.
class PaymentTenderModel {
  final PaymentMethodEnum method;
  final double amount;
  final double? tendered;
  final double? change;
  final String? cardReference;

  const PaymentTenderModel({
    required this.method,
    required this.amount,
    this.tendered,
    this.change,
    this.cardReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'method': method.storageKey,
      'amount': amount,
      'tendered': tendered,
      'change': change,
      'cardReference': cardReference,
    };
  }

  factory PaymentTenderModel.fromMap(Map<String, dynamic> map) {
    return PaymentTenderModel(
      method: PaymentMethodEnum.fromStorageKey(map['method'] as String?),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      tendered: (map['tendered'] as num?)?.toDouble(),
      change: (map['change'] as num?)?.toDouble(),
      cardReference: map['cardReference'] as String?,
    );
  }
}

/// Pure domain model for an item line on a finalized invoice.
class InvoiceItemModel {
  final String productId;
  final String name;
  final double quantity;
  final double unitPrice;
  final double total;
  final double taxRate;

  const InvoiceItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.taxRate = 0.15,
  });

  InvoiceItemModel copyWith({
    String? productId,
    String? name,
    double? quantity,
    double? unitPrice,
    double? total,
    double? taxRate,
  }) {
    return InvoiceItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      total: total ?? this.total,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
      'taxRate': taxRate,
    };
  }

  factory InvoiceItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceItemModel(
      productId: map['productId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0.15,
    );
  }
}

/// Pure domain model representing a commercial checkout sales invoice.
class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String cashShiftId;
  final String cashierUserId;
  final String? customerId;
  final String customerDisplayName;
  final List<InvoiceItemModel> items;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;
  final List<PaymentTenderModel> payments;
  final double creditCarriedOver;
  final InvoiceStatusEnum paymentStatus;
  final DateTime createdAt;

  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.cashShiftId,
    required this.cashierUserId,
    this.customerId,
    required this.customerDisplayName,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.payments,
    this.creditCarriedOver = 0.0,
    required this.paymentStatus,
    required this.createdAt,
  });

  /// Alias for paymentStatus.
  InvoiceStatusEnum get status => paymentStatus;

  /// Alias for createdAt timestamp.
  DateTime get issuedAt => createdAt;

  /// Alias for totalAmount.
  double get total => totalAmount;

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? cashShiftId,
    String? cashierUserId,
    String? customerId,
    String? customerDisplayName,
    List<InvoiceItemModel>? items,
    double? subtotal,
    double? taxAmount,
    double? totalAmount,
    List<PaymentTenderModel>? payments,
    double? creditCarriedOver,
    InvoiceStatusEnum? paymentStatus,
    DateTime? createdAt,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      cashShiftId: cashShiftId ?? this.cashShiftId,
      cashierUserId: cashierUserId ?? this.cashierUserId,
      customerId: customerId ?? this.customerId,
      customerDisplayName: customerDisplayName ?? this.customerDisplayName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      payments: payments ?? this.payments,
      creditCarriedOver: creditCarriedOver ?? this.creditCarriedOver,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'cashShiftId': cashShiftId,
      'cashierUserId': cashierUserId,
      'customerId': customerId,
      'customerDisplayName': customerDisplayName,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'payments': payments.map((e) => e.toMap()).toList(),
      'creditCarriedOver': creditCarriedOver,
      'paymentStatus': paymentStatus.storageKey,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    final rawPayments = map['payments'] as List<dynamic>? ?? [];
    return InvoiceModel(
      id: docId ?? (map['id'] as String? ?? ''),
      invoiceNumber: map['invoiceNumber'] as String? ?? '',
      cashShiftId: map['cashShiftId'] as String? ?? '',
      cashierUserId: map['cashierUserId'] as String? ?? '',
      customerId: map['customerId'] as String?,
      customerDisplayName: map['customerDisplayName'] as String? ?? '',
      items: rawItems
          .map(
            (e) =>
                InvoiceItemModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (map['taxAmount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      payments: rawPayments
          .map(
            (e) =>
                PaymentTenderModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      creditCarriedOver: (map['creditCarriedOver'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: InvoiceStatusEnum.fromStorageKey(
        map['paymentStatus'] as String?,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
