import '../../core/enums/account_origin_type_enum.dart';
import '../../core/enums/account_status_enum.dart';

/// Pure domain model for an item line inside an open account or tab.
class AccountItemModel {
  final String productId;
  final String name;
  final double quantity;
  final double unitPrice;
  final double total;
  final bool isBilliardTime;
  final String? notes;

  const AccountItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.isBilliardTime = false,
    this.notes,
  });

  AccountItemModel copyWith({
    String? productId,
    String? name,
    double? quantity,
    double? unitPrice,
    double? total,
    bool? isBilliardTime,
    String? notes,
  }) {
    return AccountItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      total: total ?? this.total,
      isBilliardTime: isBilliardTime ?? this.isBilliardTime,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
      'isBilliardTime': isBilliardTime,
      'notes': notes,
    };
  }

  factory AccountItemModel.fromMap(Map<String, dynamic> map) {
    return AccountItemModel(
      productId: map['productId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      isBilliardTime: map['isBilliardTime'] as bool? ?? false,
      notes: map['notes'] as String?,
    );
  }
}

/// Pure domain model for an active tab or open account.
class OpenAccountModel {
  final String id;
  final String code;
  final AccountOriginTypeEnum originType;
  final String? tableId;
  final String? tableName;
  final String? customerId;
  final String customerDisplayName;
  final AccountStatusEnum status;
  final List<AccountItemModel> items;
  final double totalAmount;
  final DateTime openedAt;
  final DateTime? closedAt;

  const OpenAccountModel({
    required this.id,
    required this.code,
    required this.originType,
    this.tableId,
    this.tableName,
    this.customerId,
    required this.customerDisplayName,
    required this.status,
    this.items = const [],
    required this.totalAmount,
    required this.openedAt,
    this.closedAt,
  });

  OpenAccountModel copyWith({
    String? id,
    String? code,
    AccountOriginTypeEnum? originType,
    String? tableId,
    String? tableName,
    String? customerId,
    String? customerDisplayName,
    AccountStatusEnum? status,
    List<AccountItemModel>? items,
    double? totalAmount,
    DateTime? openedAt,
    DateTime? closedAt,
  }) {
    return OpenAccountModel(
      id: id ?? this.id,
      code: code ?? this.code,
      originType: originType ?? this.originType,
      tableId: tableId ?? this.tableId,
      tableName: tableName ?? this.tableName,
      customerId: customerId ?? this.customerId,
      customerDisplayName: customerDisplayName ?? this.customerDisplayName,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'originType': originType.storageKey,
      'tableId': tableId,
      'tableName': tableName,
      'customerId': customerId,
      'customerDisplayName': customerDisplayName,
      'status': status.storageKey,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'openedAt': openedAt.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
    };
  }

  factory OpenAccountModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return OpenAccountModel(
      id: docId ?? (map['id'] as String? ?? ''),
      code: map['code'] as String? ?? '',
      originType: AccountOriginTypeEnum.fromStorageKey(map['originType'] as String?),
      tableId: map['tableId'] as String?,
      tableName: map['tableName'] as String?,
      customerId: map['customerId'] as String?,
      customerDisplayName: map['customerDisplayName'] as String? ?? '',
      status: AccountStatusEnum.fromStorageKey(map['status'] as String?),
      items: rawItems
          .map(
            (e) =>
                AccountItemModel.fromMap(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      openedAt: map['openedAt'] != null
          ? DateTime.tryParse(map['openedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      closedAt: map['closedAt'] != null
          ? DateTime.tryParse(map['closedAt'].toString())
          : null,
    );
  }
}
