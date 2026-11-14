import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Centralized UI feedback orchestrator providing consistent, accessible,
/// and visually prominent Material 3 notifications (Success, Warning, Error, Info).
class AppFeedback {
  AppFeedback._();

  /// Displays a floating success feedback alert with checkmark icon and emerald green accent.
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showFloatingNotification(
      context: context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      icon: Icons.check_circle_rounded,
      accentColor: AppColors.success,
      backgroundColor: const Color(0xFF0F2E1E),
      foregroundColor: Colors.white,
    );
  }

  /// Displays a floating error feedback alert with error icon and crimson accent.
  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showFloatingNotification(
      context: context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      icon: Icons.error_rounded,
      accentColor: AppColors.error,
      backgroundColor: const Color(0xFF3B1215),
      foregroundColor: Colors.white,
    );
  }

  /// Displays a floating warning feedback alert with amber accent.
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showFloatingNotification(
      context: context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.warning,
      backgroundColor: const Color(0xFF382405),
      foregroundColor: Colors.white,
    );
  }

  /// Displays a floating informational feedback alert with cyan accent.
  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showFloatingNotification(
      context: context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      icon: Icons.info_outline_rounded,
      accentColor: AppColors.info,
      backgroundColor: const Color(0xFF0A2540),
      foregroundColor: Colors.white,
    );
  }

  static void _showFloatingNotification({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color accentColor,
    required Color backgroundColor,
    required Color foregroundColor,
    String? title,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    try {
      messenger.removeCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: duration,
          elevation: 6.0,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          content: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.25),
                  blurRadius: 12.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 22.0),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null && title.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: foregroundColor,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          action: action,
        ),
      );
    } catch (_) {
      // Ignored when no descendant Scaffold is present (e.g., isolated test harnesses)
    }
  }
}
