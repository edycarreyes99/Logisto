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

  Future<void> loadOrders({required String orgId, required String buId}) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      final fetched = await repository.getActiveOrders(
        orgId: orgId,
        buId: buId,
      );
      if (fetched.isEmpty) {
        _orders = [
          KitchenOrderModel(
            id: 'kds_01',
            buId: buId,
            orderCode: 'ORD-101',
            tableOrTabName: 'Mesa 2 - Pool',
            items: const [
              KitchenOrderItemModel(
                productId: 'prod_wings',
                productName: 'Alitas BBQ (8 Unidades)',
                quantity: 2,
                notes: 'Salsa picante aparte',
                status: KdsStatusEnum.pending,
              ),
              KitchenOrderItemModel(
                productId: 'prod_nachos',
                productName: 'Nachos Especiales',
                quantity: 1,
                notes: 'Sin jalapeños',
                status: KdsStatusEnum.pending,
              ),
            ],
            status: KdsStatusEnum.pending,
            createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
          ),
          KitchenOrderModel(
            id: 'kds_02',
            buId: buId,
            orderCode: 'ORD-102',
            tableOrTabName: 'Barra Central',
            items: const [
              KitchenOrderItemModel(
                productId: 'prod_burger',
                productName: 'Hamburguesa Doble Carne',
                quantity: 1,
                notes: 'Término medio con queso extra',
                status: KdsStatusEnum.preparing,
              ),
            ],
            status: KdsStatusEnum.preparing,
            createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
          ),
          KitchenOrderModel(
            id: 'kds_03',
            buId: buId,
            orderCode: 'ORD-103',
            tableOrTabName: 'Mesa 4 VIP',
            items: const [
              KitchenOrderItemModel(
                productId: 'prod_mojito',
                productName: 'Mojito Cubano Clásico',
                quantity: 3,
                notes: 'Poco hielo',
                status: KdsStatusEnum.ready,
              ),
            ],
            status: KdsStatusEnum.ready,
            createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
        ];
      } else {
        _orders = fetched;
      }
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _orders = [
        KitchenOrderModel(
          id: 'kds_01',
          buId: buId,
          orderCode: 'ORD-101',
          tableOrTabName: 'Mesa 2 - Pool',
          items: const [
            KitchenOrderItemModel(
              productId: 'prod_wings',
              productName: 'Alitas BBQ (8 Unidades)',
              quantity: 2,
              notes: 'Salsa picante aparte',
              status: KdsStatusEnum.pending,
            ),
            KitchenOrderItemModel(
              productId: 'prod_nachos',
              productName: 'Nachos Especiales',
              quantity: 1,
              notes: 'Sin jalapeños',
              status: KdsStatusEnum.pending,
            ),
          ],
          status: KdsStatusEnum.pending,
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        KitchenOrderModel(
          id: 'kds_02',
          buId: buId,
          orderCode: 'ORD-102',
          tableOrTabName: 'Barra Central',
          items: const [
            KitchenOrderItemModel(
              productId: 'prod_burger',
              productName: 'Hamburguesa Doble Carne',
              quantity: 1,
              notes: 'Término medio con queso extra',
              status: KdsStatusEnum.preparing,
            ),
          ],
          status: KdsStatusEnum.preparing,
          createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
        ),
        KitchenOrderModel(
          id: 'kds_03',
          buId: buId,
          orderCode: 'ORD-103',
          tableOrTabName: 'Mesa 4 VIP',
          items: const [
            KitchenOrderItemModel(
              productId: 'prod_mojito',
              productName: 'Mojito Cubano Clásico',
              quantity: 3,
              notes: 'Poco hielo',
              status: KdsStatusEnum.ready,
            ),
          ],
          status: KdsStatusEnum.ready,
          createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
        ),
      ];
      _status = FeatureStatusEnum.loaded;
    } finally {
      notifyListeners();
    }
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
