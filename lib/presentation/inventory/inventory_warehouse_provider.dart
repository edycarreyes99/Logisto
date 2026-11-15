import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/movement_type_enum.dart';
import '../../core/enums/warehouse_view_mode_enum.dart';
import '../../data/firestore/firestore_client.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/stock_movement_repository.dart';
import '../../data/repositories/warehouse_repository.dart';
import '../../domain/models/stock_movement_model.dart';
import '../../domain/models/warehouse_model.dart';

/// State provider for multi-warehouse physical stock levels,
/// low-stock reorder warnings, inter-warehouse transfers, shrinkage adjustments,
/// and permanent Kardex ledger auditing.
class InventoryWarehouseProvider extends ChangeNotifier {
  final WarehouseRepository warehouseRepository;
  final StockMovementRepository stockMovementRepository;
  final ProductRepository? productRepository;
  final FirestoreClient? client;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _activeOrgId;
  String? _activeBuId;
  List<WarehouseModel> _warehouses = [];
  WarehouseModel? _selectedWarehouse;
  WarehouseViewModeEnum _viewMode = WarehouseViewModeEnum.stock;

  List<StockMovementModel> _movements = [];
  List<Map<String, dynamic>> _stockItems = [];

  InventoryWarehouseProvider({
    required this.warehouseRepository,
    required this.stockMovementRepository,
    this.productRepository,
    this.client,
  });

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<WarehouseModel> get warehouses => List.unmodifiable(_warehouses);
  WarehouseModel? get selectedWarehouse => _selectedWarehouse;
  List<Map<String, dynamic>> get stockItems => List.unmodifiable(_stockItems);
  List<StockMovementModel> get movements => List.unmodifiable(_movements);
  WarehouseViewModeEnum get viewMode => _viewMode;

  void setViewMode(WarehouseViewModeEnum mode) {
    _viewMode = mode;
    notifyListeners();
  }

