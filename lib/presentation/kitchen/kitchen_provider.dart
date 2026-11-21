import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/kds_status_enum.dart';
import '../../data/repositories/kitchen_order_repository.dart';
import '../../domain/models/kitchen_order_model.dart';

/// State provider for Kitchen Display System (KDS), order preparation timers,
/// and station status workflows.
class KitchenProvider extends ChangeNotifier {
  final KitchenOrderRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<KitchenOrderModel> _orders = [];
  KdsStatusEnum? _filterStatus;
  StreamSubscription<List<KitchenOrderModel>>? _subscription;

  KitchenProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  KdsStatusEnum? get filterStatus => _filterStatus;

  List<KitchenOrderModel> get filteredOrders {
    if (_filterStatus == null) return List.unmodifiable(_orders);
    return _orders.where((o) => o.status == _filterStatus).toList();
  }

  void setFilterStatus(KdsStatusEnum? status) {
    _filterStatus = status;
    notifyListeners();
  }

  void startListening({required String orgId, required String buId}) {
    if (_activeOrgId == orgId && _activeBuId == buId && _subscription != null) {
      return;
    }
    _activeOrgId = orgId;
    _activeBuId = buId;
    _subscription?.cancel();
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    _subscription =
        repository.watchActiveOrders(orgId: orgId, buId: buId).listen(
      (fetched) {
        _orders = fetched;
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

  Future<void> loadOrders({required String orgId, required String buId}) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched =
          await repository.getActiveOrders(orgId: orgId, buId: buId);
      _orders = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _orders = [];
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  Future<void> advanceStatus(KitchenOrderModel order) async {
    final next = _getNextStatus(order.status);
    if (next == null) return;

    final idx = _orders.indexWhere((o) => o.id == order.id);
    if (idx == -1) return;

    _orders[idx] = KitchenOrderModel(
      id: order.id,
      buId: order.buId,
      orderCode: order.orderCode,
      tableOrTabName: order.tableOrTabName,
      items: order.items,
      status: next,
      createdAt: order.createdAt,
      completedAt: next == KdsStatusEnum.served ? DateTime.now() : null,
    );
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.updateOrderStatus(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          orderId: order.id,
          status: next,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  KdsStatusEnum? _getNextStatus(KdsStatusEnum current) {
    switch (current) {
      case KdsStatusEnum.pending:
        return KdsStatusEnum.preparing;
      case KdsStatusEnum.preparing:
        return KdsStatusEnum.ready;
      case KdsStatusEnum.ready:
        return KdsStatusEnum.served;
      case KdsStatusEnum.served:
        return null;
      case KdsStatusEnum.cancelled:
        return null;
    }
  }
}
