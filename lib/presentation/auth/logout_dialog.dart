import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../context/business_context_provider.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import 'login_provider.dart';

/// Shows an enterprise logout confirmation dialog and executes session termination.
/// Clears credentials, clears business unit context, routes back to login screen,
/// and displays user feedback.
Future<bool> showLogoutDialog(
  BuildContext context, {
  VoidCallback? onBeforeLogout,
}) async {
  final l10n = AppLocalizations.of(context);
  final logoutTitle = l10n?.logout ?? 'Cerrar Sesión';
  final confirmMsg = l10n?.logoutConfirmation ??
      '¿Está seguro de que desea cerrar la sesión actual?';
  final cancelLabel = l10n?.cancel ?? 'Cancelar';
  final confirmLabel = l10n?.confirm ?? 'Confirmar';
  final isEnglish = l10n?.localeName == 'en';
  final feedbackMsg = isEnglish
      ? 'Session ended successfully.'
      : 'Sesión finalizada correctamente.';
  final theme = Theme.of(context);

  var isSubmitting = false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_rounded, color: theme.colorScheme.error, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(logoutTitle, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        content: Text(confirmMsg),
        actions: [
          TextButton(
            onPressed: isSubmitting ? null : () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: isSubmitting
                ? null
                : () {
                    setState(() => isSubmitting = true);
                    Navigator.of(ctx).pop(true);
                  },
            child: isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(confirmLabel),
          ),
        ],
      ),
    ),
  );

  if (confirmed == true) {
    if (context.mounted) {
      try {
        onBeforeLogout?.call();
      } catch (_) {}
    }

    final login = locator.isRegistered<LoginProvider>()
        ? locator<LoginProvider>()
        : null;
    final contextProvider = locator.isRegistered<BusinessContextProvider>()
        ? locator<BusinessContextProvider>()
        : null;
    final navProvider = locator.isRegistered<NavigationProvider>()
        ? locator<NavigationProvider>()
        : null;

    try {
      await login?.signOut();
      await contextProvider?.clearContext();
    } catch (_) {}

    navProvider?.navigateTo(AppRoutes.login);

    if (context.mounted) {
      AppFeedback.showInfo(context, feedbackMsg, title: logoutTitle);
    }
    return true;
  }
  return false;
}
