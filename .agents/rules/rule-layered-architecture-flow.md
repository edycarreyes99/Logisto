---
id: RULE-ARCH-001
title: Unidirectional Layered Architecture Flow
category: architecture
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Unidirectional Layered Architecture Flow

> Rule ID: RULE-ARCH-001  
> Severity: blocking  
> Target Scope: lib/**  
> Category: architecture  

---

## 1. Architectural Invariant

The codebase strictly enforces a unidirectional clean architecture layer flow:
`Presentation -> Domain -> Data`.

Under no circumstances shall:
1. The Domain layer (`lib/domain/`) import `package:flutter/material.dart`, any Flutter widget, or UI package.
2. The Domain layer import `package:cloud_firestore/cloud_firestore.dart`, database DTOs, or database platform SDK types.
3. The Presentation layer (`lib/presentation/`) import `package:cloud_firestore/cloud_firestore.dart` or reference database types such as `DocumentSnapshot`, `QuerySnapshot`, `CollectionReference`, or Data Transfer Objects (DTOs).
4. Presentation bypass Domain use cases and state providers to couple directly to persistence infrastructure.

---

## 2. Rationale & Failure Impact

- **Decoupled Business Rules:** Domain models, use cases, and services represent the core enterprise business rules. If Domain depends on Flutter UI or Cloud Firestore SDK classes, domain logic cannot be tested in isolation without mocking the entire Flutter framework or Firestore platform channels.
- **Portability Across Targets:** Cloud Firestore SDK behaves differently on Web (IndexedDB) versus Desktop (C++ plugin) versus Mobile. Encapsulating all Firestore calls within the Data layer (`lib/data/`) shields the rest of the application from database vendor quirks.
- **Failure Impact:** Breaking layer isolation causes severe coupling, circular dependencies in the service locator, test flakiness, and high maintenance costs when refactoring database schemas or migrating UI components.

---

## 3. Compliant Pattern (DO)

Presentation interacts exclusively with Domain services or controllers via ChangeNotifier providers, and Data repositories map Firestore documents to pure Domain entities before returning them to Domain:

```dart
// lib/domain/models/weather_station_model.dart
class WeatherStationModel {
  final String id;
  final String name;
  final double temperature;

  const WeatherStationModel({
    required this.id,
    required this.name,
    required this.temperature,
  });
}

// lib/domain/services/weather_station_service.dart
import '../models/weather_station_model.dart';
import '../../data/repositories/weather_station_repository.dart';

class WeatherStationService {
  final WeatherStationRepository _repository;

  WeatherStationService(this._repository);

  Stream<List<WeatherStationModel>> watchStations() {
    return _repository.watchAll();
  }
}

// lib/presentation/stations/stations_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/models/weather_station_model.dart';
import '../../domain/services/weather_station_service.dart';

class StationsProvider extends ChangeNotifier {
  final WeatherStationService _service;
  List<WeatherStationModel> _stations = const [];

  StationsProvider(this._service);

  List<WeatherStationModel> get stations => _stations;

  void initialize() {
    _service.watchStations().listen((data) {
      _stations = data;
      notifyListeners();
    });
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Directly importing Firestore or DTOs inside Presentation widgets or Domain entities violates architectural boundaries:

```dart
// BAD: Importing Cloud Firestore directly into Presentation Screen
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // VIOLATION: Presentation must not import cloud_firestore!

class StationScreen extends StatelessWidget {
  const StationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // VIOLATION: Querying Firestore directly inside build method!
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('stations').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            // VIOLATION: Raw map access directly from DocumentSnapshot
            return Text(docs[index]['name'] as String);
          },
        );
      },
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Static checks and regex scans detect violations across the repository:

```bash
# 1. Verify Domain does not import Material, Widgets, or Data
rg --glob 'lib/domain/**' 'package:flutter/material.dart|package:flutter/widgets.dart|package:cloud_firestore'

# 2. Verify Presentation does not import Cloud Firestore or DTOs
rg --glob 'lib/presentation/**' 'package:cloud_firestore|/dtos/|/data/firestore/'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
