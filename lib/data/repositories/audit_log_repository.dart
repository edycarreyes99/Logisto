import '../../domain/models/audit_log_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for immutable enterprise audit logging.
abstract class AuditLogRepository {
  Future<void> logAction(AuditLogModel entry);
  Future<List<AuditLogModel>> getRecentLogs({
    required String orgId,
    int limit = 50,
  });
}

/// Production implementation of [AuditLogRepository] backed by [FirestoreClient].
class FirestoreAuditLogRepository implements AuditLogRepository {
  final FirestoreClient client;

  const FirestoreAuditLogRepository({required this.client});

  @override
  Future<void> logAction(AuditLogModel entry) async {
    await client.auditLogs(entry.orgId).doc(entry.id).set(entry.toMap());
  }

  @override
  Future<List<AuditLogModel>> getRecentLogs({
    required String orgId,
    int limit = 50,
  }) async {
    final snapshot = await client
        .auditLogs(orgId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => AuditLogModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }
}
