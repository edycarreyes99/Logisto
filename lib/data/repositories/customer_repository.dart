import '../../domain/models/customer_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for customer directory and credit ceiling operations.
abstract class CustomerRepository {
  Future<List<CustomerModel>> getCustomers({required String orgId});

  Future<CustomerModel?> getCustomerByTaxId({
    required String orgId,
    required String taxId,
  });

  Future<CustomerModel?> getCustomerById({
    required String orgId,
    required String customerId,
  });

  Future<void> saveCustomer({
    required String orgId,
    required CustomerModel customer,
  });

  Future<void> updateDebtBalance({
    required String orgId,
    required String customerId,
    required double newBalance,
  });

  Future<void> deleteCustomer({
    required String orgId,
    required String customerId,
  });
}

/// Production implementation of [CustomerRepository] backed by [FirestoreClient].
class FirestoreCustomerRepository implements CustomerRepository {
  final FirestoreClient client;

  const FirestoreCustomerRepository({required this.client});

  @override
  Future<List<CustomerModel>> getCustomers({required String orgId}) async {
    final col = client.customers(orgId);
    final snapshot = await col.get();
    return snapshot.docs
        .map((doc) => CustomerModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<CustomerModel?> getCustomerByTaxId({
    required String orgId,
    required String taxId,
  }) async {
    final snapshot = await client
        .customers(orgId)
        .where('taxId', isEqualTo: taxId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return CustomerModel.fromMap(
      snapshot.docs.first.data(),
      docId: snapshot.docs.first.id,
    );
  }

  @override
  Future<CustomerModel?> getCustomerById({
    required String orgId,
    required String customerId,
  }) async {
    final doc = await client.customers(orgId).doc(customerId).get();
    if (!doc.exists || doc.data() == null) return null;
    return CustomerModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> saveCustomer({
    required String orgId,
    required CustomerModel customer,
  }) async {
    await client.customers(orgId).doc(customer.id).set(customer.toMap());
  }

  @override
  Future<void> updateDebtBalance({
    required String orgId,
    required String customerId,
    required double newBalance,
  }) async {
    await client.customers(orgId).doc(customerId).update({
      'currentDebtBalance': newBalance,
    });
  }

  @override
  Future<void> deleteCustomer({
    required String orgId,
    required String customerId,
  }) async {
    await client.customers(orgId).doc(customerId).delete();
  }
}
