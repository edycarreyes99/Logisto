import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/domain/models/business_unit_model.dart';
import 'package:logisto/domain/models/organization_model.dart';
import 'package:logisto/presentation/context/business_context_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BusinessContextProvider State Tests', () {
    late AppPreferences preferences;
    late BusinessContextProvider provider;

    final testOrg = OrganizationModel(
      id: 'org_castillo',
      legalName: 'Inversiones Castillo Machado S.A.',
      commercialName: 'Castillo Machado',
      taxId: 'J0310000123456',
      ownerUserId: 'owner_1',
      createdAt: DateTime(2026, 11, 12),
    );

    final buBilliard = BusinessUnitModel(
      id: 'bu_billar',
      orgId: 'org_castillo',
      name: 'Billares Central',
      taxId: 'J0310000123456-1',
      phone: '8888',
      address: 'Central',
      businessType: BusinessTypeEnum.billiard,
      isBilliardHall: true,
      createdAt: DateTime(2026, 11, 12),
    );

    final buPharmacy = BusinessUnitModel(
      id: 'bu_farmacia',
      orgId: 'org_castillo',
      name: 'Farmacia Castillo',
      taxId: 'J0310000123456-2',
      phone: '7777',
      address: 'Norte',
      businessType: BusinessTypeEnum.pharmacy,
      isBilliardHall: false,
      createdAt: DateTime(2026, 11, 12),
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await AppPreferences.getInstance();
      provider = BusinessContextProvider(preferences: preferences);
    });

    test('initial state is idle with null context', () {
      expect(provider.status, FeatureStatusEnum.idle);
      expect(provider.activeOrganization, isNull);
      expect(provider.activeBusinessUnit, isNull);
      expect(provider.availableUnits, isEmpty);
    });

    test(
      'initializes context, auto-selects branch when single unit exists',
      () async {
        await provider.initializeContext(
          organization: testOrg,
          units: [buBilliard],
        );

        expect(provider.status, FeatureStatusEnum.loaded);
        expect(provider.activeOrganization?.id, 'org_castillo');
        expect(provider.activeBusinessUnit?.id, 'bu_billar');
        expect(provider.isBilliardActive, isTrue);
        expect(provider.isPharmacyActive, isFalse);

        expect(preferences.getActiveOrgId(), 'org_castillo');
        expect(preferences.getActiveBuId(), 'bu_billar');
      },
    );

    test(
      'leaves active branch null when multiple units exist without saved preference',
      () async {
        await provider.initializeContext(
          organization: testOrg,
          units: [buBilliard, buPharmacy],
        );

        expect(provider.status, FeatureStatusEnum.loaded);
        expect(provider.activeOrganization?.id, 'org_castillo');
        expect(provider.activeBusinessUnit, isNull);
        expect(preferences.getActiveBuId(), isNull);
      },
    );

    test('switches business unit and updates dynamic flags', () async {
      await provider.initializeContext(
        organization: testOrg,
        units: [buBilliard, buPharmacy],
      );

      await provider.switchBusinessUnit(buPharmacy);

      expect(provider.activeBusinessUnit?.id, 'bu_farmacia');
      expect(provider.isBilliardActive, isFalse);
      expect(provider.isPharmacyActive, isTrue);
      expect(preferences.getActiveBuId(), 'bu_farmacia');
    });

    test('clears context on logout and resets preferences', () async {
      await provider.initializeContext(
        organization: testOrg,
        units: [buBilliard],
      );

      expect(provider.activeOrganization, isNotNull);
      expect(preferences.getActiveOrgId(), 'org_castillo');

      await provider.clearContext();

      expect(provider.activeOrganization, isNull);
      expect(provider.activeBusinessUnit, isNull);
      expect(provider.availableUnits, isEmpty);
      expect(provider.status, FeatureStatusEnum.idle);
      expect(preferences.getActiveOrgId(), isNull);
      expect(preferences.getActiveBuId(), isNull);
    });
  });
}
