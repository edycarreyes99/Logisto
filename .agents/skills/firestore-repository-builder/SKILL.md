---
name: firestore-repository-builder
description: |
  Comprehensive procedural guide for constructing Cloud Firestore data infrastructure in Flutter.
  Generates Firestore clients with multiplatform persistence, type-safe collection manifests, DTO mappers, and repositories.
  Mandatory trigger conditions:
  - Trigger when integrating a new Firestore collection or querying documents.
  - Trigger when authoring DTO serializers, converters, batch writes, or snapshot streams.
  Do NOT trigger when:
  - Do not trigger for presentation UI widgets or screen layouts.
  - Do not trigger for pure domain entity modeling without database mappings.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: data
  publisher: Architecture Standards Team
---

# Firestore Repository Builder

> Standard: Enterprise Data Layer  
> Scope: lib/data/firestore/, lib/data/dtos/, lib/data/repositories/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill prescribes the exact architecture for Cloud Firestore integration in Flutter multiplatform apps. It enforces offline-first persistence across Android, iOS, Windows, macOS, and Web, establishes compile-time type-safe collections with `withConverter`, maps database documents to clean domain models through DTOs, and exposes real-time snapshot streams and atomic batch mutations.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Creating a new database entity requiring Cloud Firestore storage.
- Implementing real-time snapshot synchronization (`watchAll()`) or optimistic caching.
- Building Data Transfer Objects (DTOs) with bidirectional domain mapping and `FieldValue.serverTimestamp()`.

### 2.2. When to Avoid This Skill
- Managing UI forms or screen rendering (use `flutter-feature-scaffold`).
- Managing SharedPreferences for session tokens exclusively without Firestore.
- Designing theme tokens or styling variables.

---

## 3. Pre-Flight Verification (Step 0)

Ensure Firebase dependencies and Firestore plugins are configured in `pubspec.yaml`:

```bash
# Verify cloud_firestore dependency
grep -E 'cloud_firestore|firebase_core' pubspec.yaml
```

Ensure `DefaultFirebaseOptions` is generated for the current project via FlutterFire CLI.

---

## 4. Canonical Specification & Standards

### 4.1. File Structure
```
lib/data/
├── firestore/
│   ├── firestore_client.dart            # Multiplatform persistence configuration
│   └── collections/
│       └── app_collections.dart         # Central type-safe collection references
├── dtos/
│   └── [feature]_dto.dart               # DTO with toFirestore, fromFirestore, toDomain
└── repositories/
    └── [feature]_repository.dart        # CRUD operations, watchAll stream, batch writes
```

### 4.2. Invariant Rules
- Every collection MUST use `.withConverter<T>()` to eliminate raw `Map<String, dynamic>` casting in repository logic.
- DTOs MUST encapsulate Firestore-specific types (e.g. `Timestamp`, `FieldValue`) so that Domain models remain 100% pure Dart.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Configure Multiplatform Persistence
Create `lib/data/firestore/firestore_client.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Configures and exposes the FirebaseFirestore instance with multiplatform offline persistence.
class FirestoreClient {
  final FirebaseFirestore _firestore;

  FirestoreClient({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  /// Exposes the configured [FirebaseFirestore] instance.
  FirebaseFirestore get instance => _firestore;
}
```

### Step 2: Implement the Type-Safe Collection Manifest
Create `lib/data/firestore/collections/app_collections.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../dtos/generic_item_dto.dart';
import '../firestore_client.dart';

/// Central registry of type-safe Firestore collection references with converters.
class AppCollections {
  final FirestoreClient _client;

  AppCollections({required FirestoreClient client}) : _client = client;

  /// Returns typed collection reference for generic items.
  CollectionReference<GenericItemDto> get items =>
      _client.instance.collection('items').withConverter<GenericItemDto>(
        fromFirestore: (snapshot, _) => GenericItemDto.fromFirestore(snapshot),
        toFirestore: (dto, _) => dto.toFirestore(),
      );
}
```

