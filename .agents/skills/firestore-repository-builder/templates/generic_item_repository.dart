import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_collections.dart';
import 'generic_item_dto.dart';

/// Repository coordinating all Cloud Firestore queries and mutations for items.
class GenericItemRepository {
  final AppCollections _collections;
  final FirebaseFirestore _firestore;

  /// Creates a [GenericItemRepository] instance.
  ///
  /// - [collections]: Collection reference registry.
  /// - [firestore]: Underlying Firestore instance for batch operations.
  GenericItemRepository({
    required AppCollections collections,
    required FirebaseFirestore firestore,
  })  : _collections = collections,
        _firestore = firestore;

  /// Real-time stream of DTOs ordered alphabetically by title.
  ///
  /// Emits immediately from local offline cache, then updates on remote server sync.
  Stream<List<GenericItemDto>> watchAll({bool includeMetadataChanges = false}) {
    return _collections.itemsRef
        .orderBy('title', descending: false)
        .snapshots(includeMetadataChanges: includeMetadataChanges)
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// One-shot query reading from cache or server according to specified [source].
  Future<List<GenericItemDto>> getAll({Source source = Source.serverAndCache}) async {
    final snapshot = await _collections.itemsRef
        .orderBy('title', descending: false)
        .get(GetOptions(source: source));
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Fetches a single item document by its unique identifier.
  Future<GenericItemDto?> getById(String id, {Source source = Source.serverAndCache}) async {
    final doc = await _collections.itemsRef.doc(id).get(GetOptions(source: source));
    return doc.data();
  }

  /// Saves or creates an item document with optimistic offline persistence.
  Future<String> save(GenericItemDto dto) async {
    final docRef = dto.id.isEmpty
        ? _collections.itemsRef.doc()
        : _collections.itemsRef.doc(dto.id);
    await docRef.set(dto);
    return docRef.id;
  }

  /// Deletes an item by document ID.
  Future<void> delete(String id) async {
    await _collections.itemsRef.doc(id).delete();
  }

  /// Performs an atomic batch write for multiple items.
  Future<void> batchSave(List<GenericItemDto> items) async {
    final batch = _firestore.batch();
    for (final item in items) {
      final docRef = item.id.isEmpty
          ? _collections.itemsRef.doc()
          : _collections.itemsRef.doc(item.id);
      batch.set(docRef, item);
    }
    await batch.commit();
  }
}
