import '../../core/enums/kds_status_enum.dart';
import '../../domain/models/kitchen_order_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for kitchen and bar display system (KDS) order workflows.
abstract class KitchenOrderRepository {
  Future<List<KitchenOrderModel>> getActiveOrders({
    required String orgId,
    required String buId,
  });

  Future<void> createOrder({
    required String orgId,
    required String buId,
    required KitchenOrderModel order,
  });

  Future<void> updateOrderStatus({
    required String orgId,
    required String buId,
    required String orderId,
    required KdsStatusEnum status,
  });
}

/// Production implementation of [KitchenOrderRepository] backed by [FirestoreClient].
class FirestoreKitchenOrderRepository implements KitchenOrderRepository {
  final FirestoreClient client;

  const FirestoreKitchenOrderRepository({required this.client});

  @override
  Future<List<KitchenOrderModel>> getActiveOrders({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client
        .kitchenOrders(orgId, buId)
        .where('status', whereIn: ['pending', 'in_preparation', 'ready'])
        .get();

    return snapshot.docs
        .map((doc) => KitchenOrderModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<void> createOrder({
    required String orgId,
    required String buId,
    required KitchenOrderModel order,
  }) async {
    await client.kitchenOrders(orgId, buId).doc(order.id).set(order.toMap());
  }

  @override
  Future<void> updateOrderStatus({
    required String orgId,
    required String buId,
    required String orderId,
    required KdsStatusEnum status,
  }) async {
    await client.kitchenOrders(orgId, buId).doc(orderId).update({
      'status': status.storageKey,
      if (status == KdsStatusEnum.served)
        'completedAt': DateTime.now().toIso8601String(),
    });
  }
}
