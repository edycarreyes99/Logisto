import 'package:flutter/foundation.dart';
import '../../core/enums/account_status_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/open_account_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/open_account_model.dart';
import '../../domain/models/product_model.dart';

/// State provider for open customer and billiard table tabs,
/// quick-add product charging, and real-time item adjustments.
class OpenAccountsProvider extends ChangeNotifier {
  final OpenAccountRepository repository;
  final ProductRepository? productRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<OpenAccountModel> _accounts = [];
  OpenAccountModel? _selectedAccount;
  List<ProductModel> _quickCatalog = [];

  OpenAccountsProvider({required this.repository, this.productRepository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<OpenAccountModel> get accounts => List.unmodifiable(_accounts);
  OpenAccountModel? get selectedAccount => _selectedAccount;
  List<ProductModel> get quickCatalog => List.unmodifiable(_quickCatalog);

  Future<void> loadAccounts({
    required String orgId,
    required String buId,
  }) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await repository.getOpenAccounts(
        orgId: orgId,
        buId: buId,
      );
      _accounts = fetched;

      if (_accounts.isNotEmpty && _selectedAccount == null) {
        _selectedAccount = _accounts.first;
      }

      if (productRepository != null) {
        final prods = await productRepository!.getProducts(orgId);
        _quickCatalog = prods;
      }

      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  void selectAccount(String id) {
    _selectedAccount = _accounts.firstWhere((a) => a.id == id);
    notifyListeners();
  }

  void addProductToSelected(ProductModel product) {
    if (_selectedAccount == null) return;

    final existingIndex = _selectedAccount!.items.indexWhere(
      (item) => item.productId == product.id && !item.isBilliardTime,
    );

    List<AccountItemModel> updatedItems = List.from(_selectedAccount!.items);

    if (existingIndex != -1) {
      final existing = updatedItems[existingIndex];
      final newQty = existing.quantity + 1;
      updatedItems[existingIndex] = existing.copyWith(
        quantity: newQty,
        total: double.parse((newQty * existing.unitPrice).toStringAsFixed(2)),
      );
    } else {
      updatedItems.add(
        AccountItemModel(
          productId: product.id,
          name: product.name,
          quantity: 1,
          unitPrice: product.salePrice,
          total: product.salePrice,
        ),
      );
    }

    final newTotal = updatedItems.fold<double>(
      0.0,
      (acc, item) => acc + item.total,
    );

    _selectedAccount = _selectedAccount!.copyWith(
      items: updatedItems,
      totalAmount: double.parse(newTotal.toStringAsFixed(2)),
    );

    final idx = _accounts.indexWhere((a) => a.id == _selectedAccount!.id);
    if (idx != -1) {
      _accounts[idx] = _selectedAccount!;
    }
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        repository.saveAccount(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          account: _selectedAccount!,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  void adjustItemQuantity(int itemIndex, double delta) {
    if (_selectedAccount == null ||
        itemIndex >= _selectedAccount!.items.length) {
      return;
    }

    List<AccountItemModel> updatedItems = List.from(_selectedAccount!.items);
    final current = updatedItems[itemIndex];
    final newQty = current.quantity + delta;

    if (newQty <= 0) {
      updatedItems.removeAt(itemIndex);
    } else {
      updatedItems[itemIndex] = current.copyWith(
        quantity: newQty,
        total: double.parse((newQty * current.unitPrice).toStringAsFixed(2)),
      );
    }

    final newTotal = updatedItems.fold<double>(
      0.0,
      (acc, item) => acc + item.total,
    );
    _selectedAccount = _selectedAccount!.copyWith(
      items: updatedItems,
      totalAmount: double.parse(newTotal.toStringAsFixed(2)),
    );

    final idx = _accounts.indexWhere((a) => a.id == _selectedAccount!.id);
    if (idx != -1) {
      _accounts[idx] = _selectedAccount!;
    }
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        repository.saveAccount(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          account: _selectedAccount!,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> createNewAccount({
    required String name,
    required String originType,
    String? tableId,
    String? tableName,
  }) async {
    final newAcc = OpenAccountModel(
      id: 'tab_${DateTime.now().millisecondsSinceEpoch}',
      code: 'TAB-${_accounts.length + 101}',
      originType: originType,
      tableId: tableId,
      tableName: tableName,
      customerDisplayName: name,
      status: AccountStatusEnum.open,
      items: const [],
      totalAmount: 0.0,
      openedAt: DateTime.now(),
    );

    _accounts = [..._accounts, newAcc];
    _selectedAccount = newAcc;
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.saveAccount(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          account: newAcc,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> closeSelectedAccount() async {
    if (_selectedAccount == null) return;
    final toClose = _selectedAccount!;
    _accounts.removeWhere((a) => a.id == toClose.id);
    _selectedAccount = _accounts.isNotEmpty ? _accounts.first : null;
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.closeAccount(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          accountId: toClose.id,
        );
      } catch (_) {}
    }
    notifyListeners();
  }
}
