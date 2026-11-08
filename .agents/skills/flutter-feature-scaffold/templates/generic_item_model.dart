/// Item status enum definition.
enum ItemStatusEnum {
  active(storageKey: 'active'),
  inactive(storageKey: 'inactive'),
  draft(storageKey: 'draft'),
  archived(storageKey: 'archived');

  final String storageKey;
  const ItemStatusEnum({required this.storageKey});
}

/// Pure domain entity model.
///
/// Contains zero dependencies on Flutter UI widgets or external database SDKs.
class GenericItemModel {
  /// Unique document identifier.
  final String id;

  /// Human-readable title of the item.
  final String title;

  /// Unique alphanumeric business code.
  final String code;

  /// Numeric monetary or quantitative value.
  final double value;

  /// Operational lifecycle status governed by [ItemStatusEnum].
  final ItemStatusEnum status;

  /// Optional descriptive text.
  final String? description;

  /// Creates an immutable [GenericItemModel] instance.
  const GenericItemModel({
    required this.id,
    required this.title,
    required this.code,
    required this.value,
    required this.status,
    this.description,
  });

  /// Creates a copy of this model with mutated attributes.
  GenericItemModel copyWith({
    String? id,
    String? title,
    String? code,
    double? value,
    ItemStatusEnum? status,
    String? description,
  }) {
    return GenericItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      code: code ?? this.code,
      value: value ?? this.value,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}
