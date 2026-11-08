---
id: RULE-ARCH-004
title: Deterministic App Startup & Bootstrap Lifecycle Order
category: architecture
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Deterministic App Startup & Bootstrap Lifecycle Order

> Rule ID: RULE-ARCH-004  
> Severity: blocking  
> Target Scope: lib/**  
> Category: architecture  

---

## 1. Architectural Invariant

Application initialization and session startup MUST execute in a strict, deterministic, sequential order across `lib/main.dart`, `lib/app_initializer.dart`, and `lib/core/bootstrap/app_bootstrapper.dart`:

1. **Phase 1 (Engine Binding):** `WidgetsFlutterBinding.ensureInitialized()` must be the very first instruction in `main()`.
2. **Phase 2 (Environment Secrets):** `await dotenv.load(fileName: '.env')` loads encrypted/runtime environment configuration prior to SDK setups (`RULE-SEC-001`).
3. **Phase 3 (Firebase Core):** `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` initializes multiplatform Firebase options.
4. **Phase 4 (Service Locator DI):** `await setupLocator()` registers all singletons, repositories, and services in `lib/locator.dart` (`RULE-ARCH-002`).
5. **Phase 5 (Synchronous Runtime Init):** `await AppInitializer.initialize()` executes pre-startup device checks, persists language, and restores theme selections.
6. **Phase 6 (UI Render & Async Warmup):** `runApp(const MyApp())` mounts the widget tree, followed by asynchronous non-blocking dataset preloading via `locator<AppBootstrapper>().warmUp()`.

Under no circumstances shall:
1. `runApp()` be called before Phases 1 through 5 successfully complete.
2. Dependencies be resolved before `setupLocator()` has completed execution.
3. Background warmup (`AppBootstrapper`) block the initial UI paint.
4. Services perform unhandled asynchronous initialization in static class fields or widget constructors.

---

## 2. Rationale & Failure Impact

- **Race Condition Prevention:** Calling Firebase or Firestore APIs before `WidgetsFlutterBinding.ensureInitialized()` or `Firebase.initializeApp()` crashes on native platforms with missing channel bindings.
- **Environment Safety:** If the service locator or repositories attempt to resolve API endpoints or database credentials before `dotenv.load()` completes, environment variables evaluate to empty strings, triggering authentication failures or corrupt client connections.
- **Immediate First Contentful Paint (FCP):** Executing heavy dataset queries synchronously before `runApp()` produces a blank white or black splash screen. By separating synchronous runtime setup (`AppInitializer`) from non-blocking background cache preloading (`AppBootstrapper`), the app renders its interactive UI instantly while warming up data from disk cache.

---

## 3. Compliant Pattern (DO)

Entry point coordinates the startup lifecycle deterministically:

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'app_initializer.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'core/bootstrap/app_bootstrapper.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Phase 1: Engine Binding
  WidgetsFlutterBinding.ensureInitialized();

  // Phase 2: Environment Configuration
  await dotenv.load(fileName: '.env');

  // Phase 3: Firebase Core
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Phase 4: Central Service Locator DI
  await setupLocator();

  // Phase 5: Runtime Pre-Startup Initializer
  await AppInitializer.initialize();

  // Phase 6: Render UI
  runApp(const MyApp());

  // Post-Paint: Background Cache Preloading
  locator<AppBootstrapper>().warmUp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = locator<NotificationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<LocaleProvider>()),
        ChangeNotifierProvider.value(value: locator<ThemeProvider>()),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProv, themeProv, _) {
          return MaterialApp(
            navigatorKey: notificationService.navigatorKey,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: themeProv.themeMode,
            locale: localeProv.currentLanguage.locale,
            home: const Scaffold(body: Center(child: Text('Climatica'))),
          );
        },
      ),
    );
  }
}
```

Background warm-up runs concurrently and handles failure defensively:

```dart
// lib/core/bootstrap/app_bootstrapper.dart
import '../utils/debug_logger.dart';

/// Preloads critical offline cache data concurrently without blocking UI startup.
class AppBootstrapper {
  bool _isWarmedUp = false;

  bool get isWarmedUp => _isWarmedUp;

  /// Warm up local datasets asynchronously.
  Future<void> warmUp() async {
    try {
      await Future.wait([
        _preloadStations(),
        _preloadAlerts(),
      ]);
      _isWarmedUp = true;
    } catch (e, stack) {
      DebugLogger.error('AppBootstrapper warmup error', error: e, stackTrace: stack);
    }
  }

  Future<void> _preloadStations() async {
    // Read from local cache without blocking
  }

  Future<void> _preloadAlerts() async {
    // Read alerts cache
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Scrambling initialization phases or running blocking I/O before `runApp()`:

```dart
// BAD: Unordered startup and blocking warmup
void main() {
  // VIOLATION: Missing WidgetsFlutterBinding.ensureInitialized()

  // VIOLATION: Calling runApp before dependencies and Firebase are initialized
  runApp(const BadApp());

  // VIOLATION: Async operations executed after runApp without proper chaining
  Firebase.initializeApp();
  setupLocator();
}

// BAD: Synchronously blocking runApp on network or heavy disk warmup
Future<void> badMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  // VIOLATION: Awaiting network fetch or heavy dataset warmup BEFORE runApp
  // This causes severe app launch lag (ANR / slow startup penalty)
  await locator<StationRepository>().fetchEntireDatabaseOverNetwork();

  runApp(const MyApp());
}
```

---

## 5. Automated Validation & Audit Procedure

Execute the following commands to detect violations of this rule:

```bash
# 1. Verify main.dart has WidgetsFlutterBinding before any async calls
head -n 25 lib/main.dart | grep -n "WidgetsFlutterBinding.ensureInitialized()"

# 2. Check for missing setupLocator invocation in main.dart
grep -n "setupLocator()" lib/main.dart

# 3. Check for blocking warmup calls before runApp in main.dart
rg "await.*warmUp" lib/main.dart
```

If `warmUp()` is awaited prior to `runApp()`, change it to run unawaited immediately after `runApp()`.
