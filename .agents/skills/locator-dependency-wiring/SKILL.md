---
name: locator-dependency-wiring
description: |
  Procedural guide for configuring centralized dependency injection via GetIt and orchestrating application bootstrap.
  Wires clients, repositories, domain services, system providers, and manages startup lifecycle preloading.
  Mandatory trigger conditions:
  - Trigger when registering new repositories, services, or providers in lib/locator.dart.
  - Trigger when orchestrating application bootstrapper warmup, authentication lifecycle, or locator resets.
  Do NOT trigger when:
  - Do not trigger for UI styling or layout construction alone.
  - Do not trigger for Firestore security rules configuration.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: architecture
  publisher: Architecture Standards Team
---

# Service Locator Dependency Wiring & Lifecycle Bootstrap

> Standard: Centralized Dependency Injection & App Bootstrap  
> Scope: lib/locator.dart, lib/app_initializer.dart, lib/core/bootstrap/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes dependency registration and application initialization across Flutter applications. It centralizes all inversion of control (IoC) bindings within `lib/locator.dart` via `GetIt`, manages instance lifecycles (singletons vs factories), coordinates pre-startup settings initialization via `AppInitializer`, and handles concurrent cache preloading via `AppBootstrapper`.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Registering a newly created repository, domain service, or feature provider in `locator.dart`.
- Configuring startup warmup logic when a user session is detected.
- Swapping concrete implementations for mock instances in integration test fixtures.

### 2.2. When to Avoid This Skill
- Writing feature UI widgets or styling containers.
- Writing pure domain model business logic.
- Authoring localization strings.

---

## 3. Pre-Flight Verification (Step 0)

Ensure `get_it` is installed in `pubspec.yaml`:

```bash
# Verify get_it dependency
grep 'get_it' pubspec.yaml
```

Verify that `lib/locator.dart` exists and exports the global `locator` instance:
`final GetIt locator = GetIt.instance;`

---

## 4. Canonical Specification & Standards

### 4.1. File Structure
```
lib/
├── locator.dart                         # Central GetIt dependency registration manifest
├── app_initializer.dart                 # Pre-startup settings loader (locale & theme)
└── core/bootstrap/
    └── app_bootstrapper.dart            # Concurrent dataset preloader and cache warmup
```

### 4.2. Invariant Rules
- UI screens MUST NEVER instantiate repositories or services directly via `new Service()`.
- State that spans the entire user session (e.g. `ThemeMode`, `Locale`, `AuthPreferences`) MUST be registered as `registerLazySingleton`.
- Ephemeral feature state controllers (e.g. `ItemFormProvider`) SHOULD be registered as `registerFactory` to provide a clean state on each mount.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Configure Central Registration in lib/locator.dart
Assemble the dependency registration graph:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'core/bootstrap/app_bootstrapper.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'data/firestore/collections/app_collections.dart';
import 'data/firestore/firestore_client.dart';
import 'data/preferences/auth_preferences.dart';
import 'data/repositories/station_repository.dart';
import 'domain/services/station_service.dart';
import 'firebase_options.dart';
import 'presentation/stations/stations_provider.dart';
import 'presentation/stations/station_form_provider.dart';

final GetIt locator = GetIt.instance;