  Future<void> loadWarehouses({
    required String orgId,
    required String buId,
  }) async {
    _activeOrgId = orgId;
    _activeBuId = buId;
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await warehouseRepository.getWarehouses(
        orgId: orgId,
        buId: buId,
      );
      _warehouses = fetched;
      if (_warehouses.isNotEmpty) {
        _selectedWarehouse = _warehouses.first;
      }

      await _loadStockForSelectedWarehouse();
      await _loadMovements(orgId: orgId, buId: buId);

      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadStockForSelectedWarehouse() async {
    if (_activeOrgId == null ||
        _activeBuId == null ||
        _selectedWarehouse == null) {
      return;
    }

    final List<Map<String, dynamic>> items = [];
    if (productRepository != null) {
      final prods = await productRepository!.getProducts(_activeOrgId!);
      for (final p in prods) {
        double currentQty = 0.0;
        double minStock = 10.0;

        try {
          final stockModel = await warehouseRepository.getProductStock(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            warehouseId: _selectedWarehouse!.id,
            productId: p.id,
          );
          if (stockModel != null) {
            currentQty = stockModel.currentStock;
            minStock = stockModel.minimumStock;
          }
        } catch (_) {}

        items.add({
          'productId': p.id,
          'name': p.name,
          'sku': p.sku,
          'currentQuantity': currentQty,
          'reservedQuantity': 0.0,
          'minStock': minStock,
          'reorderPoint': minStock * 1.5,
          'isLowStock': currentQty <= minStock,
        });
      }
    }
    _stockItems = items;
  }

  Future<void> _loadMovements({
    required String orgId,
    required String buId,
  }) async {
    try {
      final fetched = await stockMovementRepository.getMovements(
        orgId: orgId,
        buId: buId,
      );
      _movements = fetched;
    } catch (_) {
      _movements = [];
    }
  }

  void selectWarehouse(WarehouseModel wh) {
    _selectedWarehouse = wh;
    _loadStockForSelectedWarehouse().then((_) => notifyListeners());
  }

  Future<void> saveWarehouse({
    required String orgId,
    required String buId,
    required WarehouseModel warehouse,
  }) async {
    try {
      await warehouseRepository.saveWarehouse(
        orgId: orgId,
        buId: buId,
        warehouse: warehouse,
      );
    } catch (_) {}

    final idx = _warehouses.indexWhere((w) => w.id == warehouse.id);
    if (idx != -1) {
      _warehouses[idx] = warehouse;
    } else {
      _warehouses = [..._warehouses, warehouse];
    }
    _selectedWarehouse ??= warehouse;
    notifyListeners();
  }

  Future<void> deleteWarehouse({
    required String orgId,
    required String buId,
    required String warehouseId,
  }) async {
    try {
      await warehouseRepository.deleteWarehouse(
        orgId: orgId,
        buId: buId,
        warehouseId: warehouseId,
      );
    } catch (_) {}

    _warehouses = _warehouses.where((w) => w.id != warehouseId).toList();
    _selectedWarehouse = _warehouses.isNotEmpty ? _warehouses.first : null;
    notifyListeners();
  }

  Future<void> transferStock({
    required String fromWhId,
    required String toWhId,
    required String productId,
    required double quantity,
  }) async {
    final idx = _stockItems.indexWhere((i) => i['productId'] == productId);
    if (idx != -1) {
      final current = _stockItems[idx]['currentQuantity'] as double;
      _stockItems[idx]['currentQuantity'] = current - quantity;
      _stockItems[idx]['isLowStock'] =
          (_stockItems[idx]['currentQuantity'] as double) <=
          (_stockItems[idx]['minStock'] as double);

      final movement = StockMovementModel(
        id: 'mov_${DateTime.now().millisecondsSinceEpoch}',
        buId: _selectedWarehouse?.buId ?? _activeBuId ?? 'bu_default',
        warehouseId: fromWhId,
        productId: productId,
        productName: _stockItems[idx]['name'] as String,
        movementType: MovementTypeEnum.internalTransfer,
        quantity: -quantity,
        unitCost: 1.10,
        totalCost: -(quantity * 1.10),
        referenceId: 'TRF-${DateTime.now().millisecondsSinceEpoch % 10000}',
        notes: 'Transfer from $fromWhId to $toWhId',
        timestamp: DateTime.now(),
      );
      _movements.insert(0, movement);

      if (_activeOrgId != null && _activeBuId != null) {
        try {
          await stockMovementRepository.recordMovement(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            movement: movement,
          );
        } catch (_) {}
      }

      notifyListeners();
    }
  }

  Future<void> adjustStock({
    required String productId,
    required double newQuantity,
    required String reason,
  }) async {
    final idx = _stockItems.indexWhere((i) => i['productId'] == productId);
    if (idx != -1) {
      final current = _stockItems[idx]['currentQuantity'] as double;
      final diff = newQuantity - current;
      _stockItems[idx]['currentQuantity'] = newQuantity;
      _stockItems[idx]['isLowStock'] =
          newQuantity <= (_stockItems[idx]['minStock'] as double);

      final movement = StockMovementModel(
        id: 'mov_${DateTime.now().millisecondsSinceEpoch}',
        buId: _activeBuId ?? _selectedWarehouse?.buId ?? 'bu_default',
        warehouseId: _selectedWarehouse?.id ?? 'wh_main',
        productId: productId,
        productName: _stockItems[idx]['name'] as String,
        movementType: diff < 0
            ? MovementTypeEnum.wasteAdjustment
            : MovementTypeEnum.initialCount,
        quantity: diff,
        unitCost: 1.10,
        totalCost: diff * 1.10,
        referenceId: 'ADJ-${DateTime.now().millisecondsSinceEpoch % 10000}',
        notes: reason,
        timestamp: DateTime.now(),
      );
      _movements.insert(0, movement);

      if (_activeOrgId != null && _activeBuId != null) {
        try {
          await stockMovementRepository.recordMovement(
            orgId: _activeOrgId!,
            buId: _activeBuId!,
            movement: movement,
          );
        } catch (_) {}
      }

      notifyListeners();
    }
  }
}
