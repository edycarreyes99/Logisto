import '../../domain/models/cash_shift_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for cash shift management and blind drop closures.
abstract class CashShiftRepository {
  Future<CashShiftModel?> getActiveShift({
    required String orgId,
    required String buId,
    required int cashRegisterNumber,
  });

  Future<void> openShift({
    required String orgId,
    required String buId,
    required CashShiftModel shift,
  });

  Future<void> updateShift({
    required String orgId,
    required String buId,
    required CashShiftModel shift,
  });

  Future<void> closeShift({
    required String orgId,
    required String buId,
    required CashShiftModel closedShift,
  });

  Future<List<CashShiftModel>> getShifts({
    required String orgId,
    required String buId,
  });
}

/// Production implementation of [CashShiftRepository] backed by [FirestoreClient].
class FirestoreCashShiftRepository implements CashShiftRepository {
  final FirestoreClient client;

  const FirestoreCashShiftRepository({required this.client});

  @override
  Future<CashShiftModel?> getActiveShift({
    required String orgId,
    required String buId,
    required int cashRegisterNumber,
  }) async {
    final snapshot = await client
        .cashShifts(orgId, buId)
        .where('cashRegisterNumber', isEqualTo: cashRegisterNumber)
        .where('status', isEqualTo: 'open')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return CashShiftModel.fromMap(
      snapshot.docs.first.data(),
      docId: snapshot.docs.first.id,
    );
  }

  @override
  Future<void> openShift({
    required String orgId,
    required String buId,
    required CashShiftModel shift,
  }) async {
    await client.cashShifts(orgId, buId).doc(shift.id).set(shift.toMap());
  }

  @override
  Future<void> updateShift({
    required String orgId,
    required String buId,
    required CashShiftModel shift,
  }) async {
    await client.cashShifts(orgId, buId).doc(shift.id).set(shift.toMap());
  }

  @override
  Future<void> closeShift({
    required String orgId,
    required String buId,
    required CashShiftModel closedShift,
  }) async {
    await client
        .cashShifts(orgId, buId)
        .doc(closedShift.id)
        .set(closedShift.toMap());
  }

  @override
  Future<List<CashShiftModel>> getShifts({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client.cashShifts(orgId, buId).get();
    return snapshot.docs
        .map((doc) => CashShiftModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }
}
