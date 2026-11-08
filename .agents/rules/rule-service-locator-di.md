---
id: RULE-ARCH-002
title: Service Locator and Dependency Injection
category: architecture
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Service Locator and Dependency Injection

> Rule ID: RULE-ARCH-002  
> Severity: blocking  
> Target Scope: lib/**  
> Category: architecture  

---

## 1. Architectural Invariant

All services, repositories, clients, providers, and shared infrastructure dependencies MUST be registered and resolved centrally via `GetIt` in `lib/locator.dart`.

Under no circumstances shall:
1. Feature screens or presentation widgets instantiate services, repositories, or providers manually via `new Service()` or constructor calls.
2. Domain services or repositories instantiate low-level database clients or persistent storage handlers directly.
3. Classes create tight coupling to global singleton instances outside the centralized service locator manifest.

---

## 2. Rationale & Failure Impact

- **Testability & Mocking:** Centralized dependency injection via `GetIt` allows replacing concrete repositories and services with test doubles during unit, integration, and widget tests without altering consumer classes.
- **Single Source of Truth:** Centralizing registration ensures lifecycle control (singletons vs factories), deterministic dependency graphs, and clean initialization order during app bootstrapper warm-up.
- **Failure Impact:** Direct instantiation scatters instance lifecycles across UI files, causes memory leaks with unclosed streams or duplicated listeners, and prevents running offline mock tests.

---

## 3. Compliant Pattern (DO)

Register all abstractions and concrete implementations in `lib/locator.dart` and resolve them through `locator<T>()`:

```dart
// lib/locator.dart
import 'package:get_it/get_it.dart';
import 'data/firestore/firestore_client.dart';
import 'data/repositories/generic_item_repository.dart';
import 'domain/services/generic_item_service.dart';
import 'presentation/generic_item/generic_item_provider.dart';

final GetIt locator = GetIt.instance;

/// Sets up service locator registrations across data, domain, and presentation.
void setupLocator() {
  // Infrastructure & Data Clients
  locator.registerLazySingleton<FirestoreClient>(() => FirestoreClient());

  // Repositories
  locator.registerLazySingleton<GenericItemRepository>(
    () => GenericItemRepository(firestoreClient: locator<FirestoreClient>()),
  );

  // Domain Services
  locator.registerLazySingleton<GenericItemService>(
    () => GenericItemService(repository: locator<GenericItemRepository>()),
  );

  // Feature Providers (Factory for fresh state or LazySingleton for shared session)
  locator.registerFactory<GenericItemProvider>(
    () => GenericItemProvider(service: locator<GenericItemService>()),
  );
}

// In feature widget or screen initialization:
class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolved via locator or injected via ChangeNotifierProvider
    final provider = locator<GenericItemProvider>();
    return Container();
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Manually instantiating concrete services or repositories inside UI widgets:

```dart
// BAD: Manual constructor instantiation inside a UI widget
class BadWidget extends StatelessWidget {
  const BadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // VIOLATION: Manual ad-hoc instantiation bypasses DI and leaks memory!
    final client = FirestoreClient();
    final repo = GenericItemRepository(firestoreClient: client);
    final service = GenericItemService(repository: repo);

    return Text('Total: ${service.count()}');
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Run static code inspection to ensure no direct instantiation of services or repositories occurs in UI screens:

```bash
# Verify no direct repository or service instantiations in presentation
rg --glob 'lib/presentation/**' 'new .*Service\(|new .*Repository\(|[A-Z][a-zA-Z0-9]*Service\(|[A-Z][a-zA-Z0-9]*Repository\('
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
