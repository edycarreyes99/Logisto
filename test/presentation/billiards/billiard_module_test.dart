import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/account_origin_type_enum.dart';
import 'package:logisto/core/enums/account_status_enum.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/core/enums/table_status_enum.dart';
import 'package:logisto/core/enums/table_type_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/repositories/billiard_table_repository.dart';
import 'package:logisto/data/repositories/open_account_repository.dart';
import 'package:logisto/domain/models/billiard_table_model.dart';
import 'package:logisto/domain/models/open_account_model.dart';
import 'package:logisto/domain/services/billiard_rate_calculator.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/billiards/billiard_floor_plan_screen.dart';
import 'package:logisto/presentation/billiards/billiard_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../test_helpers.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockBilliardTableRepository extends Mock
    implements BilliardTableRepository {}

class MockOpenAccountRepository extends Mock implements OpenAccountRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      BilliardTableModel(
        id: 'tbl_fallback',
        tableNumber: 99,
        name: 'Fallback Table',
        tableType: TableTypeEnum.pool,
        hourlyRate: 10.0,
        minimumMinutes: 15,
        graceMinutes: 3,
        status: TableStatusEnum.available,
      ),
    );
    registerFallbackValue(
      OpenAccountModel(
        id: 'tab_dummy',
        code: 'TAB-1',
        originType: AccountOriginTypeEnum.table,
        customerDisplayName: 'Customer 1',
        status: AccountStatusEnum.open,
        totalAmount: 0.0,
        openedAt: DateTime.now(),
      ),
    );
  });

  final dummyTable1 = BilliardTableModel(
    id: 'tbl_1',
    tableNumber: 1,
    name: 'Table 1 - Pool Brunswick',
    tableType: TableTypeEnum.pool,
    hourlyRate: 10.0,
    minimumMinutes: 15,
    graceMinutes: 3,
    status: TableStatusEnum.available,
  );

  final dummyTable2 = BilliardTableModel(
    id: 'tbl_2',
    tableNumber: 2,
    name: 'Table 2 - Carom Master',
    tableType: TableTypeEnum.carambola,
    hourlyRate: 12.0,
    minimumMinutes: 15,
    graceMinutes: 3,
    status: TableStatusEnum.available,
  );

  group('BilliardProvider Unit Tests', () {
    late MockBilliardTableRepository mockRepo;
    late MockOpenAccountRepository mockOpenAccountRepo;
    late BilliardRateCalculator rateCalculator;
    late BilliardProvider provider;

    setUp(() {
      mockRepo = MockBilliardTableRepository();
      mockOpenAccountRepo = MockOpenAccountRepository();
      rateCalculator = const BilliardRateCalculator();
      provider = BilliardProvider(
        repository: mockRepo,
        rateCalculator: rateCalculator,
        openAccountRepository: mockOpenAccountRepo,
      );
    });

    test('loadTables fetches tables from repository', () async {
      when(
        () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyTable1, dummyTable2]);

      await provider.loadTables(orgId: 'org_1', buId: 'bu_1');

      expect(provider.status, equals(FeatureStatusEnum.loaded));
      expect(provider.tables.length, equals(2));
      expect(provider.tables.first.name, equals('Table 1 - Pool Brunswick'));
    });

    test('startSession activates table and sets status to occupied', () async {
      when(
        () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyTable1, dummyTable2]);

      await provider.loadTables(orgId: 'org_1', buId: 'bu_1');

      await provider.startSession(tableId: 'tbl_1', customerName: 'Alex Ramos');

      final table = provider.tables.firstWhere((t) => t.id == 'tbl_1');
      expect(table.status, equals(TableStatusEnum.occupied));
      expect(table.currentSession, isNotNull);
      expect(table.currentSession?.customerName, equals('Alex Ramos'));
    });

    test(
      'pauseSession and resumeSession update table status properly',
      () async {
        when(
          () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [dummyTable1]);

        await provider.loadTables(orgId: 'org_1', buId: 'bu_1');
        await provider.startSession(tableId: 'tbl_1', customerName: 'Player 1');

        await provider.pauseSession('tbl_1');
        expect(provider.tables.first.status, equals(TableStatusEnum.paused));
        expect(provider.tables.first.currentSession?.isPaused, isTrue);

        await provider.resumeSession('tbl_1');
        expect(provider.tables.first.status, equals(TableStatusEnum.occupied));
        expect(provider.tables.first.currentSession?.isPaused, isFalse);
      },
    );

    test('transferTable shifts active session between tables', () async {
      when(
        () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyTable1, dummyTable2]);

      await provider.loadTables(orgId: 'org_1', buId: 'bu_1');
      await provider.startSession(tableId: 'tbl_1', customerName: 'Player 1');

      await provider.transferTable(fromTableId: 'tbl_1', toTableId: 'tbl_2');

      final table1 = provider.tables.firstWhere((t) => t.id == 'tbl_1');
      final table2 = provider.tables.firstWhere((t) => t.id == 'tbl_2');

      expect(table1.status, equals(TableStatusEnum.available));
      expect(table1.currentSession, isNull);

      expect(table2.status, equals(TableStatusEnum.occupied));
      expect(table2.currentSession?.customerName, equals('Player 1'));
    });

    test(
      'transferTable does NOT overwrite an occupied destination table',
      () async {
        when(
          () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [dummyTable1, dummyTable2]);

        await provider.loadTables(orgId: 'org_1', buId: 'bu_1');
        await provider.startSession(tableId: 'tbl_1', customerName: 'Player 1');
        await provider.startSession(tableId: 'tbl_2', customerName: 'Player 2');

        // Attempt transfer to already occupied tbl_2
        await provider.transferTable(fromTableId: 'tbl_1', toTableId: 'tbl_2');

        final table1 = provider.tables.firstWhere((t) => t.id == 'tbl_1');
        final table2 = provider.tables.firstWhere((t) => t.id == 'tbl_2');

        // Table 1 must still be occupied by Player 1
        expect(table1.status, equals(TableStatusEnum.occupied));
        expect(table1.currentSession?.customerName, equals('Player 1'));
        // Table 2 must still be occupied by Player 2
        expect(table2.status, equals(TableStatusEnum.occupied));
        expect(table2.currentSession?.customerName, equals('Player 2'));
      },
    );

    test(
      'stopSession with accrued charge saves charge to OpenAccountRepository',
      () async {
        final tableWithSession = BilliardTableModel(
          id: 'tbl_1',
          tableNumber: 1,
          name: 'Table 1 - Pool Brunswick',
          tableType: TableTypeEnum.pool,
          hourlyRate: 10.0,
          minimumMinutes: 15,
          graceMinutes: 3,
          status: TableStatusEnum.occupied,
          currentSession: BilliardSessionModel(
            sessionId: 'ses_1',
            customerName: 'Player 1',
            startTime: DateTime.now().subtract(const Duration(minutes: 45)),
            accumulatedSeconds: 2700,
          ),
        );

        when(
          () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [tableWithSession]);
        when(
          () => mockRepo.saveTable(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            table: any(named: 'table'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => mockOpenAccountRepo.saveAccount(
            orgId: any(named: 'orgId'),
            buId: any(named: 'buId'),
            account: any(named: 'account'),
          ),
        ).thenAnswer((_) async {});

        await provider.loadTables(orgId: 'org_1', buId: 'bu_1');
        await provider.stopSession('tbl_1');

        expect(provider.tables.first.status, equals(TableStatusEnum.available));
        expect(provider.tables.first.currentSession, isNull);
        verify(
          () => mockOpenAccountRepo.saveAccount(
            orgId: 'org_1',
            buId: 'bu_1',
            account: any(named: 'account'),
          ),
        ).called(1);
      },
    );

    test('stopSession resets table to available', () async {
      when(
        () => mockRepo.getTables(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyTable1]);

      await provider.loadTables(orgId: 'org_1', buId: 'bu_1');
      await provider.startSession(tableId: 'tbl_1', customerName: 'Player 1');

      await provider.stopSession('tbl_1');
      expect(provider.tables.first.status, equals(TableStatusEnum.available));
      expect(provider.tables.first.currentSession, isNull);
    });
  });

  group('BilliardFloorPlanScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets('renders billiard table cards and opens check-in modal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: BilliardFloorPlanScreen()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Billiard Stations & Floor Plan'), findsOneWidget);

      // Verify table cards
      expect(find.text('Mesa 1 - Pool Brunswick'), findsOneWidget);
      expect(find.text('Mesa 2 - Pool Diamante'), findsOneWidget);

      // Tap Start Table on Mesa 1
      final startButtons = find.text('Start Table');
      expect(startButtons, findsWidgets);
      await tester.tap(startButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Start Mesa 1 - Pool Brunswick'), findsOneWidget);
      expect(find.text('Start Session'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Start Mesa 1 - Pool Brunswick'), findsNothing);
    });
  });
}
