import '../../domain/models/account_payable_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for supplier accounts payable (CxP).
abstract class AccountPayableRepository {
  Future<List<AccountPayableModel>> getAccountsPayable({
    required String orgId,
    required String buId,
  });

  Future<void> saveAccountPayable({
    required String orgId,
    required String buId,
    required AccountPayableModel ap,
  });
}

/// Production implementation of [AccountPayableRepository] backed by [FirestoreClient].
class FirestoreAccountPayableRepository implements AccountPayableRepository {
  final FirestoreClient client;

  const FirestoreAccountPayableRepository({required this.client});

  @override
  Future<List<AccountPayableModel>> getAccountsPayable({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client.accountsPayable(orgId, buId).get();
    return snapshot.docs
        .map((doc) => AccountPayableModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<void> saveAccountPayable({
    required String orgId,
    required String buId,
    required AccountPayableModel ap,
  }) async {
    await client.accountsPayable(orgId, buId).doc(ap.id).set(ap.toMap());
  }
}
