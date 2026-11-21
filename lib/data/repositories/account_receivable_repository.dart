import '../../domain/models/account_receivable_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for managing customer receivables (CxC) and official cash receipts (ROC).
abstract class AccountReceivableRepository {
  Future<List<AccountReceivableModel>> getAccountsReceivable({
    required String orgId,
    required String buId,
    String? customerId,
  });

  Stream<List<AccountReceivableModel>> watchAccountsReceivable({
    required String orgId,
    required String buId,
    String? customerId,
  });

  Future<void> saveAccountReceivable({
    required String orgId,
    required String buId,
    required AccountReceivableModel ar,
  });

  Future<void> recordPayment({
    required String orgId,
    required String buId,
    required String arId,
    required CreditPaymentModel payment,
  });
}

/// Production implementation of [AccountReceivableRepository] backed by [FirestoreClient].
class FirestoreAccountReceivableRepository
    implements AccountReceivableRepository {
  final FirestoreClient client;

  const FirestoreAccountReceivableRepository({required this.client});

  @override
  Stream<List<AccountReceivableModel>> watchAccountsReceivable({
    required String orgId,
    required String buId,
    String? customerId,
  }) {
    var query = client.accountsReceivable(orgId, buId);
    if (customerId != null) {
      return query
          .where('customerId', isEqualTo: customerId)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) =>
                      AccountReceivableModel.fromMap(doc.data(), docId: doc.id),
                )
                .toList(),
          );
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AccountReceivableModel.fromMap(doc.data(), docId: doc.id),
              )
              .toList(),
        );
  }

  @override
  Future<List<AccountReceivableModel>> getAccountsReceivable({
    required String orgId,
    required String buId,
    String? customerId,
  }) async {
    var query = client.accountsReceivable(orgId, buId);
    if (customerId != null) {
      final snapshot = await query
          .where('customerId', isEqualTo: customerId)
          .get();
      return snapshot.docs
          .map(
            (doc) => AccountReceivableModel.fromMap(doc.data(), docId: doc.id),
          )
          .toList();
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => AccountReceivableModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<void> saveAccountReceivable({
    required String orgId,
    required String buId,
    required AccountReceivableModel ar,
  }) async {
    await client.accountsReceivable(orgId, buId).doc(ar.id).set(ar.toMap());
  }

  @override
  Future<void> recordPayment({
    required String orgId,
    required String buId,
    required String arId,
    required CreditPaymentModel payment,
  }) async {
    final docRef = client.accountsReceivable(orgId, buId).doc(arId);

    await client.instance.runTransaction<void>((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists || snapshot.data() == null) return;

      final ar = AccountReceivableModel.fromMap(
        snapshot.data()!,
        docId: snapshot.id,
      );
      final updatedPayments = List<CreditPaymentModel>.from(ar.payments)
        ..add(payment);
      final totalPaid = updatedPayments.fold<double>(
        0.0,
        (sum, p) => sum + p.amount,
      );
      final remaining = ar.originalAmount - totalPaid;

      transaction.update(docRef, {
        'payments': updatedPayments.map((e) => e.toMap()).toList(),
        'pendingAmount': remaining > 0
            ? double.parse(remaining.toStringAsFixed(2))
            : 0.0,
      });
    });
  }
}
