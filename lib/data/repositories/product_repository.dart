import '../../domain/models/product_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for master product catalog management across an organization.
abstract class ProductRepository {
  Future<List<ProductModel>> getProducts(String orgId);

  Future<ProductModel?> getProductById({
    required String orgId,
    required String productId,
  });

  Future<void> saveProduct({
    required String orgId,
    required ProductModel product,
  });

  Future<void> deleteProduct({
    required String orgId,
    required String productId,
  });
}

/// Production implementation of [ProductRepository] backed by [FirestoreClient].
class FirestoreProductRepository implements ProductRepository {
  final FirestoreClient client;

  const FirestoreProductRepository({required this.client});

  @override
  Future<List<ProductModel>> getProducts(String orgId) async {
    final snapshot = await client.products(orgId).get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<ProductModel?> getProductById({
    required String orgId,
    required String productId,
  }) async {
    final doc = await client.products(orgId).doc(productId).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProductModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> saveProduct({
    required String orgId,
    required ProductModel product,
  }) async {
    await client.products(orgId).doc(product.id).set(product.toMap());
  }

  @override
  Future<void> deleteProduct({
    required String orgId,
    required String productId,
  }) async {
    await client.products(orgId).doc(productId).delete();
  }
}
