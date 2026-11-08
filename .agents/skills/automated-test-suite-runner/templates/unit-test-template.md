# Canonical Unit Test Suite Template

> Scope: test/unit/[layer]/[module]_test.dart  
> Rules Enforced: [../../../rules/rule-test-coverage-enforcement.md](../../../rules/rule-test-coverage-enforcement.md), [../../../rules/rule-english-dart-docs.md](../../../rules/rule-english-dart-docs.md)  

---

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Declare mocks outside main
class MockDependency extends Mock implements SomeDependency {}

void main() {
  late MockDependency mockDependency;
  late SubjectUnderTesting systemUnderTest;

  setUp(() {
    mockDependency = MockDependency();
    systemUnderTest = SubjectUnderTesting(dependency: mockDependency);
  });

  tearDown(() {
    // Clean up resources if necessary
  });

  group('SubjectUnderTesting - Positive Happy Paths', () {
    test('executes successful operation and returns expected output', () async {
      // Arrange
      const expectedInput = 'valid_data';
      when(() => mockDependency.fetch(expectedInput))
          .thenAnswer((_) async => 'result');

      // Act
      final result = await systemUnderTest.execute(expectedInput);

      // Assert
      expect(result, equals('result'));
      verify(() => mockDependency.fetch(expectedInput)).called(1);
    });
  });

  group('SubjectUnderTesting - Defensive Negative & Boundary Scenarios', () {
    test('throws ArgumentError when input parameter is empty or whitespace', () async {
      expect(
        () => systemUnderTest.execute('   '),
        throwsA(isA<ArgumentError>()),
      );
      verifyZeroInteractions(mockDependency);
    });

    test('propagates underlying dependency failure gracefully', () async {
      when(() => mockDependency.fetch(any()))
          .thenThrow(Exception('Simulated network failure'));

      expect(
        () => systemUnderTest.execute('valid_data'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
```
