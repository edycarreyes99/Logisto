import '../../core/enums/account_status_enum.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/models/open_account_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for open accounts / bar tabs persistence.
abstract class OpenAccountRepository {
  Future<List<OpenAccountModel>> getOpenAccounts({
    required String orgId,
    required String buId,
  });

  Future<OpenAccountModel?> getAccountById({
    required String orgId,
    required String buId,
    required String accountId,
  });

  Future<void> saveAccount({
    required String orgId,
    required String buId,
    required OpenAccountModel account,
  });

  Future<void> addItemToAccount({
    required String orgId,
    required String buId,
    required String accountId,
    required AccountItemModel item,
  });

  Future<void> closeAccount({
    required String orgId,
    required String buId,
    required String accountId,
  });
}

/// Production implementation of [OpenAccountRepository] backed by [FirestoreClient].
class FirestoreOpenAccountRepository implements OpenAccountRepository {
  final FirestoreClient client;

  const FirestoreOpenAccountRepository({required this.client});

  @override
  Future<List<OpenAccountModel>> getOpenAccounts({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client
        .openAccounts(orgId, buId)
        .where('status', isEqualTo: 'open')
        .get();

    return snapshot.docs
        .map((doc) => OpenAccountModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<OpenAccountModel?> getAccountById({
    required String orgId,
    required String buId,
    required String accountId,
  }) async {
    final snapshot = await client
        .openAccounts(orgId, buId)
        .doc(accountId)
        .get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return OpenAccountModel.fromMap(snapshot.data()!, docId: snapshot.id);
  }

  @override
  Future<void> saveAccount({
    required String orgId,
    required String buId,
    required OpenAccountModel account,
  }) async {
    await client.openAccounts(orgId, buId).doc(account.id).set(account.toMap());
  }

  @override
  Future<void> addItemToAccount({
    required String orgId,
    required String buId,
    required String accountId,
    required AccountItemModel item,
  }) async {
    final docRef = client.openAccounts(orgId, buId).doc(accountId);

    await client.instance.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) {
        throw const AppException('Open account document not found.');
      }

      final account = OpenAccountModel.fromMap(
        snapshot.data()!,
        docId: snapshot.id,
      );
      final updatedItems = List<AccountItemModel>.from(account.items)
        ..add(item);
      final newTotal = updatedItems.fold<double>(
        0.0,
        (sum, i) => sum + i.total,
      );

      transaction.update(docRef, {
        'items': updatedItems.map((e) => e.toMap()).toList(),
        'totalAmount': double.parse(newTotal.toStringAsFixed(2)),
      });
    });
  }

  @override
  Future<void> closeAccount({
    required String orgId,
    required String buId,
    required String accountId,
  }) async {
    await client.openAccounts(orgId, buId).doc(accountId).update({
      'status': AccountStatusEnum.closed.storageKey,
      'closedAt': DateTime.now().toIso8601String(),
    });
  }
}
