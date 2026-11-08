---
name: provider-state-management
description: |
  Procedural guide for reactive state management using ChangeNotifier and Provider.
  Enforces status-enum driven lifecycles, optimistic updates, and decoupled UI notifications.
  Mandatory trigger conditions:
  - Trigger when implementing or refactoring ChangeNotifier state controllers or providers in Flutter.
  - Trigger when wiring reactive state consumption with AnimatedBuilder or ListenableBuilder.
  Do NOT trigger when:
  - Do not trigger for purely static UI layouts without dynamic state.
  - Do not trigger for database repository implementations without state controllers.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Reactive Provider State Management Architecture

> Standard: Production ChangeNotifier & Status-Driven State Architecture  
> Scope: lib/presentation/, lib/core/providers/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill prescribes the reactive state management architecture across Flutter applications using `ChangeNotifier` and `provider`. It eliminates ad-hoc `setState()` sprawl by enforcing status-enum-driven state transitions (`initial`, `loading`, `loaded`, `error`), guarantees selective subtree rebuilding via `AnimatedBuilder`, and orchestrates optimistic mutations while decoupling notification toasts via `NotificationService`.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Creating catalog, detail, or dashboard feature controllers.
- Managing asynchronous data loading states and error recovery.
- Implementing optimistic mutations that reflect locally before network confirmation.

### 2.2. When to Avoid This Skill
- Storing immutable domain models or business entity schemas.
- Configuring database connection settings or security rules.
- Writing unit tests for pure domain use cases without state listeners.

---

## 3. Pre-Flight Verification (Step 0)

Verify `provider` is installed in `pubspec.yaml`:

```bash
# Verify provider dependency
grep 'provider' pubspec.yaml
```

Confirm that status enums (e.g. `FeatureStatusEnum`, `FormSubmissionStatusEnum`) exist in `lib/core/enums/`.

---

## 4. Canonical Specification & Standards

### 4.1. File Layout
```
lib/core/
├── enums/
│   ├── feature_status_enum.dart         # initial, loading, loaded, error
│   └── form_submission_status_enum.dart # idle, submitting, success, error
└── services/
    └── notification_service.dart        # Decoupled UI notification toast/alert handler

lib/presentation/[feature]/
├── [feature]_provider.dart              # Catalog state controller
└── [feature]_screen.dart                # View consuming provider via AnimatedBuilder
```

### 4.2. Invariant Rules
- Controllers MUST NEVER trigger `notifyListeners()` during the widget `build()` phase.
- Controllers MUST check `hasListeners` before dispatching updates in asynchronous completions.
- Providers MUST NOT store `BuildContext` references; notifications are dispatched via `NotificationService`.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Define Feature Status Enum
Create `lib/core/enums/feature_status_enum.dart`:

```dart
/// Strongly-typed state status enum for catalog and feature views.
enum FeatureStatusEnum {
  /// Idle state prior to initialization.
  idle,

  /// Asynchronous data retrieval in progress.
  loading,

  /// Data stream loaded and active.
  loaded,

  /// Operation completed successfully.
  success,

  /// Operational error encountered.
  error;

  bool get isLoading => this == FeatureStatusEnum.loading;
  bool get isLoaded => this == FeatureStatusEnum.loaded;
  bool get isError => this == FeatureStatusEnum.error;
}
```

### Step 2: Implement Decoupled Notification Service
Create `lib/core/services/notification_service.dart`:

```dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_text_styles.dart';

/// Decoupled notification service executing UI dialogs and overlays globally.
class NotificationService {
  /// Global navigator key configured on root MaterialApp.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get _context => navigatorKey.currentContext!;

  /// Resolves the active [AppLocalizations] instance from root context.
  AppLocalizations get l10n => AppLocalizations.of(_context)!;

  bool _loadingVisible = false;

  /// Displays a modal, non-dismissible loading overlay dialog.
  void showLoading({String? message}) {
    if (_loadingVisible) return;
    _loadingVisible = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loadingVisible) return;
      showDialog(
        context: _context,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        builder: (_) => PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColors.surfaceOf(_context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      message ?? l10n.loadingMessage,
                      style: AppTextStyles.bodyMedium(color: AppColors.textPrimaryOf(_context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Dismisses the active loading overlay dialog, if visible.
  void hideLoading() {
    if (!_loadingVisible) return;
    _loadingVisible = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(_context, rootNavigator: true).pop();
    });
  }

  /// Displays an alert dialog for validation or operational errors.
  void showValidationError({required String title, required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: _context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surfaceOf(_context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radius)),
          title: Text(title, style: AppTextStyles.titleLargeBold(color: AppColors.textPrimaryOf(_context))),
          content: Text(message, style: AppTextStyles.bodyMedium(color: AppColors.textPrimaryOf(_context))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(_context),
              child: Text(l10n.accept, style: AppTextStyles.bodyMediumBold(color: AppColors.primary)),
            ),
          ],
        ),
      );
    });
  }

  /// Displays an ephemeral success snackbar toast notification.
  void showSuccessToast(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(message, style: AppTextStyles.bodyMediumBold(color: Colors.white)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusSm)),
        ),
      );
    });
  }
}
```

