import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/core/enums/shift_status_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/repositories/cash_shift_repository.dart';
import 'package:logisto/domain/models/cash_shift_model.dart';
import 'package:logisto/domain/services/cash_shift_calculator.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/cash/cash_shift_provider.dart';
import 'package:logisto/presentation/cash/cash_shift_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../test_helpers.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

class MockCashShiftRepository extends Mock implements CashShiftRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final dummyShift = CashShiftModel(
    id: 'shift_active',
    buId: 'bu_test',
    cashRegisterNumber: 1,
    cashierUserId: 'usr_cashier',
    openedAt: DateTime.now().subtract(const Duration(hours: 3)),
    openingBalance: 100.0,
    cashSales: 400.0,
    expectedCashBalance: 500.0,
    status: ShiftStatusEnum.open,
  );

  group('CashShiftProvider Unit Tests', () {
    late MockCashShiftRepository mockRepo;
    late CashShiftCalculator calculator;
    late CashShiftProvider provider;

    setUp(() {
      mockRepo = MockCashShiftRepository();
      calculator = const CashShiftCalculator();
      provider = CashShiftProvider(
        repository: mockRepo,
        calculator: calculator,
      );
    });

    test('loadShifts populates active shift and past closed shifts', () async {
      when(
        () => mockRepo.getShifts(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyShift]);

      await provider.loadShifts(orgId: 'org_1', buId: 'bu_1');

      expect(provider.status, equals(FeatureStatusEnum.loaded));
      expect(provider.hasActiveShift, isTrue);
      expect(provider.activeShift?.id, equals('shift_active'));
    });

    test('openNewShift creates and sets active shift', () async {
      await provider.openNewShift(
        buId: 'bu_1',
        registerNumber: 2,
        openingBalance: 150.0,
        cashierId: 'usr_2',
      );

      expect(provider.hasActiveShift, isTrue);
      expect(provider.activeShift?.openingBalance, equals(150.0));
      expect(provider.activeShift?.cashRegisterNumber, equals(2));
    });

    test(
      'recordCashMovement updates cash withdrawals and injections',
      () async {
        when(
          () => mockRepo.getShifts(orgId: 'org_1', buId: 'bu_1'),
        ).thenAnswer((_) async => [dummyShift]);

        await provider.loadShifts(orgId: 'org_1', buId: 'bu_1');

        await provider.recordCashMovement(amount: 50.0, isWithdrawal: true);
        expect(provider.activeShift?.cashWithdrawals, equals(50.0));

        await provider.recordCashMovement(amount: 30.0, isWithdrawal: false);
        expect(provider.activeShift?.cashInjections, equals(30.0));
      },
    );

    test('closeShiftWithBlindDrop calculates variance correctly', () async {
      when(
        () => mockRepo.getShifts(orgId: 'org_1', buId: 'bu_1'),
      ).thenAnswer((_) async => [dummyShift]);

      await provider.loadShifts(orgId: 'org_1', buId: 'bu_1');

      // Expected is 500. Counted is 490 -> -10 difference
      final result = await provider.closeShiftBlindDrop(actualCounted: 490.0);

      expect(result, isNotNull);
      expect(result?.difference, equals(-10.0));
      expect(result?.discrepancyStatus, equals(ShiftDiscrepancyEnum.shortage));
      expect(provider.hasActiveShift, isFalse);
    });
  });

  group('CashShiftScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets(
      'renders active shift card, actions, and opens blind drop modal',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 720);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const LogistoApp(locale: Locale('en'), home: CashShiftScreen()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Cash Shifts & Blind Drop Controls'), findsOneWidget);
        expect(find.text('Cash Movement (+ / -)'), findsOneWidget);
        expect(find.text('Close Shift (Blind Drop / Corte Z)'), findsOneWidget);

        // Tap Close Shift (Blind Drop / Corte Z)
        await tester.tap(find.text('Close Shift (Blind Drop / Corte Z)'));
        await tester.pumpAndSettle();

        expect(find.text('Blind Drop Shift Closure (Corte Z)'), findsOneWidget);
        expect(find.text('Submit Blind Count'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Blind Drop Shift Closure (Corte Z)'), findsNothing);
      },
    );
  });
}
