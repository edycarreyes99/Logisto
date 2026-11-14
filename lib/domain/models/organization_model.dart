/// Pure domain model representing an enterprise tenant organization.
class OrganizationModel {
  final String id;
  final String legalName;
  final String commercialName;
  final String taxId;
  final String ownerUserId;
  final String baseCurrency;
  final String secondaryCurrency;
  final double exchangeRate;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;

  const OrganizationModel({
    required this.id,
    required this.legalName,
    required this.commercialName,
    required this.taxId,
    required this.ownerUserId,
    this.baseCurrency = 'USD',
    this.secondaryCurrency = 'NIO',
    this.exchangeRate = 36.65,
    this.hasCompletedOnboarding = false,
    required this.createdAt,
  });

  OrganizationModel copyWith({
    String? id,
    String? legalName,
    String? commercialName,
    String? taxId,
    String? ownerUserId,
    String? baseCurrency,
    String? secondaryCurrency,
    double? exchangeRate,
    bool? hasCompletedOnboarding,
    DateTime? createdAt,
  }) {
    return OrganizationModel(
      id: id ?? this.id,
      legalName: legalName ?? this.legalName,
      commercialName: commercialName ?? this.commercialName,
      taxId: taxId ?? this.taxId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      secondaryCurrency: secondaryCurrency ?? this.secondaryCurrency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'legalName': legalName,
      'commercialName': commercialName,
      'taxId': taxId,
      'ownerUserId': ownerUserId,
      'baseCurrency': baseCurrency,
      'secondaryCurrency': secondaryCurrency,
      'exchangeRate': exchangeRate,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrganizationModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return OrganizationModel(
      id: docId ?? (map['id'] as String? ?? ''),
      legalName: map['legalName'] as String? ?? '',
      commercialName: map['commercialName'] as String? ?? '',
      taxId: map['taxId'] as String? ?? '',
      ownerUserId: map['ownerUserId'] as String? ?? '',
      baseCurrency: map['baseCurrency'] as String? ?? 'USD',
      secondaryCurrency: map['secondaryCurrency'] as String? ?? 'NIO',
      exchangeRate: (map['exchangeRate'] as num?)?.toDouble() ?? 1.0,
      hasCompletedOnboarding: map['hasCompletedOnboarding'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
