import '../../core/enums/audit_action_enum.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/movement_type_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../core/enums/product_type_enum.dart';
import '../../core/enums/shift_status_enum.dart';
import '../../core/enums/table_type_enum.dart';
import '../../core/enums/user_role_enum.dart';
import '../../l10n/app_localizations.dart';

/// Extension methods mapping strongly typed core domain enums
/// to bilingual localized human-facing presentation strings.
extension UserRoleLocalizationExtension on UserRoleEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      UserRoleEnum.superAdminOrg => l10n.roleSuperAdmin,
      UserRoleEnum.adminBusinessUnit => l10n.roleAdminBusinessUnit,
      UserRoleEnum.supervisor => l10n.roleSupervisor,
      UserRoleEnum.cashier => l10n.roleCashier,
      UserRoleEnum.waiter => l10n.roleWaiter,
      UserRoleEnum.inventoryManager => l10n.roleInventoryManager,
      UserRoleEnum.kitchen => l10n.roleKitchen,
    };
  }
}

extension BusinessTypeLocalizationExtension on BusinessTypeEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      BusinessTypeEnum.billiard => l10n.businessTypeBilliard,
      BusinessTypeEnum.retail => l10n.businessTypeRetail,
      BusinessTypeEnum.pharmacy => l10n.businessTypePharmacy,
      BusinessTypeEnum.restaurant => l10n.businessTypeRestaurant,
      BusinessTypeEnum.general => l10n.businessTypeGeneral,
    };
  }
}

extension ProductTypeLocalizationExtension on ProductTypeEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      ProductTypeEnum.standard => l10n.productTypeStandard,
      ProductTypeEnum.pack => l10n.productTypePack,
      ProductTypeEnum.recipeBom => l10n.productTypeRecipeBom,
      ProductTypeEnum.service => l10n.productTypeService,
    };
  }
}

extension AuditActionLocalizationExtension on AuditActionEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      AuditActionEnum.voidItem => l10n.auditActionVoidItem,
      AuditActionEnum.voidInvoice => l10n.auditActionVoidInvoice,
      AuditActionEnum.applyDiscount => l10n.auditActionApplyDiscount,
      AuditActionEnum.openDrawer => l10n.auditActionOpenDrawer,
      AuditActionEnum.rateChange => l10n.auditActionRateChange,
      AuditActionEnum.creditOverride => l10n.auditActionCreditOverride,
      AuditActionEnum.stockAdjustment => l10n.auditActionStockAdjustment,
      AuditActionEnum.closeShift => l10n.auditActionCloseShift,
    };
  }
}

extension MovementTypeLocalizationExtension on MovementTypeEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      MovementTypeEnum.purchaseReceipt => l10n.movementPurchaseReceipt,
      MovementTypeEnum.salesDeduction => l10n.movementSalesDeduction,
      MovementTypeEnum.internalTransfer => l10n.movementInternalTransfer,
      MovementTypeEnum.wasteAdjustment => l10n.movementWasteAdjustment,
      MovementTypeEnum.initialCount => l10n.movementInitialCount,
    };
  }
}

extension PaymentMethodLocalizationExtension on PaymentMethodEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      PaymentMethodEnum.cash => l10n.paymentMethodCash,
      PaymentMethodEnum.card => l10n.paymentMethodCard,
      PaymentMethodEnum.customerCredit => l10n.paymentMethodCustomerCredit,
      PaymentMethodEnum.bankTransfer => l10n.paymentMethodBankTransfer,
      PaymentMethodEnum.mixed => l10n.paymentMethodMixed,
    };
  }
}

extension ShiftDiscrepancyLocalizationExtension on ShiftDiscrepancyEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      ShiftDiscrepancyEnum.balanced => l10n.discrepancyBalanced,
      ShiftDiscrepancyEnum.shortage => l10n.discrepancyShortage,
      ShiftDiscrepancyEnum.surplus => l10n.discrepancySurplus,
    };
  }
}

extension TableTypeLocalizationExtension on TableTypeEnum {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      TableTypeEnum.pool => l10n.tableTypePool,
      TableTypeEnum.carambola => l10n.tableTypeCarambola,
      TableTypeEnum.snooker => l10n.tableTypeSnooker,
      TableTypeEnum.vip => l10n.tableTypeVip,
    };
  }
}
