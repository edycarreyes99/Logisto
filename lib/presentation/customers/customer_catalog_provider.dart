import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/customer_repository.dart';
import '../../domain/models/customer_model.dart';

/// State provider for corporate-wide customer directory, credit ceiling policies,
/// and credit block status.
class CustomerCatalogProvider extends ChangeNotifier {
  final CustomerRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  List<CustomerModel> _customers = [];
  String _searchQuery = '';

  CustomerCatalogProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<CustomerModel> get filteredCustomers {
    if (_searchQuery.isEmpty) return List.unmodifiable(_customers);
    final q = _searchQuery.toLowerCase();
    return _customers.where((c) {
      return c.fullName.toLowerCase().contains(q) ||
          c.taxId.toLowerCase().contains(q) ||
          c.phone.contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadCustomers(String orgId) async {
    _activeOrgId = orgId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await repository.getCustomers(orgId: orgId);
      _customers = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveCustomer({
    required String orgId,
    required CustomerModel customer,
  }) async {
    final idx = _customers.indexWhere((c) => c.id == customer.id);
    if (idx != -1) {
      _customers[idx] = customer;
    } else {
      _customers = [customer, ..._customers];
    }
    try {
      await repository.saveCustomer(orgId: orgId, customer: customer);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> deleteCustomer({
    required String orgId,
    required String customerId,
  }) async {
    try {
      await repository.deleteCustomer(orgId: orgId, customerId: customerId);
    } catch (_) {}
    _customers = _customers.where((c) => c.id != customerId).toList();
    notifyListeners();
  }

  Future<void> toggleCreditBlock(String customerId) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx != -1) {
      final updated = _customers[idx].copyWith(
        isCreditBlocked: !_customers[idx].isCreditBlocked,
      );
      _customers[idx] = updated;
      final effectiveOrg = _activeOrgId ?? _customers[idx].orgId;
      if (effectiveOrg.isNotEmpty) {
        try {
          await repository.saveCustomer(orgId: effectiveOrg, customer: updated);
        } catch (_) {}
      }
      notifyListeners();
    }
  }
}
