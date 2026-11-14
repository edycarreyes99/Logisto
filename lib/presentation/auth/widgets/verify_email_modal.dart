import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../login_provider.dart';

/// Modal or screen prompting user to verify their email address via Firebase Authentication.
class VerifyEmailModal extends StatefulWidget {
  final LoginProvider provider;
  final VoidCallback onVerified;

  const VerifyEmailModal({
    super.key,
    required this.provider,
    required this.onVerified,
  });

  @override
  State<VerifyEmailModal> createState() => _VerifyEmailModalState();
}

class _VerifyEmailModalState extends State<VerifyEmailModal> {
  bool _isChecking = false;
  bool _isSending = false;

  Future<void> _resendVerification() async {
    setState(() => _isSending = true);
    final l10n = AppLocalizations.of(context)!;
    final sent = await widget.provider.sendEmailVerification();
    setState(() => _isSending = false);

    if (!mounted) return;
    if (sent) {
      AppFeedback.showSuccess(context, l10n.verificationEmailSent);
    } else {
      AppFeedback.showError(
        context,
        widget.provider.errorMessage ?? 'Error enviando correo de verificación.',
      );
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _isChecking = true);
    final isVerified = await widget.provider.checkEmailVerified();
    setState(() => _isChecking = false);

    if (!mounted) return;
    if (isVerified) {
      widget.onVerified();
    } else {
      final l10n = AppLocalizations.of(context)!;
      AppFeedback.showWarning(context, l10n.emailNotVerifiedYet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final email = widget.provider.currentUserEmail ?? 'su correo';

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        margin: const EdgeInsets.all(24.0),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_unread_rounded,
                  size: 40.0,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              l10n.verifyEmailTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              l10n.verifyEmailPrompt(email),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28.0),
            FilledButton.icon(
              onPressed: _isChecking ? null : _checkVerification,
              icon: _isChecking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: Text(l10n.iHaveVerified),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 12.0),
            OutlinedButton.icon(
              onPressed: _isSending ? null : _resendVerification,
              icon: _isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(l10n.resendVerificationEmail),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () => widget.provider.signOut(),
              child: Text(
                l10n.logout,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
