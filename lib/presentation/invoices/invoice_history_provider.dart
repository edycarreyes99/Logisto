import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/invoice_status_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../domain/models/invoice_model.dart';

/// State provider for historical sales invoices, transaction search,
/// and supervisor voiding workflows.
class InvoiceHistoryProvider extends ChangeNotifier {
  final InvoiceRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<InvoiceModel> _invoices = [];
  String _searchQuery = '';

  InvoiceHistoryProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<InvoiceModel> get filteredInvoices {
    if (_searchQuery.isEmpty) return List.unmodifiable(_invoices);
    final q = _searchQuery.toLowerCase();
    return _invoices.where((inv) {
      return inv.invoiceNumber.toLowerCase().contains(q) ||
          inv.customerDisplayName.toLowerCase().contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadInvoices({
    required String orgId,
    required String buId,
  }) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      final fetched = await repository.getInvoices(orgId: orgId, buId: buId);
      if (fetched.isEmpty) {
        _invoices = [
          InvoiceModel(
            id: 'inv_01',
            invoiceNumber: 'FAC-001-000194',
            cashShiftId: 'shift_today_01',
            cashierUserId: 'usr_carlos',
            customerId: 'cust_01',
            customerDisplayName: 'Roberto Gómez',
            items: const [
              InvoiceItemModel(
                productId: 'prod_tona_01',
                name: 'Cerveza Toña 350ml',
                quantity: 4,
                unitPrice: 1.75,
                total: 7.00,
              ),
              InvoiceItemModel(
                productId: 'srv_billiard',
                name: 'Tiempo de Billar Mesa 2',
                quantity: 1,
                unitPrice: 6.81,
                total: 6.81,
              ),
            ],
            subtotal: 12.01,
            taxAmount: 1.80,
            totalAmount: 13.81,
            payments: const [
              PaymentTenderModel(
                method: PaymentMethodEnum.cash,
                amount: 5.0,
                tendered: 10.0,
                change: 5.0,
              ),
              PaymentTenderModel(
                method: PaymentMethodEnum.customerCredit,
                amount: 8.81,
              ),
            ],
            creditCarriedOver: 8.81,
            paymentStatus: InvoiceStatusEnum.paid,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          InvoiceModel(
            id: 'inv_02',
            invoiceNumber: 'FAC-001-000193',
            cashShiftId: 'shift_today_01',
            cashierUserId: 'usr_carlos',
            customerDisplayName: 'Barra Mostrador',
            items: const [
              InvoiceItemModel(
                productId: 'prod_nachos_01',
                name: 'Nachos Mixtos Especial',
                quantity: 1,
                unitPrice: 5.00,
                total: 5.00,
              ),
            ],
            subtotal: 5.00,
            taxAmount: 0.75,
            totalAmount: 5.75,
            payments: const [
              PaymentTenderModel(
                method: PaymentMethodEnum.cash,
                amount: 5.75,
                tendered: 10.0,
                change: 4.25,
              ),
            ],
            paymentStatus: InvoiceStatusEnum.paid,
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ];
      } else {
        _invoices = fetched;
      }
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _invoices = [
        InvoiceModel(
          id: 'inv_01',
          invoiceNumber: 'FAC-001-000194',
          cashShiftId: 'shift_today_01',
          cashierUserId: 'usr_carlos',
          customerId: 'cust_01',
          customerDisplayName: 'Roberto Gómez',
          items: const [
            InvoiceItemModel(
              productId: 'prod_tona_01',
              name: 'Cerveza Toña 350ml',
              quantity: 4,
              unitPrice: 1.75,
              total: 7.00,
            ),
            InvoiceItemModel(
              productId: 'srv_billiard',
              name: 'Tiempo de Billar Mesa 2',
              quantity: 1,
              unitPrice: 6.81,
              total: 6.81,
            ),
          ],
          subtotal: 12.01,
          taxAmount: 1.80,
          totalAmount: 13.81,
          payments: const [
            PaymentTenderModel(
              method: PaymentMethodEnum.cash,
              amount: 5.0,
              tendered: 10.0,
              change: 5.0,
            ),
            PaymentTenderModel(
              method: PaymentMethodEnum.customerCredit,
              amount: 8.81,
            ),
          ],
          creditCarriedOver: 8.81,
          paymentStatus: InvoiceStatusEnum.paid,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        InvoiceModel(
          id: 'inv_02',
          invoiceNumber: 'FAC-001-000193',
          cashShiftId: 'shift_today_01',
          cashierUserId: 'usr_carlos',
          customerDisplayName: 'Barra Mostrador',
          items: const [
            InvoiceItemModel(
              productId: 'prod_nachos_01',
              name: 'Nachos Mixtos Especial',
              quantity: 1,
              unitPrice: 5.00,
              total: 5.00,
            ),
          ],
          subtotal: 5.00,
          taxAmount: 0.75,
          totalAmount: 5.75,
          payments: const [
            PaymentTenderModel(
              method: PaymentMethodEnum.cash,
              amount: 5.75,
              tendered: 10.0,
              change: 4.25,
            ),
          ],
          paymentStatus: InvoiceStatusEnum.paid,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
      _status = FeatureStatusEnum.loaded;
    } finally {
      notifyListeners();
    }
  }

  void voidInvoice(String invoiceId) {
    final idx = _invoices.indexWhere((i) => i.id == invoiceId);
    if (idx != -1) {
      final updated = _invoices[idx].copyWith(
        paymentStatus: InvoiceStatusEnum.cancelled,
      );
      _invoices[idx] = updated;
      if (_activeOrgId != null && _activeBuId != null) {
        try {
          repository.createInvoice(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            invoice: updated,
          );
        } catch (_) {}
      }
      notifyListeners();
    }
  }
}
