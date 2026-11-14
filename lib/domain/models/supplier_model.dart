/// Pure domain model representing a commercial goods supplier.
class SupplierModel {
  final String id;
  final String orgId;
  final String companyName;
  final String taxId;
  final String contactPerson;
  final String phone;
  final String email;
  final int creditDays;
  final double creditLimit;
  final double currentPayableBalance;
  final List<String> suppliedProducts;

  const SupplierModel({
    required this.id,
    required this.orgId,
    required this.companyName,
    required this.taxId,
    required this.contactPerson,
    required this.phone,
    this.email = '',
    this.creditDays = 30,
    this.creditLimit = 0.0,
    this.currentPayableBalance = 0.0,
    this.suppliedProducts = const [],
  });

  SupplierModel copyWith({
    String? id,
    String? orgId,
    String? companyName,
    String? taxId,
    String? contactPerson,
    String? phone,
    String? email,
    int? creditDays,
    double? creditLimit,
    double? currentPayableBalance,
    List<String>? suppliedProducts,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      companyName: companyName ?? this.companyName,
      taxId: taxId ?? this.taxId,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      creditDays: creditDays ?? this.creditDays,
      creditLimit: creditLimit ?? this.creditLimit,
      currentPayableBalance:
          currentPayableBalance ?? this.currentPayableBalance,
      suppliedProducts: suppliedProducts ?? this.suppliedProducts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgId': orgId,
      'companyName': companyName,
      'taxId': taxId,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'creditDays': creditDays,
      'creditLimit': creditLimit,
      'currentPayableBalance': currentPayableBalance,
      'suppliedProducts': suppliedProducts,
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return SupplierModel(
      id: docId ?? (map['id'] as String? ?? ''),
      orgId: map['orgId'] as String? ?? '',
      companyName: map['companyName'] as String? ?? '',
      taxId: map['taxId'] as String? ?? '',
      contactPerson: map['contactPerson'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      creditDays: (map['creditDays'] as num?)?.toInt() ?? 30,
      creditLimit: (map['creditLimit'] as num?)?.toDouble() ?? 0.0,
      currentPayableBalance:
          (map['currentPayableBalance'] as num?)?.toDouble() ?? 0.0,
      suppliedProducts:
          (map['suppliedProducts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
