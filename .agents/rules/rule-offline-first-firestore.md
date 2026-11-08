---
id: RULE-DATA-001
title: Offline-First Cloud Firestore Persistence and Real-Time Streams
category: data
severity: blocking
scope:
  include:
    - "lib/data/**"
  exclude:
    - "test/**"
---

# Offline-First Cloud Firestore Persistence and Real-Time Streams

> Rule ID: RULE-DATA-001  
> Severity: blocking  
> Target Scope: lib/data/**  
> Category: data  

---

## 1. Architectural Invariant

Cloud Firestore (`cloud_firestore`) serves as the application's unified single source of truth for both local persistence and remote synchronization.

Under no circumstances shall:
1. Firestore client initialization disable persistence (`persistenceEnabled: false`) on any supported target platform.
2. Repositories poll databases in loops using one-off `get()` calls when reactive real-time snapshot streams (`snapshots()`) are appropriate.
3. Mutations block UI interactivity waiting for remote cloud confirmation; optimistic local cache writes MUST be embraced.
4. Raw untyped `Map<String, dynamic>` payloads be exposed outside the Data layer; data MUST be deserialized via DTOs into pure Domain entities.

---

## 2. Rationale & Failure Impact

- **Instant Startup & Network Resilience:** With persistence enabled (IndexedDB on Web, SQLite on Mobile and Desktop), data is immediately served from local disk, allowing instant app startup even in zero-connectivity or airplane mode.
- **Real-Time Consistency:** Snapshot listeners automatically receive local optimistic changes and reconcile them with upstream server confirmations.
- **Failure Impact:** Disabling persistence causes empty white screens on slow connections, excessive billable Firestore reads, and broken offline usability.

---

## 3. Compliant Pattern (DO)

Configure Firestore with persistence enabled across all targets, expose reactive snapshot streams, and map documents via DTOs:

```dart
// lib/data/firestore/firestore_client.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient {
  final FirebaseFirestore _firestore;

  FirestoreClient({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  FirebaseFirestore get instance => _firestore;
}

// lib/data/repositories/weather_station_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/weather_station_model.dart';
import '../dtos/weather_station_dto.dart';
import '../firestore/firestore_client.dart';

class WeatherStationRepository {
  final FirestoreClient _client;

  WeatherStationRepository({required FirestoreClient firestoreClient})
      : _client = firestoreClient;

  CollectionReference<WeatherStationDto> get _collection =>
      _client.instance.collection('weather_stations').withConverter<WeatherStationDto>(
        fromFirestore: (snapshot, _) => WeatherStationDto.fromFirestore(snapshot),
        toFirestore: (dto, _) => dto.toFirestore(),
      );

  Stream<List<WeatherStationModel>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data().toDomain()).toList(),
    );
  }

  Future<void> save(WeatherStationModel model) async {
    final dto = WeatherStationDto.fromDomain(model);
    await _collection.doc(model.id).set(dto, SetOptions(merge: true));
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Disabling persistence or polling using repetitive `get()` calls:

```dart
// BAD: Persistence disabled and repetitive manual polling
class BadClient {
  void init() {
    // VIOLATION: Disabling offline persistence destroys offline capabilities!
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
  }

  // VIOLATION: Repeatedly calling get() in an infinite polling loop!
  Future<void> pollData() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      final snapshot = await FirebaseFirestore.instance.collection('data').get();
      // ...
    }
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Verify Firestore client settings maintain persistence enabled:

```bash
# Verify persistence is never disabled
rg --glob 'lib/data/**' 'persistenceEnabled:\s*false'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
