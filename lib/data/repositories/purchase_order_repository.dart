import '../../domain/models/purchase_order_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for procurement purchase order workflows.
abstract class PurchaseOrderRepository {
  Future<List<PurchaseOrderModel>> getPurchaseOrders({
    required String orgId,
    required String buId,
  });

  Future<void> savePurchaseOrder({
    required String orgId,
    required String buId,
    required PurchaseOrderModel order,
  });
}

/// Production implementation of [PurchaseOrderRepository] backed by [FirestoreClient].
class FirestorePurchaseOrderRepository implements PurchaseOrderRepository {
  final FirestoreClient client;

  const FirestorePurchaseOrderRepository({required this.client});

  @override
  Future<List<PurchaseOrderModel>> getPurchaseOrders({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client.purchaseOrders(orgId, buId).get();
    return snapshot.docs
        .map((doc) => PurchaseOrderModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<void> savePurchaseOrder({
    required String orgId,
    required String buId,
    required PurchaseOrderModel order,
  }) async {
    await client.purchaseOrders(orgId, buId).doc(order.id).set(order.toMap());
  }
}
