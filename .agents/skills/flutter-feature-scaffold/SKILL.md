---
name: flutter-feature-scaffold
description: |
  Comprehensive procedural workflow for scaffolding clean architecture feature modules in Flutter.
  Generates cohesive feature screens, decomposed sub-widgets, catalog providers, form providers, and pure domain models.
  Mandatory trigger conditions:
  - Trigger when creating a new domain feature, catalog screen, or user workflow in Flutter.
  - Trigger when refactoring monolithic UI widgets into clean architecture feature modules.
  Do NOT trigger when:
  - Do not trigger for raw database collection or DTO creation alone (delegate to firestore-repository-builder).
  - Do not trigger for purely styling or design token adjustments (delegate to design-system-theme-tokens).
license: Apache-2.0
metadata:
  version: 1.0.0
  category: architecture
  publisher: Architecture Standards Team
---

# Flutter Feature Scaffold Workflow

> Standard: Enterprise Clean Architecture  
> Scope: lib/presentation/[feature]/, lib/domain/models/, lib/domain/services/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes the procedural generation of production-ready Flutter feature modules adhering to clean architecture. It guarantees strict separation of concerns across presentation, domain, and data layers, enforces sub-40-line decomposed widgets, sets up responsive 12-column Bootstrap grid layouts, and wires reactive ChangeNotifier state controllers.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Adding a new functional vertical (e.g., weather stations, alerts, user settings, telemetry catalog).
- Decomposing an oversized, monolithic screen into modular sub-widgets and providers.
- Scaffolding both a list/catalog view and an accompanying creation/editing form view.

### 2.2. When to Avoid This Skill
- Working strictly on low-level Firestore client configuration or DTO mappers (use `firestore-repository-builder`).
- Configuring localization bundles exclusively (use `bilingual-localization-sync`).
- Modifying design tokens, colors, or typography scales (use `design-system-theme-tokens`).

---

## 3. Pre-Flight Verification (Step 0)

Before scaffolding a feature module, verify required abstractions and dependencies exist:

```bash
# Verify Flutter SDK and required pub dependencies are present
flutter --version
grep -E 'bootstrap_ui_flutter|provider|get_it' pubspec.yaml
```

Confirm that the project design system tokens (`AppColors`, `AppDimens`, `AppSpacing`) and core widgets (`AppButton`, `AppCard`, `AppSearchBar`) exist in `lib/theme/` and `lib/core/widgets/`.

---

## 4. Canonical Specification & Standards

### 4.1. Feature Directory Layout
Each feature module MUST adhere to the following anatomy under `lib/presentation/[feature_name]/`:

```
lib/presentation/[feature_name]/
├── [feature]_screen.dart           # Primary screen (<40 lines build, Bootstrap container)
├── [feature]_provider.dart         # Catalog state controller (ChangeNotifier + status enum)
├── [feature]_form_provider.dart    # Form validation state controller
├── widgets/                        # Decomposed, single-responsibility sub-widgets
│   ├── [feature]_header.dart       # Search bar, actions, and title
│   ├── [feature]_grid.dart         # 12-column responsive grid layout
│   ├── [feature]_card.dart         # Individual card item container
│   └── [feature]_empty_view.dart   # Localized zero-data placeholder
└── models/                         # Presentation-specific UI models (optional)
```

### 4.2. Layer Flow Invariant
- Presentation files depend ONLY on Domain and Core abstractions.
- Presentation files NEVER import `cloud_firestore` or database DTOs directly.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Define the Pure Domain Model
Create the clean business entity in `lib/domain/models/`:

```dart
// lib/domain/models/station_model.dart
import '../../core/enums/item_status_enum.dart';

/// Pure domain entity representing an environmental monitoring station.
class StationModel {
  final String id;
  final String name;
  final double temperature;
  final ItemStatusEnum status;

  const StationModel({
    required this.id,
    required this.name,
    required this.temperature,
    required this.status,
  });

  StationModel copyWith({
    String? id,
    String? name,
    double? temperature,
    ItemStatusEnum? status,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      temperature: temperature ?? this.temperature,
      status: status ?? this.status,
    );
  }
}
```

### Step 2: Implement Domain Service
Define domain operations in `lib/domain/services/`:

