import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/product_type_enum.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product_model.dart';

/// State provider for master product catalog management,
/// typologies (simple, pack, recipe BOM), and cost/sale price controls.
class ProductCatalogProvider extends ChangeNotifier {
  final ProductRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  List<ProductModel> _products = [];
  StreamSubscription<List<ProductModel>>? _subscription;
  String _searchQuery = '';
  ProductTypeEnum? _typeFilter;

  ProductCatalogProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  ProductTypeEnum? get typeFilter => _typeFilter;

  List<ProductModel> get filteredProducts {
    return _products.where((p) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _typeFilter == null || p.productType == _typeFilter;
      return matchesSearch && matchesType;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(ProductTypeEnum? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void startListening(String orgId) {
    if (_activeOrgId == orgId && _subscription != null) return;
    _activeOrgId = orgId;
    _subscription?.cancel();
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    _subscription = repository.watchProducts(orgId).listen(
      (fetched) {
        _products = fetched;
        _status = FeatureStatusEnum.loaded;
        notifyListeners();
      },
      onError: (e) {
        _errorMessage = e.toString();
        _status = FeatureStatusEnum.error;
        notifyListeners();
      },
    );
  }

  Future<void> loadProducts(String orgId) async {
    startListening(orgId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  Future<void> saveProduct({
    String? orgId,
    required ProductModel product,
  }) async {
    final effectiveOrg = orgId ?? _activeOrgId ?? product.orgId;
    if (effectiveOrg.isNotEmpty) {
      try {
        await repository.saveProduct(orgId: effectiveOrg, product: product);
      } catch (_) {}
    }

    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      _products[idx] = product;
    } else {
      _products = [product, ..._products];
    }
    notifyListeners();
  }

  Future<void> deleteProduct({String? orgId, required String productId}) async {
    final effectiveOrg = orgId ?? _activeOrgId;
    if (effectiveOrg != null && effectiveOrg.isNotEmpty) {
      try {
        await repository.deleteProduct(
          orgId: effectiveOrg,
          productId: productId,
        );
      } catch (_) {}
    }
    _products = _products.where((p) => p.id != productId).toList();
    notifyListeners();
  }
}
