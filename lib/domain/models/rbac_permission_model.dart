/// Pure domain model defining granular RBAC permissions.
class RbacPermissionModel {
  final String roleKey;
  final Set<String> macroModules;
  final Set<String> microPermissions;

  const RbacPermissionModel({
    required this.roleKey,
    this.macroModules = const {},
    this.microPermissions = const {},
  });

  /// Evaluates whether this role grants access to a macro screen/module.
  bool hasModuleAccess(String moduleKey) => macroModules.contains(moduleKey);

  /// Evaluates whether this role grants execution permission for a sensitive micro action.
  bool hasActionPermission(String actionKey) =>
      microPermissions.contains(actionKey);

  /// Pre-configured permission definitions for common roles.
  static const RbacPermissionModel superAdmin = RbacPermissionModel(
    roleKey: 'SUPER_ADMIN_ORG',
    macroModules: {
      'dashboard',
      'billiard',
      'open_accounts',
      'pos',
      'inventory',
      'customers',
      'users',
      'settings',
      'suppliers',
      'warehouses',
      'cash_shifts',
      'reports',
      'cxc',
      'purchases',
      'cxp',
      'kardex',
      'kds',
      'audit',
    },
    microPermissions: {
      'pos.apply_discount',
      'pos.void_invoice',
      'pos.open_drawer_no_sale',
      'pos.override_credit_limit',
      'pos.change_unit_price',
      'tabs.void_item',
      'tabs.transfer_table',
      'tabs.split_check',
      'billiards.override_rate',
      'billiards.zero_charge_grace',
      'cash.perform_blind_drop',
      'cash.view_expected_balance',
      'cash.close_shift',
      'inventory.adjust_stock',
      'inventory.view_cost_prices',
      'inventory.delete_product',
    },
  );

  static const RbacPermissionModel cashier = RbacPermissionModel(
    roleKey: 'CASHIER',
    macroModules: {
      'billiard',
      'open_accounts',
      'pos',
      'cash_shifts',
      'customers',
    },
    microPermissions: {'cash.perform_blind_drop', 'cash.close_shift'},
  );
}