### Step 3: Implement Reactive Feature Provider
Implement the state controller:

```dart
// lib/presentation/stations/stations_provider.dart
import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/services/notification_service.dart';
import '../../domain/models/station_model.dart';
import '../../domain/services/station_service.dart';

class StationsProvider extends ChangeNotifier {
  final StationService _service;
  final NotificationService _notificationService;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  List<StationModel> _items = const [];
  String? _errorMessage;

  StationsProvider({
    required StationService service,
    required NotificationService notificationService,
  })  : _service = service,
        _notificationService = notificationService;

  FeatureStatusEnum get status => _status;
  List<StationModel> get items => _items;
  String? get errorMessage => _errorMessage;

  void initialize() {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    _service.watchStations().listen(
      (data) {
        _items = data;
        _status = FeatureStatusEnum.loaded;
        if (hasListeners) notifyListeners();
      },
      onError: (e) {
        _errorMessage = e.toString();
        _status = FeatureStatusEnum.error;
        _notificationService.showValidationError(
          title: _notificationService.l10n.errorTitle,
          message: _notificationService.l10n.unexpectedErrorOccurred,
        );
        if (hasListeners) notifyListeners();
      },
    );
  }
}
```

### Step 4: Consume in View with AnimatedBuilder
Render UI reactively based on enum state without rebuilding whole trees:

```dart
// lib/presentation/stations/stations_view.dart
import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../l10n/app_localizations.dart';
import 'stations_provider.dart';
import 'widgets/stations_grid.dart';

class StationsView extends StatelessWidget {
  final StationsProvider provider;

  const StationsView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: provider,
      builder: (context, _) {
        return switch (provider.status) {
          FeatureStatusEnum.idle || FeatureStatusEnum.loading => const Center(
              child: CircularProgressIndicator(),
            ),
          FeatureStatusEnum.error => Center(
              child: AppEmptyState(
                title: l10n.errorTitle,
                message: l10n.unexpectedErrorOccurred,
                actionText: l10n.retry,
                onActionPressed: provider.initialize,
              ),
            ),
          FeatureStatusEnum.loaded || FeatureStatusEnum.success => provider.items.isEmpty
              ? AppEmptyState(
                  title: l10n.noDataTitle,
                  message: l10n.noDataMessage,
                  actionText: l10n.retry,
                  onActionPressed: provider.initialize,
                )
              : StationsGrid(stations: provider.items),
        };
      },
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Asynchronous callback arrives after widget unmount | Exception: `notifyListeners() called after dispose()` | Check `if (hasListeners) notifyListeners();` before notifying. |
| BuildContext passed to Provider async method | `Looking up a deactivated widget's ancestor` error | Pass localized text strings directly into provider methods rather than `BuildContext`. |
| Network disconnects during mutation | Optimistic state out of sync | Catch repository exceptions, revert local item state, and emit error notification toast. |

---

## 7. Verification & Quality Gates

Run checks to confirm state management hygiene:

```bash
# Verify providers do not import BuildContext
rg --glob 'lib/presentation/**/*_provider.dart' 'BuildContext'
```

Checklist (see full [references/state-management-validation-checklist.md](references/state-management-validation-checklist.md)):
- [ ] Provider state is driven by strongly-typed status enums.
- [ ] Views consume providers using `AnimatedBuilder` or scoped listeners.
- [ ] UI notifications are decoupled through `NotificationService`.
- [ ] Providers check `hasListeners` before notifying.
- [ ] 100% English code and documentation comments.
