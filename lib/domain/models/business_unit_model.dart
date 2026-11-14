import '../../core/enums/business_type_enum.dart';

/// Pure domain model representing an operational business unit (branch/sucursal).
class BusinessUnitModel {
  final String id;
  final String orgId;
  final String name;
  final String taxId;
  final String phone;
  final String address;
  final BusinessTypeEnum businessType;
  final bool isBilliardHall;
  final List<String> enabledModules;
  final bool isActive;
  final DateTime createdAt;

  const BusinessUnitModel({
    required this.id,
    required this.orgId,
    required this.name,
    required this.taxId,
    required this.phone,
    required this.address,
    required this.businessType,
    required this.isBilliardHall,
    this.enabledModules = const [],
    this.isActive = true,
    required this.createdAt,
  });

  BusinessUnitModel copyWith({
    String? id,
    String? orgId,
    String? name,
    String? taxId,
    String? phone,
    String? address,
    BusinessTypeEnum? businessType,
    bool? isBilliardHall,
    List<String>? enabledModules,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BusinessUnitModel(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      taxId: taxId ?? this.taxId,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      businessType: businessType ?? this.businessType,
      isBilliardHall: isBilliardHall ?? this.isBilliardHall,
      enabledModules: enabledModules ?? this.enabledModules,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgId': orgId,
      'name': name,
      'taxId': taxId,
      'phone': phone,
      'address': address,
      'businessType': businessType.storageKey,
      'isBilliardHall': isBilliardHall,
      'enabledModules': enabledModules,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BusinessUnitModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return BusinessUnitModel(
      id: docId ?? (map['id'] as String? ?? ''),
      orgId: map['orgId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      taxId: map['taxId'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      businessType: BusinessTypeEnum.fromStorageKey(
        map['businessType'] as String?,
      ),
      isBilliardHall: map['isBilliardHall'] as bool? ?? false,
      enabledModules:
          (map['enabledModules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
