import '../../domain/models/supplier_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for vendor and supplier commercial directory operations.
abstract class SupplierRepository {
  Future<List<SupplierModel>> getSuppliers(String orgId);

  Future<SupplierModel?> getSupplierById({
    required String orgId,
    required String supplierId,
  });

  Future<void> saveSupplier({
    required String orgId,
    required SupplierModel supplier,
  });

  Future<void> deleteSupplier({
    required String orgId,
    required String supplierId,
  });
}

/// Production implementation of [SupplierRepository] backed by [FirestoreClient].
class FirestoreSupplierRepository implements SupplierRepository {
  final FirestoreClient client;

  const FirestoreSupplierRepository({required this.client});

  @override
  Future<List<SupplierModel>> getSuppliers(String orgId) async {
    final snapshot = await client.suppliers(orgId).get();
    return snapshot.docs
        .map((doc) => SupplierModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<SupplierModel?> getSupplierById({
    required String orgId,
    required String supplierId,
  }) async {
    final doc = await client.suppliers(orgId).doc(supplierId).get();
    if (!doc.exists || doc.data() == null) return null;
    return SupplierModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> saveSupplier({
    required String orgId,
    required SupplierModel supplier,
  }) async {
    await client.suppliers(orgId).doc(supplier.id).set(supplier.toMap());
  }

  @override
  Future<void> deleteSupplier({
    required String orgId,
    required String supplierId,
  }) async {
    await client.suppliers(orgId).doc(supplierId).delete();
  }
}