### Step 3: Author the Data Transfer Object (DTO)
Create `lib/data/dtos/generic_item_dto.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/item_status_enum.dart';
import '../../domain/models/generic_item_model.dart';

/// Data Transfer Object for serializing and deserializing items to/from Firestore documents.
class GenericItemDto {
  final String id;
  final String title;
  final double value;
  final String status;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const GenericItemDto({
    required this.id,
    required this.title,
    required this.value,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory deserializer converting a Firestore [DocumentSnapshot] into a [GenericItemDto].
  factory GenericItemDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    return GenericItemDto(
      id: snapshot.id,
      title: data['title'] as String? ?? '',
      value: (data['value'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? ItemStatusEnum.draft.storageKey,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  /// Serializes DTO into a Map suitable for Firestore writes.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'value': value,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Maps DTO into pure domain entity.
  GenericItemModel toDomain() {
    return GenericItemModel(
      id: id,
      title: title,
      value: value,
      status: ItemStatusEnum.fromStorageKey(status),
      createdAt: createdAt?.toDate() ?? DateTime.now(),
    );
  }

  /// Constructs DTO from domain model.
  factory GenericItemDto.fromDomain(GenericItemModel model) {
    return GenericItemDto(
      id: model.id,
      title: model.title,
      value: model.value,
      status: model.status.storageKey,
    );
  }
}
```

### Step 4: Implement Repository with Snapshot Streams & Batch Operations
Create `lib/data/repositories/generic_item_repository.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/generic_item_model.dart';
import '../dtos/generic_item_dto.dart';
import '../firestore/collections/app_collections.dart';
import '../firestore/firestore_client.dart';

/// Repository handling persistence operations for generic items.
class GenericItemRepository {
  final FirestoreClient _client;
  final AppCollections _collections;

  GenericItemRepository({
    required FirestoreClient firestoreClient,
    AppCollections? collections,
  })  : _client = firestoreClient,
        _collections = collections ?? AppCollections(client: firestoreClient);

  /// Subscribes to real-time changes across the collection.
  Stream<List<GenericItemModel>> watchAll() {
    return _collections.items
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data().toDomain()).toList());
  }

  /// Persists or updates an item model optimistically.
  Future<String> save(GenericItemModel model) async {
    final dto = GenericItemDto.fromDomain(model);
    final docRef = model.id.isEmpty
        ? _collections.items.doc()
        : _collections.items.doc(model.id);

    await docRef.set(dto, SetOptions(merge: true));
    return docRef.id;
  }

  /// Deletes a document by identifier.
  Future<void> delete(String id) async {
    await _collections.items.doc(id).delete();
  }

  /// Executes atomic batch write across multiple items.
  Future<void> batchSave(List<GenericItemModel> models) async {
    final batch = _client.instance.batch();
    for (final model in models) {
      final docRef = _collections.items.doc(model.id.isEmpty ? null : model.id);
      final dto = GenericItemDto.fromDomain(model);
      batch.set(docRef, dto, SetOptions(merge: true));
    }
    await batch.commit();
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Zero connectivity on startup | `get()` calls hang or time out | Always use `snapshots()` which returns local cached state immediately. |
| Server timestamp is null on optimistic write | `createdAt?.toDate()` throws null error | Fallback to `DateTime.now()` in `toDomain()` when server timestamp is pending. |
| Batch write exceeds 500 operations | Firestore rejects commit with limit exception | Chunk batch operations into slices of 450 items maximum before calling `batch.commit()`. |

---

## 7. Verification & Quality Gates

Run checks to confirm proper data layer decoupling:

```bash
# 1. Ensure no Flutter UI imports in Data layer
rg --glob 'lib/data/**' 'package:flutter/material.dart'

# 2. Verify withConverter is used for collections
rg --glob 'lib/data/firestore/**' 'withConverter'
```

Checklist (see full [references/firestore-data-validation-checklist.md](references/firestore-data-validation-checklist.md)):
- [ ] Offline persistence is explicitly enabled.
- [ ] Collections are registered with type-safe converters.
- [ ] DTOs encapsulate Firestore `Timestamp` and `FieldValue` conversions.
- [ ] Domain models remain 100% free of Firestore dependencies.
- [ ] Public methods have full English Dart Doc comments.
