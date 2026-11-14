import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/data/repositories/business_unit_repository.dart';
import 'package:logisto/data/repositories/organization_repository.dart';
import 'package:logisto/domain/models/business_unit_model.dart';
import 'package:logisto/domain/models/organization_model.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:logisto/presentation/onboarding/onboarding_provider.dart';
import 'package:logisto/presentation/onboarding/onboarding_wizard_screen.dart';
import '../../test_helpers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

class MockBusinessUnitRepository extends Mock
    implements BusinessUnitRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      OrganizationModel(
        id: 'org_dummy',
        legalName: 'Dummy Corp',
        commercialName: 'Dummy',
        taxId: 'J000',
        ownerUserId: 'owner_1',
        createdAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      BusinessUnitModel(
        id: 'bu_dummy',
        orgId: 'org_dummy',
        name: 'Dummy Branch',
        taxId: 'J000-1',
        phone: '555',
        address: 'Downtown',
        businessType: BusinessTypeEnum.billiard,
        isBilliardHall: true,
        createdAt: DateTime.now(),
      ),
    );
  });

  group('OnboardingProvider Unit Tests', () {
    late AppPreferences preferences;
    late OnboardingProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await AppPreferences.getInstance();
      provider = OnboardingProvider(preferences: preferences);
    });

    test('initial state starts on step 1 with defaults', () {
      expect(provider.currentStep, equals(1));
      expect(provider.status, equals(FeatureStatusEnum.idle));
      expect(provider.businessType, equals(BusinessTypeEnum.billiard));
      expect(provider.initialTables, equals(4));
      expect(provider.hourlyRate, equals(10.0));
      expect(provider.seedDemoData, isTrue);
    });

    test(
      'navigation advances and steps back correctly within bounds [1, 4]',
      () {
        provider.previousStep();
        expect(provider.currentStep, equals(1));

        provider.nextStep();
        expect(provider.currentStep, equals(2));

        provider.nextStep();
        expect(provider.currentStep, equals(3));

        provider.nextStep();
        expect(provider.currentStep, equals(4));

        provider.nextStep();
        expect(provider.currentStep, equals(4));

        provider.previousStep();
        expect(provider.currentStep, equals(3));
      },
    );

    test('state configuration methods update internal fields', () {
      provider.setOrgDetails('Global Logistics Ltd', 'J12345678');
      expect(provider.orgName, equals('Global Logistics Ltd'));
      expect(provider.taxId, equals('J12345678'));

      provider.setBranchDetails('Warehouse North', BusinessTypeEnum.retail);
      expect(provider.branchName, equals('Warehouse North'));
      expect(provider.businessType, equals(BusinessTypeEnum.retail));

      provider.setBilliardConfig(8, 25.0);
      expect(provider.initialTables, equals(8));
      expect(provider.hourlyRate, equals(25.0));

      provider.setSeedDemo(false);
      expect(provider.seedDemoData, isFalse);
    });

    test(
      'completeOnboarding saves identifiers to preferences and updates status',
      () async {
        final success = await provider.completeOnboarding();
        expect(success, isTrue);
        expect(provider.status, equals(FeatureStatusEnum.loaded));
        expect(preferences.isOnboardingCompleted(), isTrue);
        expect(preferences.getActiveOrgId(), isNotNull);
        expect(preferences.getActiveBuId(), isNotNull);
      },
    );

    test(
      'completeOnboarding persists organization and business unit to repositories',
      () async {
        final mockOrgRepo = MockOrganizationRepository();
        final mockBuRepo = MockBusinessUnitRepository();
        when(
          () => mockOrgRepo.saveOrganization(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockBuRepo.saveBusinessUnit(
            orgId: any(named: 'orgId'),
            businessUnit: any(named: 'businessUnit'),
          ),
        ).thenAnswer((_) async {});

        final repoProvider = OnboardingProvider(
          preferences: preferences,
          orgRepository: mockOrgRepo,
          buRepository: mockBuRepo,
        );
        repoProvider.setOrgDetails('Castillo Corp', 'J031');
        repoProvider.setBranchDetails(
          'Billiard Branch',
          BusinessTypeEnum.billiard,
        );

        final success = await repoProvider.completeOnboarding();

        expect(success, isTrue);
        verify(() => mockOrgRepo.saveOrganization(any())).called(1);
        verify(
          () => mockBuRepo.saveBusinessUnit(
            orgId: any(named: 'orgId'),
            businessUnit: any(named: 'businessUnit'),
          ),
        ).called(1);
      },
    );

    test(
      'buildOrganizationModel and buildBusinessUnitModel create valid domain instances',
      () {
        provider.setOrgDetails('Odynnix Corp', 'J99999');
        provider.setBranchDetails('HQ', BusinessTypeEnum.billiard);

        final org = provider.buildOrganizationModel();
        expect(org.legalName, equals('Odynnix Corp'));
        expect(org.taxId, equals('J99999'));

        final bu = provider.buildBusinessUnitModel();
        expect(bu.name, equals('HQ'));
        expect(bu.businessType, equals(BusinessTypeEnum.billiard));
        expect(bu.isBilliardHall, isTrue);
      },
    );
  });

  group('OnboardingWizardScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets(
      'renders wizard navbar, progress bar, and navigates steps to completion',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 720);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(
            locale: Locale('en'),
            home: OnboardingWizardScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Logisto Onboarding Wizard'), findsOneWidget);
        expect(
          find.text('Step 1: Enterprise Architecture Overview'),
          findsOneWidget,
        );
        expect(find.text('Next Step'), findsOneWidget);

        // Advance to Step 2
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();

        expect(find.text('Step 2: First Business Unit Branch'), findsOneWidget);

        // Advance to Step 3
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();

        expect(
          find.text('Step 3: Initial Station Infrastructure'),
          findsOneWidget,
        );

        // Advance to Step 4
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();

        expect(find.text('Step 4: Operational Readiness'), findsOneWidget);
        expect(find.text('Launch System'), findsOneWidget);

        // Launch system
        await tester.tap(find.text('Launch System'));
        await tester.pumpAndSettle();

        expect(
          locator<NavigationProvider>().currentRoute,
          equals(AppRoutes.dashboard),
        );
      },
    );
  });
}
