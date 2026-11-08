import 'package:flutter/material.dart';

/// Decoupled notification service executing UI dialogs and overlays globally.
class NotificationService {
  /// Global navigator key configured on root MaterialApp.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext? get context => navigatorKey.currentContext;

  bool _loadingVisible = false;

  /// Displays a modal, non-dismissible loading overlay dialog.
  void showLoading({String? message}) {
    if (_loadingVisible) return;
    _loadingVisible = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loadingVisible || context == null) return;
      showDialog(
        context: context!,
        barrierDismissible: false,
        barrierColor: Colors.black45,
        builder: (_) => PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(message ?? 'Loading...'),
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
      if (context != null) {
        Navigator.of(context!, rootNavigator: true).pop();
      }
    });
  }

  /// Displays an alert dialog for validation or operational errors.
  void showValidationError({required String title, required String message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context == null) return;
      showDialog(
        context: context!,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context!),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  /// Displays an ephemeral toast notification.
  void showSuccessToast(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context == null) return;
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      );
    });
  }
}
