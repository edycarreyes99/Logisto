import '../../domain/models/stock_movement_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for inventory movements and permanent Kardex ledger tracking.
abstract class StockMovementRepository {
  Future<void> recordMovement({
    required String orgId,
    required String buId,
    required StockMovementModel movement,
  });

  Future<List<StockMovementModel>> getMovements({
    required String orgId,
    required String buId,
    String? productId,
  });
}

/// Production implementation of [StockMovementRepository] backed by [FirestoreClient].
class FirestoreStockMovementRepository implements StockMovementRepository {
  final FirestoreClient client;

  const FirestoreStockMovementRepository({required this.client});

  @override
  Future<void> recordMovement({
    required String orgId,
    required String buId,
    required StockMovementModel movement,
  }) async {
    await client
        .stockMovements(orgId, buId)
        .doc(movement.id)
        .set(movement.toMap());
  }

  @override
  Future<List<StockMovementModel>> getMovements({
    required String orgId,
    required String buId,
    String? productId,
  }) async {
    var query = client.stockMovements(orgId, buId);
    if (productId != null) {
      final snapshot = await query
          .where('productId', isEqualTo: productId)
          .get();
      return snapshot.docs
          .map((doc) => StockMovementModel.fromMap(doc.data(), docId: doc.id))
          .toList();
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => StockMovementModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }
}
