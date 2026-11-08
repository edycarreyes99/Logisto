import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../rules/rule-strongly-typed-enums.md';

/// Note: In concrete project, import domain model and ItemStatusEnum.
/// Storage discriminator values correspond to ItemStatusEnum.
enum ItemStatusEnum {
  active(storageKey: 'active'),
  inactive(storageKey: 'inactive'),
  draft(storageKey: 'draft'),
  archived(storageKey: 'archived');

  final String storageKey;
  const ItemStatusEnum({required this.storageKey});

  static ItemStatusEnum fromStorageKey(String? key) {
    return ItemStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ItemStatusEnum.active,
    );
  }
}

/// Data Transfer Object representing an item persisted within Cloud Firestore.
///
/// Encapsulates Firestore serialization, server timestamp handling, and strongly-typed enum mapping.
class GenericItemDto {
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

  /// Server timestamp of last document update.
  final DateTime? updatedAt;

  /// Creates an immutable [GenericItemDto] instance.
  const GenericItemDto({
    required this.id,
    required this.title,
    required this.code,
    required this.value,
    required this.status,
    this.description,
    this.updatedAt,
  });

  /// Factory constructor parsing from a Cloud Firestore DocumentSnapshot.
  factory GenericItemDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final timestamp = data['updatedAt'] as Timestamp?;
    final rawStatus = data['status'] as String? ?? '';

    return GenericItemDto(
      id: doc.id,
      title: data['title'] as String? ?? '',
      code: data['code'] as String? ?? '',
      value: (data['value'] as num?)?.toDouble() ?? 0.0,
      status: ItemStatusEnum.fromStorageKey(rawStatus),
      description: data['description'] as String?,
      updatedAt: timestamp?.toDate(),
    );
  }

  /// Converts this DTO to a Firestore document map with ServerTimestamp.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'code': code,
      'value': value,
      'status': status.storageKey,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
