import '../../domain/models/warehouse_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for warehouses and physical stock levels by facility.
abstract class WarehouseRepository {
  Future<List<WarehouseModel>> getWarehouses({
    required String orgId,
    required String buId,
  });

  Future<void> saveWarehouse({
    required String orgId,
    required String buId,
    required WarehouseModel warehouse,
  });

  Future<WarehouseStockModel?> getProductStock({
    required String orgId,
    required String buId,
    required String warehouseId,
    required String productId,
  });

  Future<void> updateProductStock({
    required String orgId,
    required String buId,
    required String warehouseId,
    required WarehouseStockModel stock,
  });

  Future<void> deleteWarehouse({
    required String orgId,
    required String buId,
    required String warehouseId,
  });
}

/// Production implementation of [WarehouseRepository] backed by [FirestoreClient].
class FirestoreWarehouseRepository implements WarehouseRepository {
  final FirestoreClient client;

  const FirestoreWarehouseRepository({required this.client});

  @override
  Future<List<WarehouseModel>> getWarehouses({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client.warehouses(orgId, buId).get();
    return snapshot.docs
        .map((doc) => WarehouseModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<void> saveWarehouse({
    required String orgId,
    required String buId,
    required WarehouseModel warehouse,
  }) async {
    await client
        .warehouses(orgId, buId)
        .doc(warehouse.id)
        .set(warehouse.toMap());
  }

  @override
  Future<WarehouseStockModel?> getProductStock({
    required String orgId,
    required String buId,
    required String warehouseId,
    required String productId,
  }) async {
    final doc = await client
        .warehouseStock(orgId, buId, warehouseId)
        .doc(productId)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    return WarehouseStockModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateProductStock({
    required String orgId,
    required String buId,
    required String warehouseId,
    required WarehouseStockModel stock,
  }) async {
    await client
        .warehouseStock(orgId, buId, warehouseId)
        .doc(stock.productId)
        .set(stock.toMap());
  }

  @override
  Future<void> deleteWarehouse({
    required String orgId,
    required String buId,
    required String warehouseId,
  }) async {
    await client.warehouses(orgId, buId).doc(warehouseId).delete();
  }
}
