import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../data/repositories/account_receivable_repository.dart';
import '../../data/repositories/customer_repository.dart';
import '../../domain/models/account_receivable_model.dart';

/// State provider for customer debt ledger (Accounts Receivable - CxC),
/// credit payment collection, and official receipt (ROC) emission.
class AccountsReceivableProvider extends ChangeNotifier {
  final AccountReceivableRepository repository;
  final CustomerRepository? customerRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<AccountReceivableModel> _receivables = [];
  StreamSubscription<List<AccountReceivableModel>>? _subscription;

  AccountsReceivableProvider({
    required this.repository,
    this.customerRepository,
  });

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<AccountReceivableModel> get receivables =>
      List.unmodifiable(_receivables);

  double get totalOutstandingDebt =>
      _receivables.fold(0.0, (acc, r) => acc + r.balance);

  void startListening({
    required String orgId,
    required String buId,
  }) {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _subscription?.cancel();
    _subscription = repository
        .watchAccountsReceivable(orgId: orgId, buId: buId)
        .listen(
      (receivables) {
        _receivables = receivables;
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

  Future<void> loadReceivables({
    required String orgId,
    required String buId,
  }) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      final fetched = await repository.getAccountsReceivable(
        orgId: orgId,
        buId: buId,
      );
      _receivables = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _receivables = [];
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> recordPayment({
    required String receivableId,
    required double amount,
    required PaymentMethodEnum method,
    String? cashierUserId,
  }) async {
    final idx = _receivables.indexWhere((r) => r.id == receivableId);
    if (idx != -1) {
      final current = _receivables[idx];
      final newPending = current.pendingAmount - amount;
      final payment = CreditPaymentModel(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        receivableId: receivableId,
        amount: amount,
        method: method,
        cashierUserId: cashierUserId ?? 'usr_cashier',
        receivedAt: DateTime.now(),
      );
      _receivables[idx] = current.copyWith(
        pendingAmount: newPending > 0 ? newPending : 0.0,
        payments: [...current.payments, payment],
      );
      if (_activeOrgId != null && _activeBuId != null) {
        try {
          await repository.recordPayment(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            arId: receivableId,
            payment: payment,
          );
        } catch (_) {}

        if (customerRepository != null) {
          try {
            final cust = await customerRepository!.getCustomerById(
              orgId: _activeOrgId!,
              customerId: current.customerId,
            );
            if (cust != null) {
              final newBal = (cust.currentDebtBalance - amount).clamp(
                0.0,
                double.infinity,
              );
              await customerRepository!.updateDebtBalance(
                orgId: _activeOrgId!,
                customerId: cust.id,
                newBalance: newBal,
              );
            }
          } catch (_) {}
        }
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
