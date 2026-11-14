/// Pure domain model for physical stock level of a product in a warehouse.
class WarehouseStockModel {
  final String productId;
  final double currentQuantity;
  final double reservedQuantity;
  final double minStock;
  final double reorderPoint;

  const WarehouseStockModel({
    required this.productId,
    required this.currentQuantity,
    this.reservedQuantity = 0.0,
    this.minStock = 0.0,
    this.reorderPoint = 0.0,
  });

  /// Available quantity for immediate sale or dispatch.
  double get availableQuantity => currentQuantity - reservedQuantity;

  /// Alias for currentQuantity.
  double get currentStock => currentQuantity;

  /// Alias for minStock.
  double get minimumStock => minStock;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'currentQuantity': currentQuantity,
      'reservedQuantity': reservedQuantity,
      'minStock': minStock,
      'reorderPoint': reorderPoint,
    };
  }

  factory WarehouseStockModel.fromMap(Map<String, dynamic> map) {
    return WarehouseStockModel(
      productId: map['productId'] as String? ?? '',
      currentQuantity: (map['currentQuantity'] as num?)?.toDouble() ?? 0.0,
      reservedQuantity: (map['reservedQuantity'] as num?)?.toDouble() ?? 0.0,
      minStock: (map['minStock'] as num?)?.toDouble() ?? 0.0,
      reorderPoint: (map['reorderPoint'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Pure domain model representing a physical warehouse or storage area.
class WarehouseModel {
  final String id;
  final String buId;
  final String name;
  final String code;
  final bool isSalesDefault;
  final bool isActive;

  const WarehouseModel({
    required this.id,
    required this.buId,
    required this.name,
    required this.code,
    this.isSalesDefault = false,
    this.isActive = true,
  });

  WarehouseModel copyWith({
    String? id,
    String? buId,
    String? name,
    String? code,
    bool? isSalesDefault,
    bool? isActive,
  }) {
    return WarehouseModel(
      id: id ?? this.id,
      buId: buId ?? this.buId,
      name: name ?? this.name,
      code: code ?? this.code,
      isSalesDefault: isSalesDefault ?? this.isSalesDefault,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'name': name,
      'code': code,
      'isSalesDefault': isSalesDefault,
      'isActive': isActive,
    };
  }

  factory WarehouseModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return WarehouseModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      code: map['code'] as String? ?? '',
      isSalesDefault: map['isSalesDefault'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
