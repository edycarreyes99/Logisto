import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/movement_type_enum.dart';
import '../../data/repositories/account_payable_repository.dart';
import '../../data/repositories/purchase_order_repository.dart';
import '../../data/repositories/stock_movement_repository.dart';
import '../../data/repositories/supplier_repository.dart';
import '../../domain/models/account_payable_model.dart';
import '../../domain/models/purchase_order_model.dart';
import '../../domain/models/stock_movement_model.dart';

/// State provider for inbound purchase orders, goods receipt verification,
/// and inventory cost updates.
class PurchaseOrderProvider extends ChangeNotifier {
  final PurchaseOrderRepository repository;
  final AccountPayableRepository? accountPayableRepository;
  final StockMovementRepository? stockMovementRepository;
  final SupplierRepository? supplierRepository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<PurchaseOrderModel> _orders = [];

  PurchaseOrderProvider({
    required this.repository,
    this.accountPayableRepository,
    this.stockMovementRepository,
    this.supplierRepository,
  });

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<PurchaseOrderModel> get orders => List.unmodifiable(_orders);

  Future<void> loadOrders({required String orgId, required String buId}) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      final fetched = await repository.getPurchaseOrders(
        orgId: orgId,
        buId: buId,
      );
      if (fetched.isEmpty) {
        _orders = [
          PurchaseOrderModel(
            id: 'po_01',
            buId: buId,
            supplierId: 'sup_01',
            supplierName: 'Compañía Cervecera Nacional',
            orderDate: DateTime.now().subtract(const Duration(days: 3)),
            expectedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
            items: const [
              PurchaseOrderItemModel(
                productId: 'prod_tona_01',
                productName: 'Cerveza Toña 350ml Botella',
                quantityOrdered: 240.0,
                quantityReceived: 0.0,
                unitCost: 1.00,
                totalCost: 240.00,
              ),
            ],
            totalAmount: 240.00,
            status: 'pending',
          ),
          PurchaseOrderModel(
            id: 'po_02',
            buId: buId,
            supplierId: 'sup_02',
            supplierName: 'Distribuidora Avícola El Granjero',
            orderDate: DateTime.now().subtract(const Duration(days: 7)),
            expectedDeliveryDate: DateTime.now().subtract(
              const Duration(days: 2),
            ),
            items: const [
              PurchaseOrderItemModel(
                productId: 'prod_wings_01',
                productName: 'Alitas BBQ Congeladas',
                quantityOrdered: 50.0,
                quantityReceived: 50.0,
                unitCost: 3.50,
                totalCost: 175.00,
              ),
            ],
            totalAmount: 175.00,
            status: 'received',
          ),
        ];
      } else {
        _orders = fetched;
      }
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _orders = [
        PurchaseOrderModel(
          id: 'po_01',
          buId: buId,
          supplierId: 'sup_01',
          supplierName: 'Compañía Cervecera Nacional',
          orderDate: DateTime.now().subtract(const Duration(days: 3)),
          expectedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
          items: const [
            PurchaseOrderItemModel(
              productId: 'prod_tona_01',
              productName: 'Cerveza Toña 350ml Botella',
              quantityOrdered: 240.0,
              quantityReceived: 0.0,
              unitCost: 1.00,
              totalCost: 240.00,
            ),
          ],
          totalAmount: 240.00,
          status: 'pending',
        ),
        PurchaseOrderModel(
          id: 'po_02',
          buId: buId,
          supplierId: 'sup_02',
          supplierName: 'Distribuidora Avícola El Granjero',
          orderDate: DateTime.now().subtract(const Duration(days: 7)),
          expectedDeliveryDate: DateTime.now().subtract(
            const Duration(days: 2),
          ),
          items: const [
            PurchaseOrderItemModel(
              productId: 'prod_wings_01',
              productName: 'Alitas BBQ Congeladas',
              quantityOrdered: 50.0,
              quantityReceived: 50.0,
              unitCost: 3.50,
              totalCost: 175.00,
            ),
          ],
          totalAmount: 175.00,
          status: 'received',
        ),
      ];
      _status = FeatureStatusEnum.loaded;
    } finally {
      notifyListeners();
    }
  }

  Future<void> createOrder(PurchaseOrderModel order) async {
    _orders = [order, ..._orders];
    if (_activeOrgId != null && _activeBuId != null) {
      try {
        await repository.savePurchaseOrder(
          orgId: _activeOrgId!,
          buId: _activeBuId!,
          order: order,
        );
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> receiveGoods(String orderId) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final current = _orders[idx];
      final updated = PurchaseOrderModel(
        id: current.id,
        buId: current.buId,
        supplierId: current.supplierId,
        supplierName: current.supplierName,
        orderDate: current.orderDate,
        expectedDeliveryDate: current.expectedDeliveryDate,
        items: current.items
            .map(
              (item) => PurchaseOrderItemModel(
                productId: item.productId,
                productName: item.productName,
                quantityOrdered: item.quantityOrdered,
                quantityReceived: item.quantityOrdered,
                unitCost: item.unitCost,
                totalCost: item.totalCost,
              ),
            )
            .toList(),
        totalAmount: current.totalAmount,
        status: 'received',
      );
      _orders[idx] = updated;

      if (_activeOrgId != null && _activeBuId != null) {
        try {
          await repository.savePurchaseOrder(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            order: updated,
          );

          // 1. Generate Account Payable to supplier (Module 17 & 18)
          if (accountPayableRepository != null) {
            final ap = AccountPayableModel(
              id: 'cxp_${DateTime.now().millisecondsSinceEpoch}',
              buId: _activeBuId!,
              supplierId: current.supplierId,
              supplierName: current.supplierName,
              invoiceNumber: 'PO-INV-${current.id}',
              amount: current.totalAmount,
              paidAmount: 0.0,
              dueDate: DateTime.now().add(const Duration(days: 30)),
              createdAt: DateTime.now(),
            );
            await accountPayableRepository!.saveAccountPayable(
              orgId: _activeOrgId!,
              buId: _activeBuId!,
              ap: ap,
            );
          }

          // 2. Synchronize supplier payable balance (Module 12 & 18)
          if (supplierRepository != null) {
            try {
              final sup = await supplierRepository!.getSupplierById(
                orgId: _activeOrgId!,
                supplierId: current.supplierId,
              );
              if (sup != null) {
                await supplierRepository!.saveSupplier(
                  orgId: _activeOrgId!,
                  supplier: sup.copyWith(
                    currentPayableBalance:
                        sup.currentPayableBalance + current.totalAmount,
                  ),
                );
              }
            } catch (_) {}
          }

          // 3. Inbound stock movement to Kardex (Module 17 & 19)
          if (stockMovementRepository != null) {
            for (final item in updated.items) {
              await stockMovementRepository!.recordMovement(
                orgId: _activeOrgId!,
                buId: _activeBuId!,
                movement: StockMovementModel(
                  id: 'mov_${DateTime.now().millisecondsSinceEpoch}_${item.productId}',
                  buId: _activeBuId!,
                  warehouseId: 'wh_main',
                  productId: item.productId,
                  productName: item.productName,
                  movementType: MovementTypeEnum.purchaseReceipt,
                  quantity: item.quantityReceived,
                  unitCost: item.unitCost,
                  totalCost: item.totalCost,
                  referenceId: 'PO-${current.id}',
                  notes: 'Goods Receipt from ${current.supplierName}',
                  timestamp: DateTime.now(),
                ),
              );
            }
          }
        } catch (_) {}
      }

      notifyListeners();
    }
  }
}
