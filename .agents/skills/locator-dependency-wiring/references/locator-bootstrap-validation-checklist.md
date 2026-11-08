# Service Locator Wiring & App Bootstrap Lifecycle Validation Checklist

> Standard: Centralized Dependency Injection (GetIt) and Deterministic Startup Warmup  
> Governed Rules: [../../../rules/rule-service-locator-di.md](../../../rules/rule-service-locator-di.md), [../../../rules/rule-app-startup-bootstrap-lifecycle.md](../../../rules/rule-app-startup-bootstrap-lifecycle.md)  
> Scope: lib/locator.dart, lib/main.dart, lib/app_initializer.dart, lib/core/bootstrap/**  

---

## 1. Centralized Dependency Registration (`lib/locator.dart`)
- [ ] All singletons, repositories, services, and state providers are registered in `lib/locator.dart` via `GetIt`.
- [ ] Zero manual ad-hoc instantiations (`new SomeService()`, `SomeRepository()`) inside UI screens or widgets.
- [ ] Repositories and domain services are registered as lazy singletons (`registerLazySingleton`).
- [ ] Core infrastructure clients (`FirebaseFirestore`, `AppCollections`) are registered as singletons.
- [ ] Asynchronous dependencies (`AuthPreferences.getInstance()`) use `registerSingletonAsync` and await `isReady`.
- [ ] Transient form providers are registered as factories (`registerFactory`) to prevent stale state retention across navigation flows.
- [ ] All dependencies are passed via constructor injection rather than global `locator<T>()` lookups inside class bodies.
- [ ] A clean test reset method (`locator.reset()`) is available and used in unit test `tearDown()` blocks.

## 2. Deterministic Startup Sequence (`lib/main.dart`)
- [ ] The application startup sequence in `lib/main.dart` executes in strict deterministic order:
  1. `WidgetsFlutterBinding.ensureInitialized()` executes first.
  2. `dotenv.load(fileName: '.env')` loads secrets.
  3. `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` configures platform Firebase.
  4. `setupLocator()` registers all dependencies and awaits asynchronous singletons.
  5. `AppInitializer.initializeAppSettings()` loads cached theme mode and locale.
  6. `runApp(const MyApp())` mounts the widget tree immediately.
- [ ] First Contentful Paint (FCP) is immediate; zero synchronous blocking database queries before `runApp()`.

## 3. Concurrent Cache Preloading & Bootstrapper Warmup
- [ ] Background dataset preloading is encapsulated in `lib/core/bootstrap/app_bootstrapper.dart`.
- [ ] Warmup triggers concurrently post-paint or upon verified user session detection.
- [ ] Multiple dataset queries execute in parallel using `Future.wait` rather than sequential blocking awaits.
- [ ] `AppBootstrapper.init()` wraps warmup operations in defensive `try / catch` blocks to prevent unhandled startup crashes.
- [ ] Warmup failures degrade gracefully without blocking navigation to the main application dashboard.
