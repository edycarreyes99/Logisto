/// Pure domain model representing an account payable obligation to a supplier.
class AccountPayableModel {
  final String id;
  final String buId;
  final String supplierId;
  final String supplierName;
  final String invoiceNumber;
  final double amount;
  final double paidAmount;
  final DateTime dueDate;
  final DateTime createdAt;

  const AccountPayableModel({
    required this.id,
    required this.buId,
    required this.supplierId,
    required this.supplierName,
    required this.invoiceNumber,
    required this.amount,
    this.paidAmount = 0.0,
    required this.dueDate,
    required this.createdAt,
  });

  /// Remaining unpaid liability amount.
  double get remainingBalance {
    final rem = amount - paidAmount;
    return rem > 0 ? rem : 0.0;
  }

  /// Whether the obligation is completely settled.
  bool get isSettled => remainingBalance <= 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'invoiceNumber': invoiceNumber,
      'amount': amount,
      'paidAmount': paidAmount,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AccountPayableModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    return AccountPayableModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      supplierId: map['supplierId'] as String? ?? '',
      supplierName: map['supplierName'] as String? ?? '',
      invoiceNumber: map['invoiceNumber'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (map['paidAmount'] as num?)?.toDouble() ?? 0.0,
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
