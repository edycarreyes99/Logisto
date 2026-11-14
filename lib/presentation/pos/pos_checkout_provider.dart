import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/movement_type_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../data/repositories/account_receivable_repository.dart';
import '../../data/repositories/cash_shift_repository.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/open_account_repository.dart';
import '../../data/repositories/stock_movement_repository.dart';
import '../../domain/models/account_receivable_model.dart';
import '../../domain/models/customer_model.dart';
import '../../domain/models/invoice_model.dart';
import '../../domain/models/open_account_model.dart';
import '../../domain/models/product_model.dart';
import '../../domain/models/stock_movement_model.dart';
import '../../domain/services/checkout_tender_engine.dart';

/// State provider for POS multi-tender checkout, customer credit verification,
/// split bill calculations, and final invoice emission.
class PosCheckoutProvider extends ChangeNotifier {
  final InvoiceRepository invoiceRepository;
  final CheckoutTenderEngine tenderEngine;
  final OpenAccountRepository? openAccountRepository;
  final StockMovementRepository? stockMovementRepository;
  final AccountReceivableRepository? accountReceivableRepository;
  final CustomerRepository? customerRepository;
  final CashShiftRepository? cashShiftRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  CustomerModel? _selectedCustomer;
  String? _originAccountId;
  List<InvoiceItemModel> _cartItems = [];

  double _cashTendered = 0.00;
  double _cardTendered = 0.00;
  double _creditTendered = 0.00;
  CheckoutResult? _lastResult;

  PosCheckoutProvider({
    required this.invoiceRepository,
    required this.tenderEngine,
    this.openAccountRepository,
    this.stockMovementRepository,
    this.accountReceivableRepository,
    this.customerRepository,
    this.cashShiftRepository,
    List<InvoiceItemModel>? initialItems,
  }) : _cartItems = initialItems != null ? List.of(initialItems) : [] {
    _cashTendered = totalAmount;
    _recalculateTender();
  }

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<InvoiceItemModel> get cartItems => List.unmodifiable(_cartItems);
  CustomerModel? get selectedCustomer => _selectedCustomer;
  String? get originAccountId => _originAccountId;
  double get cashTendered => _cashTendered;
  double get cardTendered => _cardTendered;
  double get creditTendered => _creditTendered;
  CheckoutResult? get lastResult => _lastResult;

  double get subtotal => _cartItems.fold(0.0, (acc, item) => acc + item.total);
  double get taxAmount => double.parse((subtotal * 0.15).toStringAsFixed(2));
  double get totalAmount =>
      double.parse((subtotal + taxAmount).toStringAsFixed(2));

  void addItemToCart(ProductModel product, {double quantity = 1.0}) {
    final idx = _cartItems.indexWhere((i) => i.productId == product.id);
    if (idx != -1) {
      final existing = _cartItems[idx];
      final newQty = existing.quantity + quantity;
      _cartItems[idx] = existing.copyWith(
        quantity: newQty,
        total: double.parse((newQty * existing.unitPrice).toStringAsFixed(2)),
      );
    } else {
      _cartItems.add(
        InvoiceItemModel(
          productId: product.id,
          name: product.name,
          quantity: quantity,
          unitPrice: product.salePrice,
          total: double.parse(
            (quantity * product.salePrice).toStringAsFixed(2),
          ),
        ),
      );
    }
    _cashTendered = totalAmount;
    _recalculateTender();
    notifyListeners();
  }

  void updateItemQuantity(String productId, double quantity) {
    if (quantity <= 0) {
      removeItemFromCart(productId);
      return;
    }
    final idx = _cartItems.indexWhere((i) => i.productId == productId);
    if (idx != -1) {
      final existing = _cartItems[idx];
      _cartItems[idx] = existing.copyWith(
        quantity: quantity,
        total: double.parse((quantity * existing.unitPrice).toStringAsFixed(2)),
      );
      _cashTendered = totalAmount;
      _recalculateTender();
      notifyListeners();
    }
  }

  void removeItemFromCart(String productId) {
    _cartItems.removeWhere((i) => i.productId == productId);
    _cashTendered = totalAmount;
    _recalculateTender();
    notifyListeners();
  }

