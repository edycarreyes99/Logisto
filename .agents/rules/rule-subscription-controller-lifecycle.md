---
id: RULE-PERF-001
title: Subscription Cancellation and Controller Lifecycle Disposal
category: quality
severity: critical
scope:
  include:
    - "lib/presentation/**"
    - "lib/core/validators/**"
    - "lib/core/providers/**"
  exclude:
    - "test/**"
---

# Subscription Cancellation and Controller Lifecycle Disposal

> Rule ID: RULE-PERF-001  
> Severity: critical  
> Target Scope: lib/presentation/**, lib/core/validators/**, lib/core/providers/**  
> Category: quality  

---

## 1. Architectural Invariant

All asynchronous stream subscriptions (`StreamSubscription`), UI controllers (`TextEditingController`, `ScrollController`, `AnimationController`, `PageController`), and interactive `FocusNode` instances MUST be explicitly cancelled or disposed of when their enclosing widget or provider is unmounted or disposed.

Under no circumstances shall:
1. A `ChangeNotifier` state provider subscribe to real-time Firestore streams without retaining a `StreamSubscription` reference and cancelling it inside its `dispose()` override.
2. A `StatefulWidget` or `BaseValidator` instantiate a `TextEditingController`, `FocusNode`, or animation ticker without releasing it in `dispose()`.
3. An asynchronous stream listener dispatch notifications (`notifyListeners()`) without verifying `if (hasListeners)` or handling unmounted widget state.
4. Stateless widgets establish long-lived stream listeners that cannot be cancelled when the widget leaves the element tree.

---

## 2. Rationale & Failure Impact

- **Memory Leak Elimination:** In multiplatform applications (particularly long-running Desktop and Flutter Web single-page apps), dangling stream subscriptions keep entire view hierarchies, providers, and models retained in memory indefinitely.
- **Zombie Listener Prevention:** Uncancelled Firestore snapshot listeners continue consuming network bandwidth and battery, processing document changes in background tabs, and executing stale callbacks.
- **Failure Impact:** Unclosed controllers and listeners trigger `Unhandled Exception: A ChangeNotifier was used after being disposed` or `Looking up a deactivated widget's ancestor`, crashing release builds and degrading browser tab performance.

---

## 3. Compliant Pattern (DO)

Always retain subscriptions, cancel them deterministically on cleanup, and dispose all instantiated controllers:

```dart
// lib/presentation/stations/stations_provider.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/models/station_model.dart';
import '../../domain/services/station_service.dart';

class StationsProvider extends ChangeNotifier {
  final StationService _service;
  StreamSubscription<List<StationModel>>? _stationsSubscription;
  List<StationModel> _stations = const [];

  StationsProvider({required StationService service}) : _service = service;

  List<StationModel> get stations => _stations;

  void initialize() {
    // Cancel any previous subscription before re-subscribing
    _stationsSubscription?.cancel();
    _stationsSubscription = _service.watchStations().listen(
      (data) {
        _stations = data;
        if (hasListeners) {
          notifyListeners();
        }
      },
      onError: (_) {
        if (hasListeners) {
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    // Mandatory cancellation of active stream listener
    _stationsSubscription?.cancel();
    _stationsSubscription = null;
    super.dispose();
  }
}
```

In widgets with local text editing or scroll controllers:

```dart
// In StatefulWidget:
class _StationSearchFieldState extends State<StationSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Subscribing to streams without storing or cancelling the subscription, or leaving controllers un-disposed:

```dart
// BAD: Leaking stream listeners and unclosed controllers
class BadProvider extends ChangeNotifier {
  final StationService _service;

  BadProvider(this._service);

  void listenToData() {
    // VIOLATION: Unretained subscription! Runs forever in memory even after provider disposal!
    _service.watchStations().listen((data) {
      notifyListeners(); // VIOLATION: Calling notifyListeners() after dispose throws crash exception!
    });
  }

  // VIOLATION: Missing dispose() override to clean up active listeners!
}
```

---

## 5. Automated Validation & Audit Procedure

Scan providers and state classes for uncancelled subscriptions and missing controller disposals:

```bash
# 1. Verify StreamSubscription variables are accompanied by dispose cancellation
rg --glob 'lib/presentation/**/*_provider.dart' 'StreamSubscription'

# 2. Audit StatefulWidget state classes for TextEditingController instantiation without dispose
python3 -c "
import pathlib, re

for f in pathlib.Path('lib/presentation').rglob('*.dart'):
    content = f.read_text(encoding='utf-8')
    if 'TextEditingController' in content and 'dispose()' not in content:
        print(f'FAIL: {f} instantiates TextEditingController without dispose() lifecycle cleanup.')
"
```

Expected output: 0 lifecycle disposal violations.
