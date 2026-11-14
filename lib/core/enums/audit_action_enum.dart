/// Strongly-typed sensitive operations tracked in immutable audit log trail.
enum AuditActionEnum {
  /// Item removed or voided from open order or tab.
  voidItem(storageKey: 'void_item'),

  /// Entire invoice voided or annulled.
  voidInvoice(storageKey: 'void_invoice'),

  /// Discretionary or manual price discount applied.
  applyDiscount(storageKey: 'apply_discount'),

  /// Cash drawer popped open without active sale transaction.
  openDrawer(storageKey: 'open_drawer_no_sale'),

  /// Hourly billiard table rental rate changed or overridden.
  rateChange(storageKey: 'rate_change'),

  /// Customer credit ceiling overridden by supervisor.
  creditOverride(storageKey: 'credit_override'),

  /// Inventory physical adjustment or waste shrinkage registered.
  stockAdjustment(storageKey: 'stock_adjustment'),

  /// Cash register blind drop closing finalized.
  closeShift(storageKey: 'close_shift');

  /// Storage key for database persistence.
  final String storageKey;

  const AuditActionEnum({required this.storageKey});

  /// Resolves [AuditActionEnum] from [storageKey] with fallback to [openDrawer].
  static AuditActionEnum fromStorageKey(String? key) {
    return AuditActionEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => AuditActionEnum.openDrawer,
    );
  }
}
