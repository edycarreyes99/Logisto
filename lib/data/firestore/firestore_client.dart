import 'package:cloud_firestore/cloud_firestore.dart';

/// Configures and exposes the [FirebaseFirestore] instance with multiplatform offline persistence.
/// Complies with RULE-DATA-001 (Offline-First Permanent Cache).
class FirestoreClient {
  final FirebaseFirestore? _customFirestore;

  FirestoreClient({FirebaseFirestore? firestore})
    : _customFirestore = firestore {
    try {
      instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (_) {
      // Ignored in unit test environments when default Firebase app is not initialized
    }
  }

  /// Underlying Firestore database instance.
  FirebaseFirestore get instance =>
      _customFirestore ?? FirebaseFirestore.instance;

  /// Root organizations collection reference.
  CollectionReference<Map<String, dynamic>> get organizations =>
      instance.collection('organizations');

  /// Scoped collection path for business units under an organization.
  CollectionReference<Map<String, dynamic>> businessUnits(String orgId) =>
      organizations.doc(orgId).collection('business_units');

  /// Scoped collection path for users under an organization.
  CollectionReference<Map<String, dynamic>> users(String orgId) =>
      organizations.doc(orgId).collection('users');

  /// Scoped collection path for customers under an organization.
  CollectionReference<Map<String, dynamic>> customers(String orgId) =>
      organizations.doc(orgId).collection('customers');

  /// Scoped collection path for suppliers under an organization.
  CollectionReference<Map<String, dynamic>> suppliers(String orgId) =>
      organizations.doc(orgId).collection('suppliers');

  /// Scoped collection path for master products under an organization.
  CollectionReference<Map<String, dynamic>> products(String orgId) =>
      organizations.doc(orgId).collection('products');

  /// Scoped collection path for audit logs under an organization.
  CollectionReference<Map<String, dynamic>> auditLogs(String orgId) =>
      organizations.doc(orgId).collection('audit_logs');

  /// Scoped collection path for custom RBAC roles under an organization.
  CollectionReference<Map<String, dynamic>> rbacRoles(String orgId) =>
      organizations.doc(orgId).collection('roles');

  /// Scoped collection path for tables in a business unit.
  CollectionReference<Map<String, dynamic>> tables(String orgId, String buId) =>
      businessUnits(orgId).doc(buId).collection('tables');

  /// Scoped collection path for open accounts in a business unit.
  CollectionReference<Map<String, dynamic>> openAccounts(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('open_accounts');

  /// Scoped collection path for sales invoices in a business unit.
  CollectionReference<Map<String, dynamic>> invoices(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('invoices');

  /// Scoped collection path for warehouses in a business unit.
  CollectionReference<Map<String, dynamic>> warehouses(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('warehouses');

  /// Scoped subcollection path for stock entries inside a warehouse.
  CollectionReference<Map<String, dynamic>> warehouseStock(
    String orgId,
    String buId,
    String warehouseId,
  ) => warehouses(orgId, buId).doc(warehouseId).collection('stock');

  /// Scoped collection path for cash shifts in a business unit.
  CollectionReference<Map<String, dynamic>> cashShifts(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('cash_shifts');

  /// Scoped collection path for accounts receivable in a business unit.
  CollectionReference<Map<String, dynamic>> accountsReceivable(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('accounts_receivable');

  /// Scoped collection path for purchase orders in a business unit.
  CollectionReference<Map<String, dynamic>> purchaseOrders(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('purchase_orders');

  /// Scoped collection path for accounts payable in a business unit.
  CollectionReference<Map<String, dynamic>> accountsPayable(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('accounts_payable');

  /// Scoped collection path for stock movements (kardex) in a business unit.
  CollectionReference<Map<String, dynamic>> stockMovements(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('stock_movements');

  /// Scoped collection path for kitchen orders (KDS) in a business unit.
  CollectionReference<Map<String, dynamic>> kitchenOrders(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('kitchen_orders');

  /// Scoped collection path for daily aggregated metrics in a business unit.
  CollectionReference<Map<String, dynamic>> aggregations(
    String orgId,
    String buId,
  ) => businessUnits(orgId).doc(buId).collection('aggregations');
}
