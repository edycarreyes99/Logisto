import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/business_type_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/core/enums/kds_status_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/repositories/kitchen_order_repository.dart';
import 'package:logisto/domain/models/business_unit_model.dart';
import 'package:logisto/domain/models/kitchen_order_model.dart';
import 'package:logisto/domain/models/organization_model.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/context/business_context_provider.dart';
import 'package:logisto/presentation/kitchen/kitchen_display_screen.dart';
import 'package:logisto/presentation/kitchen/kitchen_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockKitchenOrderRepository extends Mock
    implements KitchenOrderRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(KdsStatusEnum.pending);
  });

  final dummyOrder = KitchenOrderModel(
    id: 'kds_test',
    buId: 'bu_test',
    orderCode: 'ORD-999',
    tableOrTabName: 'Mesa 1',
    items: const [
      KitchenOrderItemModel(
        productId: 'prod_wings',
        productName: 'Wings',
        quantity: 2,
        notes: 'Extra crispy',
        status: KdsStatusEnum.pending,
      ),
    ],
    status: KdsStatusEnum.pending,
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  );

  group('KitchenProvider Unit Tests', () {
    late MockKitchenOrderRepository mockRepo;
    late KitchenProvider provider;

    setUp(() {
      mockRepo = MockKitchenOrderRepository();
      provider = KitchenProvider(repository: mockRepo);
    });

    test('loadOrders populates active kitchen tickets', () async {
      when(
        () => mockRepo.getActiveOrders(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyOrder]);

      await provider.loadOrders(orgId: 'org_1', buId: 'bu_1');

      expect(provider.status, equals(FeatureStatusEnum.loaded));
      expect(provider.filteredOrders.length, equals(1));
      expect(provider.filteredOrders.first.orderCode, equals('ORD-999'));
    });

    test(
      'advanceStatus progresses order from pending -> preparing -> ready -> served',
      () async {
        when(
          () => mockRepo.getActiveOrders(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [dummyOrder]);

        await provider.loadOrders(orgId: 'org_1', buId: 'bu_1');

        // pending -> preparing
        await provider.advanceStatus(dummyOrder);
        expect(
          provider.filteredOrders.first.status,
          equals(KdsStatusEnum.preparing),
        );

        // preparing -> ready
        await provider.advanceStatus(provider.filteredOrders.first);
        expect(
          provider.filteredOrders.first.status,
          equals(KdsStatusEnum.ready),
        );

        // ready -> served
        await provider.advanceStatus(provider.filteredOrders.first);
        expect(
          provider.filteredOrders.first.status,
          equals(KdsStatusEnum.served),
        );
      },
    );

    test('setFilterStatus filters queue by KdsStatusEnum', () async {
      when(
        () => mockRepo.getActiveOrders(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyOrder]);

      await provider.loadOrders(orgId: 'org_1', buId: 'bu_1');

      provider.setFilterStatus(KdsStatusEnum.ready);
      expect(provider.filteredOrders, isEmpty);

      provider.setFilterStatus(KdsStatusEnum.pending);
      expect(provider.filteredOrders.length, equals(1));

      provider.setFilterStatus(null);
      expect(provider.filteredOrders.length, equals(1));
    });
  });

  group('KitchenDisplayScreen Widget Tests', () {
    late MockFirestoreClient mockFirestoreClient;
    late MockKitchenOrderRepository mockRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockFirestoreClient = MockFirestoreClient();
      await setupLocator(firestoreClient: mockFirestoreClient, reset: true);

      final kdsOrders = [
        KitchenOrderModel(
          id: 'kds_01',
          buId: 'bu_test',
          orderCode: 'ORD-101',
          tableOrTabName: 'Mesa 2 - Pool',
          items: const [
            KitchenOrderItemModel(
              productId: 'prod_1',
              productName: 'Nachos Mixtos',
              quantity: 1,
              status: KdsStatusEnum.pending,
            ),
          ],
          status: KdsStatusEnum.pending,
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        KitchenOrderModel(
          id: 'kds_02',
          buId: 'bu_test',
          orderCode: 'ORD-102',
          tableOrTabName: 'Barra Central',
          items: const [
            KitchenOrderItemModel(
              productId: 'prod_2',
              productName: 'Cerveza Toña',
              quantity: 2,
              status: KdsStatusEnum.preparing,
            ),
          ],
          status: KdsStatusEnum.preparing,
          createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
        ),
        KitchenOrderModel(
          id: 'kds_03',
          buId: 'bu_test',
          orderCode: 'ORD-103',
          tableOrTabName: 'Mesa 4 VIP',
          items: const [
            KitchenOrderItemModel(
              productId: 'prod_3',
              productName: 'Alitas BBQ 12pcs',
              quantity: 1,
              status: KdsStatusEnum.ready,
            ),
          ],
          status: KdsStatusEnum.ready,
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ];

      mockRepo = MockKitchenOrderRepository();
      when(() => mockRepo.watchActiveOrders(orgId: 'org_test', buId: 'bu_test'))
          .thenAnswer((_) => Stream.value(kdsOrders));
      when(() => mockRepo.getActiveOrders(orgId: 'org_test', buId: 'bu_test'))
          .thenAnswer((_) async => kdsOrders);
      when(() => mockRepo.updateOrderStatus(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            orderId: any(named: 'orderId'),
            status: any(named: 'status'),
          )).thenAnswer((_) async {});

      locator.unregister<KitchenOrderRepository>();
      locator.registerSingleton<KitchenOrderRepository>(mockRepo);
      locator.unregister<KitchenProvider>();
      locator.registerSingleton<KitchenProvider>(
        KitchenProvider(repository: mockRepo),
      );

      final contextProvider = locator<BusinessContextProvider>();
      await contextProvider.initializeContext(
        organization: OrganizationModel(
          id: 'org_test',
          legalName: 'Test Org',
          commercialName: 'Test Org',
          taxId: 'J12345678',
          ownerUserId: 'user_01',
          createdAt: DateTime(2025, 1, 1),
        ),
        units: [
          BusinessUnitModel(
            id: 'bu_test',
            orgId: 'org_test',
            name: 'Central Branch',
            taxId: 'J12345678',
            phone: '555-0100',
            address: 'Managua',
            businessType: BusinessTypeEnum.billiard,
            isBilliardHall: true,
            createdAt: DateTime(2025, 1, 1),
          ),
        ],
      );
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets('renders KDS ticket cards and advances order status', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(
          locale: Locale('en'),
          home: KitchenDisplayScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      expect(find.text('Kitchen & Bar Display System (KDS)'), findsOneWidget);

      // Verify orders exist
      expect(find.text('ORD-101 • Mesa 2 - Pool'), findsOneWidget);
      expect(find.text('ORD-102 • Barra Central'), findsOneWidget);
      expect(find.text('ORD-103 • Mesa 4 VIP'), findsOneWidget);

      // Tap 'Start Preparation' on pending ticket ORD-101
      final startPrepButtons = find.text('Start Preparation');
      expect(startPrepButtons, findsWidgets);
      await tester.tap(startPrepButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Mark Ready'), findsWidgets);
    });
  });
}
