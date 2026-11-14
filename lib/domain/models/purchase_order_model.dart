/// Pure domain model for an item line in a purchase order.
class PurchaseOrderItemModel {
  final String productId;
  final String productName;
  final double quantityOrdered;
  final double quantityReceived;
  final double unitCost;
  final double totalCost;

  const PurchaseOrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantityOrdered,
    this.quantityReceived = 0.0,
    required this.unitCost,
    required this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantityOrdered': quantityOrdered,
      'quantityReceived': quantityReceived,
      'unitCost': unitCost,
      'totalCost': totalCost,
    };
  }

  factory PurchaseOrderItemModel.fromMap(Map<String, dynamic> map) {
    return PurchaseOrderItemModel(
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantityOrdered: (map['quantityOrdered'] as num?)?.toDouble() ?? 0.0,
      quantityReceived: (map['quantityReceived'] as num?)?.toDouble() ?? 0.0,
      unitCost: (map['unitCost'] as num?)?.toDouble() ?? 0.0,
      totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Pure domain model representing an inbound purchase order from a supplier.
class PurchaseOrderModel {
  final String id;
  final String buId;
  final String supplierId;
  final String supplierName;
  final DateTime orderDate;
  final DateTime? expectedDeliveryDate;
  final List<PurchaseOrderItemModel> items;
  final double totalAmount;
  final String status; // 'draft', 'ordered', 'received', 'cancelled'

  const PurchaseOrderModel({
    required this.id,
    required this.buId,
    required this.supplierId,
    required this.supplierName,
    required this.orderDate,
    this.expectedDeliveryDate,
    this.items = const [],
    required this.totalAmount,
    this.status = 'draft',
  });

  /// Alias for totalAmount.
  double get totalCost => totalAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'orderDate': orderDate.toIso8601String(),
      'expectedDeliveryDate': expectedDeliveryDate?.toIso8601String(),
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
    };
  }

  factory PurchaseOrderModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return PurchaseOrderModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      supplierId: map['supplierId'] as String? ?? '',
      supplierName: map['supplierName'] as String? ?? '',
      orderDate: map['orderDate'] != null
          ? DateTime.tryParse(map['orderDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      expectedDeliveryDate: map['expectedDeliveryDate'] != null
          ? DateTime.tryParse(map['expectedDeliveryDate'].toString())
          : null,
      items: rawItems
          .map(
            (e) => PurchaseOrderItemModel.fromMap(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'draft',
    );
  }
}
