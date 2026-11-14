/// Strongly-typed user access role within organizations and business units.
enum UserRoleEnum {
  /// Super Administrator across the entire Organization tenant.
  superAdminOrg(storageKey: 'SUPER_ADMIN_ORG'),

  /// Business Unit / Branch Manager.
  adminBusinessUnit(storageKey: 'ADMIN_BUSINESS_UNIT'),

  /// Floor Supervisor authorized to perform overrides and approvals.
  supervisor(storageKey: 'SUPERVISOR'),

  /// Cashier operating sales terminal and cash drawer.
  cashier(storageKey: 'CASHIER'),

  /// Waiter / Server operating table orders and open tabs.
  waiter(storageKey: 'WAITER'),

  /// Inventory Manager in charge of warehouses and stock movements.
  inventoryManager(storageKey: 'INVENTORY_MANAGER'),

  /// Kitchen / Bar operator working on the KDS display.
  kitchen(storageKey: 'KITCHEN');

  /// Storage key for database persistence.
  final String storageKey;

  const UserRoleEnum({required this.storageKey});

  /// Resolves [UserRoleEnum] safely from [storageKey] with fallback to [cashier].
  static UserRoleEnum fromStorageKey(String? key) {
    return UserRoleEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => UserRoleEnum.cashier,
    );
  }
}
