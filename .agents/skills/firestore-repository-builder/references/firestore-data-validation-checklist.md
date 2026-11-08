# Cloud Firestore & Data Layer Validation Checklist

> Standard: Production-Grade Offline-First Firestore Data Infrastructure  
> Governed Rules: [../../../rules/rule-offline-first-firestore.md](../../../rules/rule-offline-first-firestore.md), [../../../rules/rule-firestore-security-indexing.md](../../../rules/rule-firestore-security-indexing.md), [../../../rules/rule-offline-cache-management.md](../../../rules/rule-offline-cache-management.md), [../../../rules/rule-local-key-value-storage.md](../../../rules/rule-local-key-value-storage.md)  
> Scope: lib/data/**, firestore.rules, firestore.indexes.json  

---

## 1. Multiplatform Offline Persistence & Client Configuration
- [ ] `FirestoreClient.initialize()` configures persistence explicitly across all 5 platform targets.
- [ ] Web target enables multi-tab offline synchronization with `Settings(persistenceEnabled: true)`.
- [ ] Mobile and Desktop targets configure bounded disk cache via `Settings(cacheSizeBytes: 104857600)` (100MB bound).
- [ ] Local cache is populated immediately on startup without blocking the UI thread.
- [ ] Zero unmanaged HTTP network calls bypassing the Firestore persistence pipeline.

## 2. Type-Safe Collections Manifest (`AppCollections`)
- [ ] All collection path strings are defined as private `static const String` constants in `lib/data/firestore/collections/app_collections.dart`.
- [ ] Every collection accessor returns a strongly-typed `CollectionReference<T>` configured with `withConverter<T>`.
- [ ] `fromFirestore` and `toFirestore` converter callbacks handle null snapshots defensively.
- [ ] Zero raw, untyped `FirebaseFirestore.instance.collection('string_literal')` calls anywhere in repository code.
- [ ] Sub-collections follow type-safe parent-path parameter binding.

## 3. Data Transfer Objects (DTO) Serialization & Mapping
- [ ] DTOs are isolated inside `lib/data/dtos/` and never imported into Presentation or Domain.
- [ ] `fromFirestore` parses `DocumentSnapshot` safely with fallbacks for missing or altered schema fields.
- [ ] Date and time fields serialize to/from `Timestamp` using `FieldValue.serverTimestamp()` on create/update.
- [ ] Strongly-typed Enums are serialized to/from string keys using defensive `fromStorageKey` factories with safe defaults.
- [ ] `toDomain()` maps DTOs into pure Domain models with 100% field parity and immutability.
- [ ] Number fields safely cast between `int` and `double` to prevent runtime cast exceptions.

## 4. Repository CRUD, Snapshot Streams & Batch Operations
- [ ] Repositories live in `lib/data/repositories/` and take `AppCollections` and `FirebaseFirestore` via constructor DI.
- [ ] Real-time collection queries expose `watchAll()` returning `Stream<List<DomainModel>>`.
- [ ] `watchAll()` snapshot streams emit immediately from local disk cache before remote network fetch.
- [ ] One-shot read queries specify explicit `Source` options (`Source.serverAndCache`, `Source.cache`).
- [ ] Single-entity operations (`getById`, `save`, `delete`) handle null documents and return nullable domain models.
- [ ] Multi-document writes use `WriteBatch` (`firestore.batch()`) or transactions to guarantee atomic consistency.
- [ ] `save()` operations return the assigned document ID and support optimistic local commit.

## 5. Defensive Error Handling & Network Resiliency
- [ ] Snapshot stream listeners handle permission drops (`FirebaseException(code: 'permission-denied')`) gracefully.
- [ ] Network disconnects trigger offline fallback rather than throwing unhandled exceptions.
- [ ] Timeout bounds are applied to one-shot read operations via `.timeout(const Duration(seconds: 10))`.
- [ ] Out-of-quota errors (`resource-exhausted`) are caught and transformed into localized user alerts.
- [ ] Deleted document lookups return `null` instead of throwing `StateError`.

## 6. Security Rules & Composite Indexing Manifest
- [ ] Security rules in `firestore.rules` mandate tenant and user isolation (`request.auth.uid == resource.data.userId`).
- [ ] All compound queries (combining equality filters with inequalities or sorting) are declared in `firestore.indexes.json`.
- [ ] Unindexed query execution is verified as absent during testing.
- [ ] Read and write rules enforce field-level validation and schema immutability.
