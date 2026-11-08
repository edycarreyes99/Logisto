---
id: RULE-ARCH-003
title: State Mutation and Provider Lifecycle Guardrails
category: architecture
severity: critical
scope:
  include:
    - "lib/presentation/**"
    - "lib/core/providers/**"
  exclude:
    - "test/**"
---

# State Mutation and Provider Lifecycle Guardrails

> Rule ID: RULE-ARCH-003  
> Severity: critical  
> Target Scope: lib/presentation/**, lib/core/providers/**  
> Category: architecture  

---

## 1. Architectural Invariant

State mutations and notifications (`notifyListeners()`) MUST NOT occur synchronously during Flutter's widget build phase. All state modifications MUST be triggered via user interactions, asynchronous callbacks, lifecycle hooks, or scheduled after the current frame completes using `WidgetsBinding.instance.addPostFrameCallback`.

Furthermore:
1. Feature state MUST be driven by strongly-typed status enums (e.g., `FeatureStatusEnum.idle`, `loading`, `loaded`, `success`, `error`).
2. Providers MUST guard against invocation after disposal by checking `hasListeners` or catching disposed states.
3. Views MUST consume provider states reactively using `AnimatedBuilder`, `ListenableBuilder`, or scoped `Consumer` widgets rather than blanket top-level rebuilds.

---

## 2. Rationale & Failure Impact

- **Flutter Framework Constraints:** Modifying state or notifying listeners during `Widget.build()` triggers the notorious Flutter runtime exception: `setState() or markNeedsBuild() called during build`.
- **Predictable State Transitions:** Enum-driven states eliminate impossible UI states (such as displaying both a loading spinner and an error message simultaneously).
- **Failure Impact:** Synchronous build-time mutations cause frame drops, infinite rebuild loops, red-screen crash crashes on release builds, and erratic UI rendering across desktop and web window resizing.

---

## 3. Compliant Pattern (DO)

Schedule lifecycle initializations via post-frame callbacks or separate event dispatchers, and track operational state with an enum:

```dart
// lib/core/enums/feature_status_enum.dart
/// Strongly-typed state status enum for catalog and feature views.
enum FeatureStatusEnum {
  idle,
  loading,
  loaded,
  success,
  error;

  bool get isLoading => this == FeatureStatusEnum.loading;
  bool get isLoaded => this == FeatureStatusEnum.loaded;
  bool get isError => this == FeatureStatusEnum.error;
}

// lib/presentation/items/item_provider.dart
import 'package:flutter/foundation.dart';

class ItemProvider extends ChangeNotifier {
  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;

  void initialize() {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      // Load data asynchronously
      _status = FeatureStatusEnum.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
      notifyListeners();
    }
  }
}

// In feature screen:
class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  late final ItemProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = locator<ItemProvider>();
    // Safe post-frame deferred initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _provider,
      builder: (context, _) {
        switch (_provider.status) {
          case FeatureStatusEnum.idle:
          case FeatureStatusEnum.loading:
            return const Center(child: CircularProgressIndicator());
          case FeatureStatusEnum.error:
            return Center(child: Text(_provider.errorMessage ?? l10n.unexpectedErrorOccurred));
          case FeatureStatusEnum.loaded:
          case FeatureStatusEnum.success:
            return const ItemContentWidget();
        }
      },
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Invoking methods that call `notifyListeners()` directly inside the `build` method or widget body:

```dart
// BAD: Mutating state directly inside build()
class BadScreen extends StatelessWidget {
  const BadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = locator<ItemProvider>();

    // VIOLATION: Calling initialize() during build() throws markNeedsBuild() exception!
    provider.initialize();

    return Text('Status: ${provider.status}');
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan presentation build methods for synchronous provider mutations:

```bash
# Verify no direct provider method invocations inside build signatures
rg --glob 'lib/presentation/**' 'Widget build\(BuildContext context\)\s*\{[^}]*provider\.[a-zA-Z]+\('
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
