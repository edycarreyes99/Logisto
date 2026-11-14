import '../../core/enums/kds_status_enum.dart';

/// Pure domain model for an item line in a kitchen display order.
class KitchenOrderItemModel {
  final String productId;
  final String productName;
  final double quantity;
  final String? notes; // e.g. "bien fría", "sin sal", "término medio"
  final KdsStatusEnum status;

  const KitchenOrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    this.notes,
    this.status = KdsStatusEnum.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'notes': notes,
      'status': status.storageKey,
    };
  }

  factory KitchenOrderItemModel.fromMap(Map<String, dynamic> map) {
    return KitchenOrderItemModel(
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      notes: map['notes'] as String?,
      status: KdsStatusEnum.fromStorageKey(map['status'] as String?),
    );
  }
}

/// Pure domain model for a kitchen/bar ticket order in KDS.
class KitchenOrderModel {
  final String id;
  final String buId;
  final String orderCode;
  final String tableOrTabName;
  final List<KitchenOrderItemModel> items;
  final KdsStatusEnum status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const KitchenOrderModel({
    required this.id,
    required this.buId,
    required this.orderCode,
    required this.tableOrTabName,
    required this.items,
    this.status = KdsStatusEnum.pending,
    required this.createdAt,
    this.completedAt,
  });

  /// Duration in minutes this ticket has been pending or in prep.
  int get elapsedMinutes => DateTime.now().difference(createdAt).inMinutes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buId': buId,
      'orderCode': orderCode,
      'tableOrTabName': tableOrTabName,
      'items': items.map((e) => e.toMap()).toList(),
      'status': status.storageKey,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory KitchenOrderModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return KitchenOrderModel(
      id: docId ?? (map['id'] as String? ?? ''),
      buId: map['buId'] as String? ?? '',
      orderCode: map['orderCode'] as String? ?? '',
      tableOrTabName: map['tableOrTabName'] as String? ?? '',
      items: rawItems
          .map(
            (e) => KitchenOrderItemModel.fromMap(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      status: KdsStatusEnum.fromStorageKey(map['status'] as String?),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'].toString())
          : null,
    );
  }
}
