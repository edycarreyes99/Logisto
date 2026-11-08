---
id: RULE-ARCH-006
title: Canonical Project Anatomy and Folder Hierarchy Enforcement
category: architecture
severity: blocking
scope:
  include:
    - "lib/**"
    - "assets/**"
    - "tool/**"
  exclude:
    - "test/**"
---

# Canonical Project Anatomy and Folder Hierarchy Enforcement

> Rule ID: RULE-ARCH-006  
> Severity: blocking  
> Target Scope: lib/**, assets/**, tool/**  
> Category: architecture  

---

## 1. Architectural Invariant

All files and code assets in this repository MUST be placed strictly inside their canonical directories within the established project hierarchy. Creating ad-hoc root folders in `lib/` (such as `lib/views/`, `lib/controllers/`, `lib/utils/`, or `lib/services/` directly under `lib/`), placing assets outside designated categorized asset subdirectories, or violating the layered directory layout is strictly prohibited.

The canonical project structure requires:
```
<project_root>/
├── pubspec.yaml
├── analysis_options.yaml
├── l10n.yaml
├── .env
├── .env.example
├── assets/
│   ├── animations/
│   ├── flags/
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   └── svg/
├── tool/
│   └── dev_setup.dart
└── lib/
    ├── main.dart
    ├── app_initializer.dart
    ├── firebase_options.dart
    ├── locator.dart
    ├── theme/
    ├── core/
    ├── data/
    ├── domain/
    ├── presentation/
    └── l10n/
```

Under no circumstances shall:
1. Business logic or domain models be placed outside `lib/domain/`.
2. Cloud Firestore collections, repositories, DTOs, or SharedPreferences wrappers be placed outside `lib/data/`.
3. Reusable project-prefixed widgets, reactive form validators, or universal enums be placed outside `lib/core/`.
4. Color tokens, spacing metrics, typography, or theme definitions be placed outside `lib/theme/`.
5. Feature screens, feature providers, or feature sub-widgets be placed outside `lib/presentation/`.
6. Translation ARB bundles or configuration be placed outside `lib/l10n/`.

---

## 2. Rationale & Failure Impact

- **Predictable Discovery:** A deterministic folder structure ensures developers and autonomous agents locate dependencies, models, and UI screens instantaneously without full-repo grep searches.
- **Enforced Layer Boundaries:** Layer boundaries (`Presentation -> Domain -> Data`) correspond directly to folder boundaries. Ad-hoc directory creation blurs architectural responsibilities, leading to cyclical imports and spaghetti code.
- **Build & Generator Compatibility:** Flutter code generation (`flutter gen-l10n`, `flutterfire configure`, launcher icons) relies on exact path conventions defined in configuration files (`l10n.yaml`, `pubspec.yaml`).

---

## 3. Compliant Pattern (DO)

Files are organized strictly by tier, feature, and responsibility:

```dart
// lib/core/enums/item_status_enum.dart - Universal strongly-typed enum
enum ItemStatusEnum { active, inactive, draft, archived }

// lib/domain/models/station_model.dart - Pure domain model
class StationModel {
  final String id;
  final String title;
  const StationModel({required this.id, required this.title});
}

// lib/data/repositories/station_repository.dart - Data persistence
class StationRepository { ... }

// lib/presentation/station/station_screen.dart - Feature screen
class StationScreen extends StatefulWidget { ... }

// lib/presentation/station/widgets/station_header.dart - Decomposed sub-widget
class StationHeader extends StatelessWidget { ... }
```

---

## 4. Prohibited Pattern (DON'T)

Creating arbitrary directories or dumping files in root `lib/`:

```
# PROHIBITED: Arbitrary directory naming and misplacement
lib/
├── views/              # FORBIDDEN: UI belongs in lib/presentation/[feature]/
├── controllers/        # FORBIDDEN: State controllers belong in lib/presentation/[feature]/
├── models/             # FORBIDDEN: Domain models belong in lib/domain/models/
├── utils/              # FORBIDDEN: Utilities belong in lib/core/utils/
├── services/           # FORBIDDEN: Ambiguous. Services must be lib/domain/services/ or lib/core/services/
└── random_helper.dart  # FORBIDDEN: Zero loose files in lib/ root besides main, locator, app_initializer, firebase_options
```

---

## 5. Automated Validation & Audit Procedure

Verify that directory layout complies with canonical structure:

```bash
# 1. Ensure no forbidden root folders exist in lib/
python3 -c "
import pathlib, sys
lib = pathlib.Path('lib')
if not lib.exists():
    sys.exit(0)
allowed_dirs = {'theme', 'core', 'data', 'domain', 'presentation', 'l10n'}
actual_dirs = {d.name for d in lib.iterdir() if d.is_dir()}
unexpected = actual_dirs - allowed_dirs
if unexpected:
    print(f'Unexpected directories in lib/: {unexpected}')
    sys.exit(1)
"

# 2. Check that assets follow categorized structure
ls -d assets/*/ 2>/dev/null
```
