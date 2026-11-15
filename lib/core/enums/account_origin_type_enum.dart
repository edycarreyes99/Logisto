import '../../l10n/app_localizations.dart';

/// Strongly-typed origin category for open accounts and customer tabs.
enum AccountOriginTypeEnum {
  /// Account attached to a physical billiard or dining table.
  table(storageKey: 'table'),

  /// Direct bar or counter walk-up tab.
  counter(storageKey: 'counter'),

  /// Registered customer tab with dedicated account receivable line.
  customer(storageKey: 'customer'),

  /// Ad-hoc free-form customer alias tab.
  freeName(storageKey: 'free_name');

  /// Storage key for database persistence.
  final String storageKey;

  const AccountOriginTypeEnum({required this.storageKey});

  /// Resolves [AccountOriginTypeEnum] from [storageKey] with fallback to [table].
  static AccountOriginTypeEnum fromStorageKey(String? key) {
    return AccountOriginTypeEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => AccountOriginTypeEnum.table,
    );
  }

  /// Returns localized user-facing name for this origin type.
  String localizedTitle(AppLocalizations l10n) {
    switch (this) {
      case AccountOriginTypeEnum.table:
        return l10n.originTypeTable;
      case AccountOriginTypeEnum.counter:
        return l10n.originTypeCounter;
      case AccountOriginTypeEnum.customer:
        return l10n.originTypeCustomer;
      case AccountOriginTypeEnum.freeName:
        return l10n.originTypeFreeName;
    }
  }
}