/// Registers all global application dependencies in deterministic order.
Future<void> setupLocator() async {
  // 1. Environment Configurations
  await dotenv.load(fileName: ".env");

  // 2. Firebase Multiplatform Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Cloud Firestore Client with Persistence
  final firestoreClient = await FirestoreClient.initialize();
  locator.registerSingleton<FirebaseFirestore>(firestoreClient.firestore);
  locator.registerSingleton<FirestoreClient>(firestoreClient);

  // 4. Firestore Collections Manifest
  locator.registerLazySingleton<AppCollections>(
    () => AppCollections(client: locator<FirestoreClient>()),
  );

  // 5. Asynchronous SharedPreferences Singleton
  locator.registerSingletonAsync<AuthPreferences>(() => AuthPreferences.getInstance());
  await locator.isReady<AuthPreferences>();

  // 6. Core System Providers and Services
  locator.registerLazySingleton<LocaleProvider>(() => LocaleProvider());
  locator.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  locator.registerLazySingleton<NotificationService>(() => NotificationService());
  locator.registerLazySingleton<AppBootstrapper>(() => AppBootstrapper());

  // 7. Repositories
  locator.registerLazySingleton<StationRepository>(
    () => StationRepository(firestoreClient: locator<FirestoreClient>()),
  );

  // 8. Domain Services
  locator.registerLazySingleton<StationService>(
    () => StationService(repository: locator<StationRepository>()),
  );

  // 9. Feature Providers
  locator.registerLazySingleton<StationsProvider>(
    () => StationsProvider(service: locator<StationService>()),
  );
  locator.registerFactory<StationFormProvider>(
    () => StationFormProvider(service: locator<StationService>()),
  );
}
```

### Step 2: Configure Pre-Startup AppInitializer
Initialize preferences before the widget tree mounts:

```dart
// lib/app_initializer.dart
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'locator.dart';

/// Handles pre-startup initialization of system settings, themes, and locales.
class AppInitializer {
  static Future<void> initializeAppSettings() async {
    await locator<LocaleProvider>().loadLocale();
    await locator<ThemeProvider>().loadTheme();
  }
}
```

### Step 3: Implement Concurrent AppBootstrapper Warmup
Preload critical datasets concurrently upon startup:

```dart
// lib/core/bootstrap/app_bootstrapper.dart
import '../../data/preferences/auth_preferences.dart';
import '../../locator.dart';
import '../../presentation/stations/stations_provider.dart';

/// Preloads cached Firestore data concurrently when an active session is detected.
class AppBootstrapper {
  final AuthPreferences _authPreferences;

  AppBootstrapper({AuthPreferences? authPreferences})
      : _authPreferences = authPreferences ?? locator<AuthPreferences>();

  /// Preloads cached Firestore collections concurrently upon startup.
  Future<bool> init() async {
    final userId = _authPreferences.getUserId();
    if (userId == null || userId.isEmpty) {
      return false;
    }

    try {
      final stationsProvider = locator<StationsProvider>();
      stationsProvider.initialize();
      return true;
    } catch (_) {
      return false;
    }
  }
}
```

### Step 4: Wire lib/main.dart Entry Point
Tie the components together in `lib/main.dart`:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'app_initializer.dart';
import 'locator.dart';
import 'presentation/stations/stations_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await AppInitializer.initializeAppSettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StationsScreen(),
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Duplicate locator registration | `GetIt: Object/type is already registered` | Check `locator.isRegistered<T>()` or call `locator.reset()` before re-registering in test suites. |
| Circular dependency in locator | StackOverflow or unresolvable future | Structure dependency DAG strictly: `Infrastructure -> Data -> Domain -> Presentation`. |
| Session token expires during boot | Bootstrapper hangs waiting for invalid auth | Enforce timeout on `init()` via `Future.wait(...).timeout(Duration(seconds: 5))`. |

---

## 7. Verification & Quality Gates

Run checks to confirm all dependencies are properly resolved:

```bash
# Verify no direct instantiations in presentation files
rg --glob 'lib/presentation/**' 'new [A-Z][a-zA-Z0-9]*(Service|Repository)\('
```

Checklist (see full [references/locator-bootstrap-validation-checklist.md](references/locator-bootstrap-validation-checklist.md)):
- [ ] Dependencies are registered in `lib/locator.dart`.
- [ ] Singletons vs Factories are applied based on lifecycle scope.
- [ ] `AppInitializer` completes before `runApp()`.
- [ ] `AppBootstrapper` safely handles absent user sessions.
- [ ] 100% English code and documentation comments.
