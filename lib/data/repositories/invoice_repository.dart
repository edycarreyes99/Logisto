import '../../domain/models/invoice_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for sales invoice persistence and historical reporting.
abstract class InvoiceRepository {
  Future<void> createInvoice({
    required String orgId,
    required String buId,
    required InvoiceModel invoice,
  });

  Future<List<InvoiceModel>> getInvoices({
    required String orgId,
    required String buId,
  });

  Future<InvoiceModel?> getInvoiceById({
    required String orgId,
    required String buId,
    required String invoiceId,
  });
}

/// Production implementation of [InvoiceRepository] backed by [FirestoreClient].
class FirestoreInvoiceRepository implements InvoiceRepository {
  final FirestoreClient client;

  const FirestoreInvoiceRepository({required this.client});

  @override
  Future<void> createInvoice({
    required String orgId,
    required String buId,
    required InvoiceModel invoice,
  }) async {
    await client.invoices(orgId, buId).doc(invoice.id).set(invoice.toMap());
  }

  @override
  Future<List<InvoiceModel>> getInvoices({
    required String orgId,
    required String buId,
  }) async {
    final snapshot = await client.invoices(orgId, buId).get();
    return snapshot.docs
        .map((doc) => InvoiceModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<InvoiceModel?> getInvoiceById({
    required String orgId,
    required String buId,
    required String invoiceId,
  }) async {
    final doc = await client.invoices(orgId, buId).doc(invoiceId).get();
    if (!doc.exists || doc.data() == null) return null;
    return InvoiceModel.fromMap(doc.data()!, docId: doc.id);
  }
}
