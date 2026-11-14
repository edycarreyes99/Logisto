import '../../domain/models/billiard_table_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for billiard table persistence and real-time operations.
abstract class BilliardTableRepository {
  Future<List<BilliardTableModel>> getTables({
    required String orgId,
    required String buId,
  });

  Future<void> saveTable({
    required String orgId,
    required String buId,
    required BilliardTableModel table,
  });

  Future<void> updateTableSession({
    required String orgId,
    required String buId,
    required String tableId,
    required BilliardSessionModel? session,
  });

  Future<void> deleteTable({
    required String orgId,
    required String buId,
    required String tableId,
  });
}

/// Production implementation of [BilliardTableRepository] backed by [FirestoreClient].
class FirestoreBilliardTableRepository implements BilliardTableRepository {
  final FirestoreClient client;

  const FirestoreBilliardTableRepository({required this.client});

  @override
  Future<List<BilliardTableModel>> getTables({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client.tables(orgId, buId).get();
    return snapshot.docs
        .map((doc) => BilliardTableModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<void> saveTable({
    required String orgId,
    required String buId,
    required BilliardTableModel table,
  }) async {
    await client.tables(orgId, buId).doc(table.id).set(table.toMap());
  }

  @override
  Future<void> updateTableSession({
    required String orgId,
    required String buId,
    required String tableId,
    required BilliardSessionModel? session,
  }) async {
    await client.tables(orgId, buId).doc(tableId).update({
      'currentSession': session?.toMap(),
      'status': session == null
          ? 'available'
          : (session.isPaused ? 'paused' : 'occupied'),
    });
  }

  @override
  Future<void> deleteTable({
    required String orgId,
    required String buId,
    required String tableId,
  }) async {
    await client.tables(orgId, buId).doc(tableId).delete();
  }
}
