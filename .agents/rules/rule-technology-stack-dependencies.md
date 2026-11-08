---
id: RULE-ARCH-005
title: Approved Technology Stack and Key Dependencies Specification
category: architecture
severity: blocking
scope:
  include:
    - "pubspec.yaml"
    - "lib/**"
  exclude:
    - "test/**"
---

# Approved Technology Stack and Key Dependencies Specification

> Rule ID: RULE-ARCH-005  
> Severity: blocking  
> Target Scope: pubspec.yaml, lib/**  
> Category: architecture  

---

## 1. Architectural Invariant

All applications and modules in this repository MUST strictly adhere to the approved canonical technology stack and dependency manifest. Under no circumstances may an agent or engineer introduce unapproved third-party libraries, alternative state management solutions, unvetted HTTP clients, or incompatible SDK version ranges.

Approved Dependency Manifest:
1. **Core SDK:** Dart SDK / Flutter (`sdk: ^3.9.2`).
2. **Universal Design System & Grid:** `bootstrap_ui_flutter` (`^0.6.0`) as the exclusive presentation component library, responsive grid, and design token provider (RULE-UI-006).
3. **Dependency Injection:** `get_it` (`^7.6.0`) for compile-time service location.
4. **State Management:** `provider` (`^6.1.2`) with `ChangeNotifier` and status enums.
5. **Firebase Core:** `firebase_core` (`^3.10.0`).
6. **Persistence & Sync:** `cloud_firestore` (`^5.6.0`) with offline persistence enabled.
7. **Key-Value Storage:** `shared_preferences` (`^2.3.0`) encapsulated in `lib/data/preferences/`.
8. **Environment Configuration:** `flutter_dotenv` (`^5.2.1`).
9. **Vector Graphics & Animations:** `flutter_svg` (`^2.0.17`), `lottie` (`^3.2.0`), `fl_chart` (`^0.69.0`).
10. **Internationalization:** `flutter_localizations` and `intl` (`^0.20.2`).
11. **Image Caching:** `cached_network_image` (`^3.4.1`).

Prohibited Dependencies:
- Alternative state managers (`bloc`, `flutter_bloc`, `riverpod`, `flutter_riverpod`, `get`, `mobx`).
- Ad-hoc HTTP clients (`http`, `dio`) that bypass Cloud Firestore offline synchronization for core data.
- Unvetted local persistence packages (`hive`, `isar`, `sqflite`, `objectbox`) bypassing the single source of truth.
- Unvetted external UI design systems that conflict with `bootstrap_ui_flutter` and `AppTheme`.

---

## 2. Rationale & Failure Impact

- **Architectural Uniformity:** Uncontrolled package adoption fragments application state, introduces competing event loops, bloats application binary sizes, and causes dependency version resolution deadlocks.
- **Offline-First Integrity:** Introducing ad-hoc HTTP networking alongside Firestore breaks the offline-first cache architecture and real-time synchronization model.
- **Maintainability:** Restricting state management to `Provider` and DI to `GetIt` ensures any team engineer or AI subagent can understand, test, and refactor any module without learning disparate paradigms.

---

## 3. Compliant Pattern (DO)

Dependencies in `pubspec.yaml` are pinned to the approved version ranges:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Architecture & State
  bootstrap_ui_flutter: ^0.6.0
  get_it: ^7.6.0
  provider: ^6.1.2

  # Firebase & Persistence
  firebase_core: ^3.10.0
  cloud_firestore: ^5.6.0
  shared_preferences: ^2.3.0

  # Cross-Cutting & UI
  flutter_dotenv: ^5.2.1
  flutter_svg: ^2.0.17
  lottie: ^3.2.0
  fl_chart: ^0.69.0
  intl: ^0.20.2
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.4
  fake_cloud_firestore: ^3.1.0
```

---

## 4. Prohibited Pattern (DON'T)

Adding unapproved state managers or redundant network libraries:

```yaml
# PROHIBITED: Introducing unapproved competing dependencies
dependencies:
  flutter_bloc: ^8.1.3      # FORBIDDEN: Provider is the sole state management solution
  get: ^4.6.6               # FORBIDDEN: GetX introduces anti-patterns and unmanaged context
  dio: ^5.4.0               # FORBIDDEN: Core persistence flows through Cloud Firestore
  hive_flutter: ^1.1.0      # FORBIDDEN: Persistence is handled by Cloud Firestore & SharedPreferences
```

---

## 5. Automated Validation & Audit Procedure

Verify that `pubspec.yaml` contains only approved dependencies:

```bash
# 1. Audit pubspec.yaml for unapproved dependencies
! grep -E "flutter_bloc|riverpod|get:|dio|hive|sqflite" pubspec.yaml

# 2. Run dependency resolution check
flutter pub get

# 3. Check for dependency conflicts or outdated constraints
flutter pub outdated
```
