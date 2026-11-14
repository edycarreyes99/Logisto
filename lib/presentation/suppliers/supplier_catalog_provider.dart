import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../domain/models/supplier_model.dart';

/// State provider for commercial supplier master directory,
/// payment terms, credit limits, and payable balances.
class SupplierCatalogProvider extends ChangeNotifier {
  final SupplierRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  List<SupplierModel> _suppliers = [];
  String _searchQuery = '';

  SupplierCatalogProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<SupplierModel> get filteredSuppliers {
    if (_searchQuery.isEmpty) return List.unmodifiable(_suppliers);
    final q = _searchQuery.toLowerCase();
    return _suppliers.where((s) {
      return s.companyName.toLowerCase().contains(q) ||
          s.taxId.toLowerCase().contains(q) ||
          s.contactPerson.toLowerCase().contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadSuppliers(String orgId) async {
    _activeOrgId = orgId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await repository.getSuppliers(orgId);
      _suppliers = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveSupplier({
    String? orgId,
    required SupplierModel supplier,
  }) async {
    final effectiveOrg = orgId ?? _activeOrgId ?? supplier.orgId;
    if (effectiveOrg.isNotEmpty) {
      try {
        await repository.saveSupplier(orgId: effectiveOrg, supplier: supplier);
      } catch (_) {}
    }

    final idx = _suppliers.indexWhere((s) => s.id == supplier.id);
    if (idx != -1) {
      _suppliers[idx] = supplier;
    } else {
      _suppliers = [supplier, ..._suppliers];
    }
    notifyListeners();
  }

  Future<void> deleteSupplier({
    String? orgId,
    required String supplierId,
  }) async {
    final effectiveOrg = orgId ?? _activeOrgId;
    if (effectiveOrg != null && effectiveOrg.isNotEmpty) {
      try {
        await repository.deleteSupplier(
          orgId: effectiveOrg,
          supplierId: supplierId,
        );
      } catch (_) {}
    }
    _suppliers = _suppliers.where((s) => s.id != supplierId).toList();
    notifyListeners();
  }
}
