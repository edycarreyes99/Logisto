import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/account_status_enum.dart';
import 'package:logisto/core/enums/audit_action_enum.dart';
import 'package:logisto/core/enums/business_category_enum.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/core/enums/form_submission_status_enum.dart';
import 'package:logisto/core/enums/invoice_status_enum.dart';
import 'package:logisto/core/enums/kds_status_enum.dart';
import 'package:logisto/core/enums/language_enum.dart';
import 'package:logisto/core/enums/movement_type_enum.dart';
import 'package:logisto/core/enums/payment_method_enum.dart';
import 'package:logisto/core/enums/product_type_enum.dart';
import 'package:logisto/core/enums/shift_status_enum.dart';
import 'package:logisto/core/enums/table_status_enum.dart';
import 'package:logisto/core/enums/table_type_enum.dart';
import 'package:logisto/core/enums/theme_mode_enum.dart';
import 'package:logisto/core/enums/user_role_enum.dart';
import 'package:logisto/core/enums/validation_error_enum.dart';

void main() {
  group('Core Strongly-Typed Enums Tests', () {
    test('BusinessTypeEnum resolves correctly with fallback', () {
      expect(
        BusinessTypeEnum.fromStorageKey('billiard'),
        BusinessTypeEnum.billiard,
      );
      expect(
        BusinessTypeEnum.fromStorageKey('retail'),
        BusinessTypeEnum.retail,
      );
      expect(
        BusinessTypeEnum.fromStorageKey('pharmacy'),
        BusinessTypeEnum.pharmacy,
      );
      expect(
        BusinessTypeEnum.fromStorageKey('restaurant'),
        BusinessTypeEnum.restaurant,
      );
      expect(
        BusinessTypeEnum.fromStorageKey('unknown'),
        BusinessTypeEnum.general,
      );
      expect(BusinessTypeEnum.fromStorageKey(null), BusinessTypeEnum.general);
    });

    test('UserRoleEnum resolves correctly with fallback', () {
      expect(
        UserRoleEnum.fromStorageKey('SUPER_ADMIN_ORG'),
        UserRoleEnum.superAdminOrg,
      );
      expect(
        UserRoleEnum.fromStorageKey('ADMIN_BUSINESS_UNIT'),
        UserRoleEnum.adminBusinessUnit,
      );
      expect(
        UserRoleEnum.fromStorageKey('SUPERVISOR'),
        UserRoleEnum.supervisor,
      );
      expect(UserRoleEnum.fromStorageKey('CASHIER'), UserRoleEnum.cashier);
      expect(UserRoleEnum.fromStorageKey('WAITER'), UserRoleEnum.waiter);
      expect(
        UserRoleEnum.fromStorageKey('INVENTORY_MANAGER'),
        UserRoleEnum.inventoryManager,
      );
      expect(UserRoleEnum.fromStorageKey('KITCHEN'), UserRoleEnum.kitchen);
      expect(UserRoleEnum.fromStorageKey('invalid'), UserRoleEnum.cashier);
    });

    test('TableStatusEnum resolves correctly with fallback', () {
      expect(
        TableStatusEnum.fromStorageKey('available'),
        TableStatusEnum.available,
      );
      expect(
        TableStatusEnum.fromStorageKey('occupied'),
        TableStatusEnum.occupied,
      );
      expect(TableStatusEnum.fromStorageKey('paused'), TableStatusEnum.paused);
      expect(
        TableStatusEnum.fromStorageKey('billing'),
        TableStatusEnum.billing,
      );
      expect(TableStatusEnum.fromStorageKey(null), TableStatusEnum.available);
    });

    test('TableTypeEnum resolves correctly with fallback', () {
      expect(TableTypeEnum.fromStorageKey('pool'), TableTypeEnum.pool);
      expect(
        TableTypeEnum.fromStorageKey('carambola'),
        TableTypeEnum.carambola,
      );
      expect(TableTypeEnum.fromStorageKey('snooker'), TableTypeEnum.snooker);
      expect(TableTypeEnum.fromStorageKey('vip'), TableTypeEnum.vip);
      expect(TableTypeEnum.fromStorageKey(null), TableTypeEnum.pool);
    });

    test('AccountStatusEnum resolves correctly with fallback', () {
      expect(AccountStatusEnum.fromStorageKey('open'), AccountStatusEnum.open);
      expect(
        AccountStatusEnum.fromStorageKey('billing'),
        AccountStatusEnum.billing,
      );
      expect(
        AccountStatusEnum.fromStorageKey('closed'),
        AccountStatusEnum.closed,
      );
      expect(
        AccountStatusEnum.fromStorageKey('voided'),
        AccountStatusEnum.voided,
      );
      expect(AccountStatusEnum.fromStorageKey(null), AccountStatusEnum.open);
    });

    test('PaymentMethodEnum resolves correctly with fallback', () {
      expect(PaymentMethodEnum.fromStorageKey('cash'), PaymentMethodEnum.cash);
      expect(PaymentMethodEnum.fromStorageKey('card'), PaymentMethodEnum.card);
      expect(
        PaymentMethodEnum.fromStorageKey('customer_credit'),
        PaymentMethodEnum.customerCredit,
      );
      expect(
        PaymentMethodEnum.fromStorageKey('bank_transfer'),
        PaymentMethodEnum.bankTransfer,
      );
      expect(
        PaymentMethodEnum.fromStorageKey('mixed'),
        PaymentMethodEnum.mixed,
      );
      expect(PaymentMethodEnum.fromStorageKey(null), PaymentMethodEnum.cash);
    });

    test('InvoiceStatusEnum resolves correctly with fallback', () {
      expect(InvoiceStatusEnum.fromStorageKey('paid'), InvoiceStatusEnum.paid);
      expect(
        InvoiceStatusEnum.fromStorageKey('partially_paid_credit'),
        InvoiceStatusEnum.partiallyPaidCredit,
      );
      expect(
        InvoiceStatusEnum.fromStorageKey('cancelled'),
        InvoiceStatusEnum.cancelled,
      );
      expect(InvoiceStatusEnum.fromStorageKey(null), InvoiceStatusEnum.paid);
    });

    test('ProductTypeEnum resolves correctly with fallback', () {
      expect(
        ProductTypeEnum.fromStorageKey('standard'),
        ProductTypeEnum.standard,
      );
      expect(ProductTypeEnum.fromStorageKey('pack'), ProductTypeEnum.pack);
      expect(
        ProductTypeEnum.fromStorageKey('recipe_bom'),
        ProductTypeEnum.recipeBom,
      );
      expect(
        ProductTypeEnum.fromStorageKey('service'),
        ProductTypeEnum.service,
      );
      expect(ProductTypeEnum.fromStorageKey(null), ProductTypeEnum.standard);
    });

    test('ShiftStatusEnum and ShiftDiscrepancyEnum resolve correctly', () {
      expect(ShiftStatusEnum.fromStorageKey('open'), ShiftStatusEnum.open);
      expect(ShiftStatusEnum.fromStorageKey('closed'), ShiftStatusEnum.closed);
      expect(ShiftStatusEnum.fromStorageKey(null), ShiftStatusEnum.open);

      expect(
        ShiftDiscrepancyEnum.fromStorageKey('balanced'),
        ShiftDiscrepancyEnum.balanced,
      );
      expect(
        ShiftDiscrepancyEnum.fromStorageKey('shortage'),
        ShiftDiscrepancyEnum.shortage,
      );
      expect(
        ShiftDiscrepancyEnum.fromStorageKey('surplus'),
        ShiftDiscrepancyEnum.surplus,
      );
      expect(
        ShiftDiscrepancyEnum.fromStorageKey(null),
        ShiftDiscrepancyEnum.balanced,
      );
    });

    test('KdsStatusEnum and AuditActionEnum resolve correctly', () {
      expect(KdsStatusEnum.fromStorageKey('pending'), KdsStatusEnum.pending);
      expect(
        KdsStatusEnum.fromStorageKey('preparing'),
        KdsStatusEnum.preparing,
      );
      expect(KdsStatusEnum.fromStorageKey('ready'), KdsStatusEnum.ready);
      expect(KdsStatusEnum.fromStorageKey('served'), KdsStatusEnum.served);
      expect(KdsStatusEnum.fromStorageKey(null), KdsStatusEnum.pending);

      expect(
        AuditActionEnum.fromStorageKey('void_item'),
        AuditActionEnum.voidItem,
      );
      expect(
        AuditActionEnum.fromStorageKey('void_invoice'),
        AuditActionEnum.voidInvoice,
      );
      expect(
        AuditActionEnum.fromStorageKey('open_drawer_no_sale'),
        AuditActionEnum.openDrawer,
      );
      expect(AuditActionEnum.fromStorageKey(null), AuditActionEnum.openDrawer);
    });

    test('MovementTypeEnum resolves correctly', () {
      expect(
        MovementTypeEnum.fromStorageKey('purchase_receipt'),
        MovementTypeEnum.purchaseReceipt,
      );
      expect(
        MovementTypeEnum.fromStorageKey('sales_deduction'),
        MovementTypeEnum.salesDeduction,
      );
      expect(
        MovementTypeEnum.fromStorageKey('internal_transfer'),
        MovementTypeEnum.internalTransfer,
      );
      expect(
        MovementTypeEnum.fromStorageKey('waste_adjustment'),
        MovementTypeEnum.wasteAdjustment,
      );
      expect(
        MovementTypeEnum.fromStorageKey(null),
        MovementTypeEnum.salesDeduction,
      );
    });

    test(
      'ValidationErrorEnum, LanguageEnum and ThemeModeEnum resolve correctly',
      () {
        expect(
          ValidationErrorEnum.fromStorageKey('none'),
          ValidationErrorEnum.none,
        );
        expect(
          ValidationErrorEnum.fromStorageKey('empty'),
          ValidationErrorEnum.empty,
        );
        expect(
          ValidationErrorEnum.fromStorageKey('too_short'),
          ValidationErrorEnum.tooShort,
        );
        expect(
          ValidationErrorEnum.fromStorageKey(null),
          ValidationErrorEnum.none,
        );

        expect(LanguageEnum.fromCode('en'), LanguageEnum.en);
        expect(LanguageEnum.fromCode('es'), LanguageEnum.es);
        expect(LanguageEnum.fromCode('other'), LanguageEnum.es);

        expect(ThemeModeEnum.fromStorageKey('light'), ThemeModeEnum.light);
        expect(ThemeModeEnum.fromStorageKey('dark'), ThemeModeEnum.dark);
        expect(ThemeModeEnum.fromStorageKey('system'), ThemeModeEnum.system);
        expect(ThemeModeEnum.fromStorageKey(null), ThemeModeEnum.light);

        expect(
          FeatureStatusEnum.fromStorageKey('loading'),
          FeatureStatusEnum.loading,
        );
        expect(FeatureStatusEnum.fromStorageKey(null), FeatureStatusEnum.idle);

        expect(
          FormSubmissionStatusEnum.fromStorageKey('submitting'),
          FormSubmissionStatusEnum.submitting,
        );
        expect(
          FormSubmissionStatusEnum.fromStorageKey(null),
          FormSubmissionStatusEnum.idle,
        );

        expect(BusinessCategoryEnum.values.length, equals(62));
        expect(
          BusinessCategoryEnum.fromStorageKey('billar'),
          BusinessCategoryEnum.billar,
        );
        expect(
          BusinessCategoryEnum.fromStorageKey('reciclaje_y_chatarra'),
          BusinessCategoryEnum.reciclajeYChatarra,
        );
        expect(
          BusinessCategoryEnum.fromDisplayName('Restaurante o comida rápida'),
          BusinessCategoryEnum.restauranteOComidaRapida,
        );
        expect(
          BusinessCategoryEnum.fromStorageKey(null),
          BusinessCategoryEnum.minimercado,
        );
        expect(
          BusinessCategoryEnum.billar.defaultBusinessType,
          BusinessTypeEnum.billiard,
        );
        expect(
          BusinessCategoryEnum.restauranteOComidaRapida.defaultBusinessType,
          BusinessTypeEnum.restaurant,
        );
        expect(
          BusinessCategoryEnum.farmaciaYDrogueria.defaultBusinessType,
          BusinessTypeEnum.pharmacy,
        );
      },
    );
  });
}
