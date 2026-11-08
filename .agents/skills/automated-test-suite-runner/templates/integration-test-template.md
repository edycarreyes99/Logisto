# Canonical Integration Test Suite Template

> Scope: test/integration/[workflow]_flow_test.dart  
> Rules Enforced: [../../../rules/rule-test-coverage-enforcement.md](../../../rules/rule-test-coverage-enforcement.md), [../../../rules/rule-offline-first-firestore.md](../../../rules/rule-offline-first-firestore.md)  

---

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late AppCollections collections;
  late FeatureRepository repository;
  late FeatureService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    collections = AppCollections(fakeFirestore);
    repository = FeatureRepository(collections: collections, firestore: fakeFirestore);
    service = FeatureService(repository: repository);
  });

  test('Complete workflow integration test: create, query, stream, delete', () async {
    // 1. Initial State: verify empty collection
    final initialList = await service.loadAll();
    expect(initialList, isEmpty);

    // 2. Creation: save new domain entity
    final createdId = await service.createItem(
      title: 'Integrated Station',
      value: 120.0,
    );
    expect(createdId, isNotEmpty);

    // 3. Query & Snapshot Stream verification
    final itemsAfterCreate = await service.loadAll();
    expect(itemsAfterCreate.length, equals(1));
    expect(itemsAfterCreate.first.id, equals(createdId));
    expect(itemsAfterCreate.first.title, equals('Integrated Station'));

    // 4. Mutation & Optimistic Update
    await service.updateItem(createdId, value: 150.0);
    final updated = await service.getById(createdId);
    expect(updated?.value, equals(150.0));

    // 5. Deletion & Cleanup
    await service.deleteItem(createdId);
    final finalItems = await service.loadAll();
    expect(finalItems, isEmpty);
  });
}
```