  void selectCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    _creditTendered = 0.0;
    _recalculateTender();
  }

  void updateTenderAmounts({
    required double cash,
    required double card,
    required double credit,
  }) {
    _cashTendered = cash;
    _cardTendered = card;
    _creditTendered = credit;
    _recalculateTender();
  }

  void _recalculateTender() {
    _errorMessage = null;
    final tenders = <PaymentTenderModel>[];

    if (_cashTendered > 0) {
      tenders.add(
        PaymentTenderModel(
          method: PaymentMethodEnum.cash,
          amount: _cashTendered > totalAmount ? totalAmount : _cashTendered,
          tendered: _cashTendered,
        ),
      );
    }
    if (_cardTendered > 0) {
      tenders.add(
        PaymentTenderModel(
          method: PaymentMethodEnum.card,
          amount: _cardTendered,
        ),
      );
    }
    if (_creditTendered > 0) {
      tenders.add(
        PaymentTenderModel(
          method: PaymentMethodEnum.customerCredit,
          amount: _creditTendered,
        ),
      );
    }

    try {
      _lastResult = tenderEngine.processCheckout(
        totalAmount: totalAmount,
        tenders: tenders,
        registeredCustomer: _selectedCustomer,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _lastResult = null;
    }
    notifyListeners();
  }

  void loadFromOpenAccount(OpenAccountModel account) {
    _originAccountId = account.id;
    _cartItems = account.items
        .map(
          (i) => InvoiceItemModel(
            productId: i.productId,
            name: i.name,
            quantity: i.quantity,
            unitPrice: i.unitPrice,
            total: i.total,
          ),
        )
        .toList();
    _selectedCustomer = null;
    _cashTendered = totalAmount;
    _cardTendered = 0.0;
    _creditTendered = 0.0;
    _recalculateTender();
    notifyListeners();
  }

  Future<InvoiceModel?> finalizeInvoice({
    required String orgId,
    required String buId,
    required String cashierId,
    required String cashShiftId,
  }) async {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    _recalculateTender();
    if (_lastResult == null) {
      _status = FeatureStatusEnum.error;
      notifyListeners();
      return null;
    }

    final invoice = InvoiceModel(
      id: 'fac_${DateTime.now().millisecondsSinceEpoch}',
      invoiceNumber:
          'FAC-001-${DateTime.now().millisecondsSinceEpoch % 100000}',
      cashShiftId: cashShiftId,
      cashierUserId: cashierId,
      customerId: _selectedCustomer?.id,
      customerDisplayName: _selectedCustomer?.fullName ?? 'Consumidor Final',
      items: _cartItems,
      subtotal: subtotal,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      payments: _lastResult!.finalizedPayments,
      creditCarriedOver: _lastResult!.creditCarriedOver,
      paymentStatus: _lastResult!.status,
      createdAt: DateTime.now(),
    );

    try {
      await invoiceRepository.createInvoice(
        orgId: orgId,
        buId: buId,
        invoice: invoice,
      );

      // 1. Close associated open account / tab if originated from one
      if (_originAccountId != null && openAccountRepository != null) {
        try {
          await openAccountRepository!.closeAccount(
            orgId: orgId,
            buId: buId,
            accountId: _originAccountId!,
          );
        } catch (_) {}
      }

      // 2. Immediate stock deduction in Kardex for sale items (Module 7 & 19)
      if (stockMovementRepository != null) {
        for (final item in _cartItems) {
          if (!item.name.toLowerCase().contains('billar') &&
              !item.productId.startsWith('srv_')) {
            try {
              await stockMovementRepository!.recordMovement(
                orgId: orgId,
                buId: buId,
                movement: StockMovementModel(
                  id: 'mov_${DateTime.now().millisecondsSinceEpoch}_${item.productId}',
                  buId: buId,
                  warehouseId: 'wh_central',
                  productId: item.productId,
                  productName: item.name,
                  movementType: MovementTypeEnum.salesDeduction,
                  quantity: -item.quantity,
                  unitCost: item.unitPrice * 0.6,
                  totalCost: -(item.quantity * item.unitPrice * 0.6),
                  referenceId: invoice.invoiceNumber,
                  notes: 'POS Sale Checkout: ${invoice.invoiceNumber}',
                  timestamp: DateTime.now(),
                ),
              );
            } catch (_) {}
          }
        }
      }

      // 3. Register Account Receivable and update customer debt on credit (Module 7, 9 & 16)
      if (_lastResult!.creditCarriedOver > 0 && _selectedCustomer != null) {
        if (accountReceivableRepository != null) {
          try {
            final ar = AccountReceivableModel(
              id: 'cxc_${DateTime.now().millisecondsSinceEpoch}',
              buId: buId,
              customerId: _selectedCustomer!.id,
              customerName: _selectedCustomer!.fullName,
              invoiceId: invoice.id,
              invoiceNumber: invoice.invoiceNumber,
              originalAmount: _lastResult!.creditCarriedOver,
              pendingAmount: _lastResult!.creditCarriedOver,
              dueDate: DateTime.now().add(const Duration(days: 30)),
              createdAt: DateTime.now(),
            );
            await accountReceivableRepository!.saveAccountReceivable(
              orgId: orgId,
              buId: buId,
              ar: ar,
            );
          } catch (_) {}
        }
        if (customerRepository != null) {
          try {
            await customerRepository!.updateDebtBalance(
              orgId: orgId,
              customerId: _selectedCustomer!.id,
              newBalance:
                  _selectedCustomer!.currentDebtBalance +
                  _lastResult!.creditCarriedOver,
            );
          } catch (_) {}
        }
      }

      _status = FeatureStatusEnum.loaded;
      notifyListeners();
      return invoice;
    } catch (e) {
      _status = FeatureStatusEnum.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  void resetCart() {
    _cartItems = [];
    _originAccountId = null;
    _selectedCustomer = null;
    _cashTendered = 0.0;
    _cardTendered = 0.0;
    _creditTendered = 0.0;
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}
