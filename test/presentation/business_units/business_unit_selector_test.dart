import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/data/repositories/business_unit_repository.dart';
import 'package:logisto/domain/models/business_unit_model.dart';
import 'package:logisto/domain/models/organization_model.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/business_units/business_unit_selector_provider.dart';
import 'package:logisto/presentation/business_units/business_unit_selector_screen.dart';
import 'package:logisto/presentation/context/business_context_provider.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../test_helpers.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockBusinessUnitRepository extends Mock
    implements BusinessUnitRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testOrg = OrganizationModel(
    id: 'org_test',
    legalName: 'Test Corp',
    commercialName: 'Test Commercial',
    taxId: 'J12345678',
    ownerUserId: 'user_1',
    createdAt: DateTime(2026, 11, 12),
  );

  final testBu1 = BusinessUnitModel(
    id: 'bu_1',
    orgId: 'org_test',
    name: 'Downtown HQ',
    taxId: 'J12345678-1',
    phone: '555-0101',
    address: 'Central Ave',
    businessType: BusinessTypeEnum.billiard,
    isBilliardHall: true,
    createdAt: DateTime(2026, 11, 12),
  );

  final testBu2 = BusinessUnitModel(
    id: 'bu_2',
    orgId: 'org_test',
    name: 'East Branch',
    taxId: 'J12345678-2',
    phone: '555-0102',
    address: 'East St',
    businessType: BusinessTypeEnum.retail,
    isBilliardHall: false,
    createdAt: DateTime(2026, 11, 12),
  );

  setUpAll(() {
    registerFallbackValue(testBu1);
  });

  group('BusinessUnitSelectorProvider Unit Tests', () {
    late MockBusinessUnitRepository mockRepo;
    late BusinessContextProvider contextProvider;
    late AppPreferences preferences;
    late BusinessUnitSelectorProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await AppPreferences.getInstance();
      contextProvider = BusinessContextProvider(preferences: preferences);
      mockRepo = MockBusinessUnitRepository();
      provider = BusinessUnitSelectorProvider(
        repository: mockRepo,
        contextProvider: contextProvider,
      );
    });

    test('loadBusinessUnits populates units from repository', () async {
      when(
        () => mockRepo.getBusinessUnits('org_test'),
      ).thenAnswer((_) async => [testBu1, testBu2]);

      await provider.loadBusinessUnits('org_test');

      expect(provider.status, equals(FeatureStatusEnum.loaded));
      expect(provider.units.length, equals(2));
      expect(provider.units.first.name, equals('Downtown HQ'));
    });

    test(
      'loadBusinessUnits returns empty list when repository returns empty',
      () async {
        when(
          () => mockRepo.getBusinessUnits('org_test'),
        ).thenAnswer((_) async => []);

        await provider.loadBusinessUnits('org_test');

        expect(provider.status, equals(FeatureStatusEnum.loaded));
        expect(provider.units.isEmpty, isTrue);
      },
    );

    test(
      'selectUnit updates active business unit in BusinessContextProvider',
      () async {
        await contextProvider.initializeContext(
          organization: testOrg,
          units: [testBu1, testBu2],
        );

        await provider.selectUnit(testBu2);
        expect(contextProvider.activeBusinessUnit?.id, equals('bu_2'));
      },
    );

    test('addUnit persists new business unit and updates local list', () async {
      when(
        () => mockRepo.saveBusinessUnit(
          orgId: any(named: 'orgId'),
          businessUnit: any(named: 'businessUnit'),
        ),
      ).thenAnswer((_) async => 'bu_new');

      await provider.addUnit(
        orgId: 'org_test',
        name: 'West Express',
        type: BusinessTypeEnum.pharmacy,
        address: 'West Way 10',
      );

      expect(provider.units.length, equals(1));
      expect(provider.units.first.name, equals('West Express'));
      expect(
        provider.units.first.businessType,
        equals(BusinessTypeEnum.pharmacy),
      );
    });
  });

  group('BusinessUnitSelectorScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets('renders business units grid and selects a branch', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: BusinessUnitSelectorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select Operating Business Unit'), findsOneWidget);
      expect(find.text('Add Branch'), findsOneWidget);
      expect(find.text('Billares Central'), findsOneWidget);
      expect(find.text('Tienda & Distribuidora Norte'), findsOneWidget);

      // Select first branch
      final selectButtons = find.text('Select Branch');
      expect(selectButtons, findsWidgets);
      await tester.tap(selectButtons.first);
      await tester.pumpAndSettle();

      expect(
        locator<NavigationProvider>().currentRoute,
        equals(AppRoutes.dashboard),
      );
    });

    testWidgets('opens Add Branch modal and closes on Cancel', (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: BusinessUnitSelectorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Branch'));
      await tester.pumpAndSettle();

      expect(find.text('Register New Branch'), findsOneWidget);
      expect(find.text('Create Branch'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Register New Branch'), findsNothing);
    });

    testWidgets('renders clean empty state with button to create first branch when units empty', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Set active organization to empty org so provider loads zero units
      final contextProvider = locator<BusinessContextProvider>();
      await contextProvider.initializeContext(
        organization: testOrg,
        units: [],
      );

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('es'),
          home: BusinessUnitSelectorScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No hay sucursales disponibles'), findsOneWidget);
      expect(find.text('Aún no tienes sucursales asignadas. Crea tu primera sucursal para comenzar.'), findsOneWidget);
      expect(find.text('Crear Primera Sucursal'), findsOneWidget);
    });
  });
}
