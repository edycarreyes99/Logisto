import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/invoice_status_enum.dart';
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
  StreamSubscription<List<InvoiceModel>>? _subscription;

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

  void startListening({
    required String orgId,
    required String buId,
  }) {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _subscription?.cancel();
    _subscription = repository.watchInvoices(orgId: orgId, buId: buId).listen(
      (invoices) {
        _invoices = invoices;
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
      _invoices = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _invoices = [];
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> voidInvoice(String invoiceId) async {
    final idx = _invoices.indexWhere((i) => i.id == invoiceId);
    if (idx != -1) {
      final updated = _invoices[idx].copyWith(
        paymentStatus: InvoiceStatusEnum.cancelled,
      );
      _invoices[idx] = updated;
      if (_activeOrgId != null && _activeBuId != null) {
        try {
          await repository.createInvoice(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            invoice: updated,
          );
        } catch (_) {}
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
