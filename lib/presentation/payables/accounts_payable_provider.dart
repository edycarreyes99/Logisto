import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/account_payable_repository.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../domain/models/account_payable_model.dart';

/// State provider for commercial accounts payable (CxP),
/// payment schedules, and supplier disbursement tracking.
class AccountsPayableProvider extends ChangeNotifier {
  final AccountPayableRepository repository;
  final SupplierRepository? supplierRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<AccountPayableModel> _payables = [];

  AccountsPayableProvider({required this.repository, this.supplierRepository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<AccountPayableModel> get payables => List.unmodifiable(_payables);

  double get totalLiabilities =>
      _payables.fold(0.0, (acc, p) => acc + p.remainingBalance);

  Future<void> loadPayables({
    required String orgId,
    required String buId,
  }) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      final fetched = await repository.getAccountsPayable(
        orgId: orgId,
        buId: buId,
      );
      if (fetched.isEmpty) {
        _payables = [
          AccountPayableModel(
            id: 'cxp_01',
            buId: buId,
            supplierId: 'sup_01',
            supplierName: 'Compañía Cervecera Nacional',
            invoiceNumber: 'PROV-INV-9921',
            amount: 1250.00,
            paidAmount: 500.00,
            dueDate: DateTime.now().add(const Duration(days: 10)),
            createdAt: DateTime.now().subtract(const Duration(days: 20)),
          ),
          AccountPayableModel(
            id: 'cxp_02',
            buId: buId,
            supplierId: 'sup_02',
            supplierName: 'Distribuidora Avícola El Granjero',
            invoiceNumber: 'PROV-INV-4412',
            amount: 650.00,
            paidAmount: 0.00,
            dueDate: DateTime.now().subtract(const Duration(days: 4)),
            createdAt: DateTime.now().subtract(const Duration(days: 25)),
          ),
        ];
      } else {
        _payables = fetched;
      }
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _payables = [
        AccountPayableModel(
          id: 'cxp_01',
          buId: buId,
          supplierId: 'sup_01',
          supplierName: 'Compañía Cervecera Nacional',
          invoiceNumber: 'PROV-INV-9921',
          amount: 1250.00,
          paidAmount: 500.00,
          dueDate: DateTime.now().add(const Duration(days: 10)),
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        AccountPayableModel(
          id: 'cxp_02',
          buId: buId,
          supplierId: 'sup_02',
          supplierName: 'Distribuidora Avícola El Granjero',
          invoiceNumber: 'PROV-INV-4412',
          amount: 650.00,
          paidAmount: 0.00,
          dueDate: DateTime.now().subtract(const Duration(days: 4)),
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
      ];
      _status = FeatureStatusEnum.loaded;
    } finally {
      notifyListeners();
    }
  }

  Future<void> recordPayment({
    required String payableId,
    required double amount,
  }) async {
    final idx = _payables.indexWhere((p) => p.id == payableId);
    if (idx != -1) {
      final current = _payables[idx];
      final newPaid = current.paidAmount + amount;
      final updated = AccountPayableModel(
        id: current.id,
        buId: current.buId,
        supplierId: current.supplierId,
        supplierName: current.supplierName,
        invoiceNumber: current.invoiceNumber,
        amount: current.amount,
        paidAmount: newPaid,
        dueDate: current.dueDate,
        createdAt: current.createdAt,
      );
      _payables[idx] = updated;
      if (_activeOrgId != null && _activeBuId != null) {
        try {
          await repository.saveAccountPayable(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            ap: updated,
          );
        } catch (_) {}

        if (supplierRepository != null) {
          try {
            final sup = await supplierRepository!.getSupplierById(
              orgId: _activeOrgId!,
              supplierId: current.supplierId,
            );
            if (sup != null) {
              final newBal = (sup.currentPayableBalance - amount).clamp(
                0.0,
                double.infinity,
              );
              await supplierRepository!.saveSupplier(
                orgId: _activeOrgId!,
                supplier: sup.copyWith(currentPayableBalance: newBal),
              );
            }
          } catch (_) {}
        }
      }
      notifyListeners();
    }
  }
}