```dart
// lib/domain/services/station_service.dart
import '../models/station_model.dart';
import '../../data/repositories/station_repository.dart';

/// Domain service orchestrating weather station operations.
class StationService {
  final StationRepository _repository;

  StationService({required StationRepository repository}) : _repository = repository;

  Stream<List<StationModel>> watchStations() => _repository.watchAll();

  Future<void> saveStation(StationModel station) async {
    if (station.name.trim().isEmpty) {
      throw ArgumentError('Station name cannot be empty.');
    }
    await _repository.save(station);
  }
}
```

### Step 3: Implement Feature Catalog Provider
Implement the catalog state controller in `lib/presentation/[feature]/`:

```dart
// lib/presentation/stations/stations_provider.dart
import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/station_model.dart';
import '../../domain/services/station_service.dart';

/// Catalog state controller for weather stations.
class StationsProvider extends ChangeNotifier {
  final StationService _service;
  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  List<StationModel> _stations = const [];
  String _searchQuery = '';

  StationsProvider({required StationService service}) : _service = service;

  FeatureStatusEnum get status => _status;
  List<StationModel> get stations => _filteredStations();

  void initialize() {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    _service.watchStations().listen(
      (data) {
        _stations = data;
        _status = FeatureStatusEnum.loaded;
        notifyListeners();
      },
      onError: (_) {
        _status = FeatureStatusEnum.error;
        notifyListeners();
      },
    );
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<StationModel> _filteredStations() {
    if (_searchQuery.trim().isEmpty) return _stations;
    return _stations.where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }
}
```

### Step 4: Construct Decomposed Sub-Widgets
Build granular sub-widgets in `presentation/[feature]/widgets/` ensuring each stays under 35 lines.

```dart
// lib/presentation/stations/widgets/stations_header.dart
import 'package:flutter/material.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';

class StationsHeader extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  const StationsHeader({super.key, required this.onSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: AppSearchBar(onChanged: onSearch, hintText: l10n.searchPlaceholder)),
        const SizedBox(width: 16),
        AppButton(text: l10n.addItem, onPressed: onAdd),
      ],
    );
  }
}
```

### Step 5: Assemble the Feature Screen
Keep the primary screen's `build` method under 40 lines using `bootstrap_ui_flutter`:

```dart
// lib/presentation/stations/stations_screen.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import '../../locator.dart';
import 'stations_provider.dart';
import 'widgets/stations_header.dart';
import 'widgets/stations_grid.dart';
import 'widgets/stations_empty_view.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  late final StationsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = locator<StationsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _provider.initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BsContainer(
          fluid: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StationsHeader(
                onSearch: _provider.updateSearch,
                onAdd: () {},
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AnimatedBuilder(
                  animation: _provider,
                  builder: (context, _) {
                    return _provider.stations.isEmpty
                        ? const StationsEmptyView()
                        : StationsGrid(stations: _provider.stations);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Zero stations returned from database | Screen shows blank view | Render `StationsEmptyView` with localized message and call-to-action button. |
| Rapid text input in search bar | Excessive UI filtering triggers stutter | Debounce search query input by 300ms in `AppSearchBar`. |
| Screen disposed while stream active | Exception: `notifyListeners called after dispose` | Check `hasListeners` before dispatching updates in asynchronous handlers. |

---

## 7. Verification & Quality Gates

Run the verification suite to ensure adherence:

```bash
# 1. Verify build method length stays under 40 lines
python3 -c "
import pathlib, re
for f in pathlib.Path('lib/presentation').rglob('*_screen.dart'):
    content = f.read_text(encoding='utf-8')
    assert 'package:cloud_firestore' not in content, f'Firestore import detected in {f}'
print('PASS: Clean presentation layer boundary validated.')
"

# 2. Run Flutter static analysis
flutter analyze
```

Checklist (see full [references/feature-scaffold-validation-checklist.md](references/feature-scaffold-validation-checklist.md)):
- [ ] Feature screen build method is <= 40 lines.
- [ ] Decomposed sub-widgets reside in `presentation/[feature]/widgets/`.
- [ ] Zero Firestore imports in presentation files.
- [ ] Responsive grid implemented via `BsContainer`, `BsRow`, `BsCol`.
- [ ] 100% English code and documentation comments.
