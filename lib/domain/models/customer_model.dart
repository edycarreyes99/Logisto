/// Pure domain model representing an enterprise customer with credit account.
class CustomerModel {
  final String id;
  final String orgId;
  final String taxId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final List<String> associatedBusinessUnits;
  final double creditLimit;
  final double currentDebtBalance;
  final bool isCreditBlocked;
  final DateTime createdAt;

  const CustomerModel({
    required this.id,
    required this.orgId,
    required this.taxId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.email = '',
    this.associatedBusinessUnits = const [],
    this.creditLimit = 0.0,
    this.currentDebtBalance = 0.0,
    this.isCreditBlocked = false,
    required this.createdAt,
  });

  /// Full concatenated display name.
  String get fullName => '$firstName $lastName'.trim();

  /// Available credit headroom for new purchases.
  double get availableCredit {
    final remaining = creditLimit - currentDebtBalance;
    return remaining > 0.0001
        ? double.parse(remaining.toStringAsFixed(2))
        : 0.0;
  }

  /// Evaluates whether the customer can accept an additional credit charge of [amount].
  bool canChargeCredit(double amount) {
    if (isCreditBlocked || amount <= 0.0) return false;
    final projectedDebt = currentDebtBalance + amount;
    final roundedProjected = double.parse(projectedDebt.toStringAsFixed(2));
    final roundedLimit = double.parse(creditLimit.toStringAsFixed(2));
    return roundedProjected <= roundedLimit;
  }

  CustomerModel copyWith({
    String? id,
    String? orgId,
    String? taxId,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    List<String>? associatedBusinessUnits,
    double? creditLimit,
    double? currentDebtBalance,
    bool? isCreditBlocked,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      taxId: taxId ?? this.taxId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      associatedBusinessUnits:
          associatedBusinessUnits ?? this.associatedBusinessUnits,
      creditLimit: creditLimit ?? this.creditLimit,
      currentDebtBalance: currentDebtBalance ?? this.currentDebtBalance,
      isCreditBlocked: isCreditBlocked ?? this.isCreditBlocked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgId': orgId,
      'taxId': taxId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'associatedBusinessUnits': associatedBusinessUnits,
      'creditLimit': creditLimit,
      'currentDebtBalance': currentDebtBalance,
      'isCreditBlocked': isCreditBlocked,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return CustomerModel(
      id: docId ?? (map['id'] as String? ?? ''),
      orgId: map['orgId'] as String? ?? '',
      taxId: map['taxId'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      associatedBusinessUnits:
          (map['associatedBusinessUnits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      creditLimit: (map['creditLimit'] as num?)?.toDouble() ?? 0.0,
      currentDebtBalance:
          (map['currentDebtBalance'] as num?)?.toDouble() ?? 0.0,
      isCreditBlocked: map['isCreditBlocked'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
