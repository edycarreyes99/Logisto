---
id: RULE-QUAL-001
title: Strict 100% Test Coverage & Defensive Error Testing Enforcement
category: quality
severity: blocking
scope:
  include:
    - "lib/**"
    - "test/**"
---

# Strict 100% Test Coverage & Defensive Error Testing Enforcement

> Rule ID: RULE-QUAL-001  
> Severity: blocking  
> Target Scope: lib/**, test/**  
> Category: quality  

---

## 1. Architectural Invariant

All production code located across Domain (`lib/domain/`), Core validators and utilities (`lib/core/`), Data DTOs, mappers, preference wrappers, and repositories (`lib/data/`), and Presentation providers (`lib/presentation/`) MUST achieve and maintain 100% line and branch test coverage.

Under no circumstances shall:
1. Any pull request, refactor, or new feature deliver uncovered methods, conditional branches, or edge case paths.
2. Existing tests be weakened, skipped (e.g. `@Skip()`, `skip: true`), or deleted to achieve a passing test run or artificial green build.
3. Tests assert solely on happy-path invocations while omitting error branches, exceptions, nullability handling, and boundary conditions.
4. Mocks be hardcoded to return only optimistic data without asserting failure responses, empty state handling, and timeout behavior.
5. Unit tests import Flutter UI widgets or create real Firestore network connections; they must use pure mock interfaces or fake Firestore instances.

---

## 2. Rationale & Failure Impact

- **Zero Regression Tolerance:** In an offline-first, multiplatform application running across mobile, web, and desktop, unverified edge cases (such as malformed cache payloads, permission drops, or offline stream failures) lead to silent crashes, UI freezes, or data loss.
- **Defensive Error Resilience:** Happy-path testing validates that code works under ideal conditions. Exhaustive negative testing guarantees that when network requests fail, database connections drop, or invalid arguments are supplied, the application fails gracefully with localized user feedback rather than unhandled fatal exceptions.
- **Refactoring Confidence:** A comprehensive test suite providing 100% coverage allows autonomous agents and human engineers to perform aggressive architectural refactorings without fear of breaking unexpected dependencies.

---

## 3. Compliant Pattern (DO)

Tests explicitly verify happy paths, boundary inputs, and error exceptions:

```dart
// test/domain/services/station_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:climatica/domain/services/station_service.dart';
import 'package:climatica/domain/models/station_model.dart';
import 'package:climatica/core/enums/item_status_enum.dart';
import '../../mocks/mock_station_repository.dart';

void main() {
  late MockStationRepository mockRepository;
  late StationService service;

  setUp(() {
    mockRepository = MockStationRepository();
    service = StationService(repository: mockRepository);
  });

  group('StationService - Happy Path', () {
    test('saveStation persists valid station model and returns id', () async {
      const station = StationModel(
        id: '',
        title: 'Central Station',
        code: 'CS-01',
        value: 42.5,
        status: ItemStatusEnum.active,
      );

      when(() => mockRepository.save(station))
          .thenAnswer((_) async => 'generated-id-123');

      final result = await service.saveStation(station);

      expect(result, equals('generated-id-123'));
      verify(() => mockRepository.save(station)).called(1);
    });
  });

  group('StationService - Defensive Error & Edge Cases', () {
    test('saveStation throws ArgumentError when title is empty', () async {
      const emptyTitleStation = StationModel(
        id: '',
        title: '   ',
        code: 'CS-01',
        value: 10.0,
        status: ItemStatusEnum.active,
      );

      expect(
        () => service.saveStation(emptyTitleStation),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Item title cannot be empty'),
        )),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('saveStation throws ArgumentError when value is negative', () async {
      const negativeValueStation = StationModel(
        id: '',
        title: 'North Station',
        code: 'NS-02',
        value: -0.01,
        status: ItemStatusEnum.active,
      );

      expect(
        () => service.saveStation(negativeValueStation),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Item value cannot be negative'),
        )),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('deleteStation throws ArgumentError when id is whitespace', () async {
      expect(
        () => service.deleteStation('   '),
        throwsA(isA<ArgumentError>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('saveStation propagates repository exceptions gracefully', () async {
      const validStation = StationModel(
        id: '',
        title: 'Valid Station',
        code: 'VS-01',
        value: 10.0,
        status: ItemStatusEnum.active,
      );

      when(() => mockRepository.save(validStation))
          .thenThrow(Exception('Firestore write failed'));

      expect(
        () => service.saveStation(validStation),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.save(validStation)).called(1);
    });
  });
}
```

---

## 4. Prohibited Pattern (DON'T)

Skipping tests, testing only the happy path, or suppressing test failures:

```dart
// BAD: Skipping failing tests or testing only happy paths
void main() {
  // VIOLATION: Skipping test to mask failure
  test('failing critical test', () {
    // ...
  }, skip: true); // PROHIBITED

  // VIOLATION: Only happy path tested; zero error branches or invalid inputs tested
  test('save station', () async {
    final s = StationService(repository: MockRepo());
    await s.saveStation(validStation);
    // VIOLATION: No assertion, or asserting only trivial true
    expect(true, isTrue);
  });
}
```

---

## 5. Automated Validation & Audit Procedure

Execute the following commands to enforce complete test coverage and verify zero skipped tests:

```bash
# 1. Detect any skipped tests in test suite
rg "skip:\s*true|@Skip\(" test/

# 2. Run entire test suite with coverage calculation
flutter test --coverage

# 3. Check for uncovered lines using lcov or dart coverage tool
# (Fail if line coverage is below 100% on tested modules)
genhtml coverage/lcov.info -o coverage/html
```

Any uncovered branches, skipped tests, or missing error paths are considered blocking build failures.
