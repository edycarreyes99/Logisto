---
id: RULE-UI-005
title: Decoupled UI Notification Service Architecture
category: presentation
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Decoupled UI Notification Service Architecture

> Rule ID: RULE-UI-005  
> Severity: blocking  
> Target Scope: lib/**  
> Category: presentation  

---

## 1. Architectural Invariant

All cross-cutting UI notification dialogs, modal loading overlays, error alerts, and floating toast snackbars MUST be dispatched exclusively through the centralized `NotificationService` (`lib/core/services/notification_service.dart`) resolved via `locator<NotificationService>()`.

Under no circumstances shall:
1. `BuildContext` be passed as a method parameter into Domain services, use cases, Data repositories, or background tasks for the purpose of showing dialogs, snackbars, or alerts.
2. Feature screens invoke raw `showDialog()`, `showModalBottomSheet()`, or `ScaffoldMessenger.of(context).showSnackBar()` directly with ad-hoc styling.
3. Domain services or repositories instantiate or trigger presentation-tier overlays directly.
4. Notification strings be hardcoded as raw string literals instead of localized resources accessed through `AppLocalizations`.

---

## 2. Rationale & Failure Impact

- **Layer Decoupling:** Passing `BuildContext` into domain services or repositories creates an unlawful dependency from business logic onto the Flutter UI rendering engine (`RULE-ARCH-001`). If a long-running async operation outlives the widget tree, calling `ScaffoldMessenger.of(context)` causes runtime exceptions (`Looking up a deactivated widget's ancestor is unsafe`).
- **Consistent Design System & Styling:** Direct `showDialog` or `showSnackBar` calls frequently introduce visual drift (inconsistent border radiuses, un-themed surface colors, mismatched typography, or unlocalized button texts). `NotificationService` guarantees universal compliance with `AppColors`, `AppDimens`, and `AppTextStyles`.
- **Testability:** Decoupled notifications allow domain services and providers to be tested in pure unit tests by substituting or asserting on `NotificationService` method invocations without mounting widget test harnesses.

---

## 3. Compliant Pattern (DO)

NotificationService encapsulates global navigation key access and post-frame UI dispatching:

```dart
// lib/core/services/notification_service.dart
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

  /// Displays a localized success snackbar toast notification.
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

Registered in `lib/locator.dart` and consumed from providers:

```dart
// lib/presentation/stations/station_form_provider.dart
import 'package:flutter/foundation.dart';
import '../../core/services/notification_service.dart';
import '../../domain/services/station_service.dart';

class StationFormProvider extends ChangeNotifier {
  final StationService _service;
  final NotificationService _notifications;

  StationFormProvider(this._service, this._notifications);

  Future<void> submit() async {
    _notifications.showLoading();
    try {
      await _service.saveStation(/* ... */);
      _notifications.hideLoading();
      _notifications.showSuccessToast('Station created successfully');
    } catch (e) {
      _notifications.hideLoading();
      _notifications.showValidationError(
        title: 'Save Failed',
        message: e.toString(),
      );
    }
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Passing `BuildContext` deep into service layers or invoking raw un-themed snackbars in screens:

```dart
// BAD: Passing BuildContext into Domain Service
class BadDomainService {
  // VIOLATION: Domain method taking BuildContext
  Future<void> executeTask(BuildContext context) async {
    // VIOLATION: Triggering UI overlay directly inside domain
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operation complete')),
    );
  }
}

// BAD: Ad-hoc un-themed dialog invocation inside presentation screen
class BadScreen extends StatelessWidget {
  const BadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Delete',
      onPressed: () {
        // VIOLATION: Raw showDialog with hardcoded styling instead of NotificationService
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to perform delete'),
          ),
        );
      },
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Execute the following commands to detect violations of this rule:

```bash
# 1. Ensure BuildContext is never imported or referenced in domain/ or data/
rg "BuildContext" lib/domain/ lib/data/

# 2. Check for raw showDialog invocations in presentation screens
rg "showDialog\(" lib/presentation/ \
  --glob '!lib/core/services/notification_service.dart'

# 3. Check for raw ScaffoldMessenger calls in presentation screens
rg "ScaffoldMessenger\.of" lib/presentation/ \
  --glob '!lib/core/services/notification_service.dart'
```

If any matches are detected outside `lib/core/services/notification_service.dart`, refactor the invocation to use `locator<NotificationService>()`.
