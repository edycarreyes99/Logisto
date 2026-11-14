import '../../core/enums/movement_type_enum.dart';

/// Pure domain model for an immutable inventory kardex stock movement.
class StockMovementModel {
  final String id;
  final String buId;
  final String warehouseId;
  final String productId;
  final String productName;
  final MovementTypeEnum movementType;
  final double quantity; // Positive for inbound, negative for outbound
  final double unitCost;
  final double totalCost;
  final String? referenceId; // InvoiceId, PurchaseOrderId, TransferId
  final String? notes;
  final DateTime timestamp;

  const StockMovementModel({
    required this.id,
    required this.buId,
    required this.warehouseId,
    required this.productId,
    required this.productName,
    required this.movementType,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    this.referenceId,
    this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'warehouseId': warehouseId,
      'productId': productId,
      'productName': productName,
      'movementType': movementType.storageKey,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'referenceId': referenceId,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StockMovementModel.fromMap(
    Map<String, dynamic> map, {
    String? docId,
  }) {
    return StockMovementModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      warehouseId: map['warehouseId'] as String? ?? '',
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      movementType: MovementTypeEnum.fromStorageKey(
        map['movementType'] as String?,
      ),
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      unitCost: (map['unitCost'] as num?)?.toDouble() ?? 0.0,
      totalCost: (map['totalCost'] as num?)?.toDouble() ?? 0.0,
      referenceId: map['referenceId'] as String?,
      notes: map['notes'] as String?,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
