import 'package:flutter/material.dart';
import '../../../core/enums/feature_status_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../login_provider.dart';

/// Highly attractive, modern credentials submission card with password visibility toggle,
/// Firebase Auth sign-in, account creation (sign up), password reset dialog, and email verification.
class LoginFormCard extends StatefulWidget {
  final LoginProvider provider;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onFastPin;
  final VoidCallback onRegisterOrg;

  const LoginFormCard({
    super.key,
    required this.provider,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onFastPin,
    required this.onRegisterOrg,
  });

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  bool _isSignUpMode = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog() {
    final l10n = AppLocalizations.of(context)!;
    final resetEmailController = TextEditingController(text: widget.emailController.text);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_reset_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 22.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              l10n.forgotPasswordPrompt,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.forgotPasswordDesc,
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: resetEmailController,
              decoration: InputDecoration(
                labelText: l10n.companyEmailPlaceholder,
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final email = resetEmailController.text.trim();
              if (email.isEmpty) return;
              Navigator.of(ctx).pop();
              final success = await widget.provider.sendPasswordResetEmail(email);
              if (!mounted) return;
              if (success) {
                AppFeedback.showSuccess(
                  context,
                  l10n.resetPasswordEmailSent,
                );
              } else {
                AppFeedback.showError(
                  context,
                  widget.provider.errorMessage ?? 'Error enviando correo de recuperación.',
                );
              }
            },
            child: Text(l10n.send),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignUp() async {
    final l10n = AppLocalizations.of(context)!;
    final success = await widget.provider.registerWithEmailPassword(
      email: widget.emailController.text,
      password: widget.passwordController.text,
      displayName: _nameController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      AppFeedback.showSuccess(
        context,
        l10n.accountCreatedSuccess,
      );
    } else {
      AppFeedback.showError(
        context,
        widget.provider.errorMessage ?? l10n.invalidCredentials,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 24.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    _isSignUpMode ? Icons.person_add_rounded : Icons.security_rounded,
                    color: Colors.white,
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSignUpMode ? l10n.signUp : l10n.corporatePortalLogin,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        _isSignUpMode ? l10n.signUpSubtitle : l10n.authSubtitleHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            if (widget.provider.errorMessage != null) ...[
              _buildErrorAlert(theme, l10n),
              const SizedBox(height: 16.0),
            ],
            ..._buildInputFields(theme, l10n),
            const SizedBox(height: 12.0),
            _buildOptionsRow(theme, l10n),
            const SizedBox(height: 16.0),
            _buildActionButtons(theme, l10n),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInputFields(ThemeData theme, AppLocalizations l10n) {
    return [
      if (_isSignUpMode) ...[
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.fullName,
            hintText: l10n.fullNamePlaceholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            prefixIcon: const Icon(Icons.person_outline_rounded),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16.0),
      ],
      TextField(
        controller: widget.emailController,
        decoration: InputDecoration(
          labelText: l10n.companyEmailPlaceholder,
          hintText: 'admin@logisto.io',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          prefixIcon: const Icon(Icons.email_outlined),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 16.0),
      TextField(
        controller: widget.passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: l10n.passwordLabel,
          hintText: '••••••••',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              size: 20.0,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            tooltip: _obscurePassword ? l10n.showPassword : l10n.hidePassword,
          ),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _isSignUpMode ? _handleSignUp() : widget.onLogin(),
      ),
    ];
  }

  Widget _buildOptionsRow(ThemeData theme, AppLocalizations l10n) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        if (!_isSignUpMode)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24.0,
                width: 24.0,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (val) => setState(() => _rememberMe = val ?? true),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: Text(
                  l10n.rememberMe,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        if (!_isSignUpMode)
          TextButton(
            onPressed: _showForgotPasswordDialog,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.forgotPassword,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorAlert(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: theme.colorScheme.onErrorContainer, size: 20.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              widget.provider.errorCode == 'email_password_required'
                  ? l10n.authErrorEmailPasswordRequired
                  : widget.provider.errorMessage!,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, AppLocalizations l10n) {
    final isLoading = widget.provider.status == FeatureStatusEnum.loading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48.0,
          child: FilledButton.icon(
            onPressed: isLoading ? null : (_isSignUpMode ? _handleSignUp : widget.onLogin),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2.0,
            ),
            icon: isLoading
                ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : Icon(_isSignUpMode ? Icons.person_add_rounded : Icons.login_rounded, size: 20.0),
            label: Text(
              _isSignUpMode ? l10n.signUp : l10n.login,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _isSignUpMode = !_isSignUpMode;
              });
            },
            child: Text(
              _isSignUpMode ? l10n.alreadyHaveAccount : l10n.dontHaveAccount,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onFastPin,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                icon: const Icon(Icons.pin_rounded, size: 18.0),
                label: Text(l10n.fastPin, style: const TextStyle(fontSize: 13.0)),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onRegisterOrg,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                icon: const Icon(Icons.domain_add_rounded, size: 18.0),
                label: Text(l10n.newOrgSetup, style: const TextStyle(fontSize: 13.0)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
