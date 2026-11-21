import '../../domain/models/business_unit_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for Business Unit (sucursal) persistence and catalog queries.
abstract class BusinessUnitRepository {
  Future<List<BusinessUnitModel>> getBusinessUnits(String orgId);

  Stream<List<BusinessUnitModel>> watchBusinessUnits(String orgId);

  Future<BusinessUnitModel?> getBusinessUnit({
    required String orgId,
    required String buId,
  });

  Future<void> saveBusinessUnit({
    required String orgId,
    required BusinessUnitModel businessUnit,
  });
}

/// Production implementation of [BusinessUnitRepository] backed by [FirestoreClient].
class FirestoreBusinessUnitRepository implements BusinessUnitRepository {
  final FirestoreClient client;

  const FirestoreBusinessUnitRepository({required this.client});

  @override
  Stream<List<BusinessUnitModel>> watchBusinessUnits(String orgId) {
    return client.businessUnits(orgId).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BusinessUnitModel.fromMap(doc.data(), docId: doc.id),
              )
              .toList(),
        );
  }

  @override
  Future<List<BusinessUnitModel>> getBusinessUnits(String orgId) async {
    final snapshot = await client.businessUnits(orgId).get();
    return snapshot.docs
        .map((doc) => BusinessUnitModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<BusinessUnitModel?> getBusinessUnit({
    required String orgId,
    required String buId,
  }) async {
    final doc = await client.businessUnits(orgId).doc(buId).get();
    if (!doc.exists || doc.data() == null) return null;
    return BusinessUnitModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> saveBusinessUnit({
    required String orgId,
    required BusinessUnitModel businessUnit,
  }) async {
    await client
        .businessUnits(orgId)
        .doc(businessUnit.id)
        .set(businessUnit.toMap());
  }
}
