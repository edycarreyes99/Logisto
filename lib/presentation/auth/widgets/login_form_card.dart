import 'package:flutter/material.dart';
import '../../../core/enums/feature_status_enum.dart';
import '../../../core/enums/validation_error_enum.dart';
import '../../../core/validators/text_field_validator.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../login_provider.dart';

/// Clean, minimal authentication form card conforming to Treinta design guidelines.
/// Includes branding logo, dual corporate slogans, validated inputs, session memory,
/// and Firebase Auth submission.
class LoginFormCard extends StatefulWidget {
  final LoginProvider provider;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const LoginFormCard({
    super.key,
    required this.provider,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  bool _isSignUpMode = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  final TextEditingController _nameController = TextEditingController();
  final EmailValidator _emailValidator = EmailValidator();
  final PasswordPolicyValidator _passwordValidator = PasswordPolicyValidator();
  String? _clientValidationError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailValidator.dispose();
    _passwordValidator.dispose();
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
            Expanded(
              child: Text(
                l10n.forgotPasswordPrompt,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
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

  void _submitLogin() {
    final l10n = AppLocalizations.of(context)!;
    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _clientValidationError = l10n.authErrorEmailPasswordRequired);
      return;
    }

    if (_emailValidator.validate(email) != ValidationErrorEnum.none) {
      setState(() => _clientValidationError = l10n.emailInvalidFormat);
      return;
    }

    setState(() => _clientValidationError = null);
    widget.onLogin();
  }

  Future<void> _handleSignUp() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _clientValidationError = l10n.authErrorEmailPasswordRequired);
      return;
    }

    if (_emailValidator.validate(email) != ValidationErrorEnum.none) {
      setState(() => _clientValidationError = l10n.emailInvalidFormat);
      return;
    }

    if (_passwordValidator.validate(password) != ValidationErrorEnum.none) {
      setState(() => _clientValidationError = l10n.passwordRequirementsPrompt);
      return;
    }

    setState(() => _clientValidationError = null);
    final success = await widget.provider.registerWithEmailPassword(
      email: email,
      password: password,
      displayName: name,
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

    return Card(
      elevation: isDark ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: isDark ? 0.3 : 0.6),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBrandingHeader(theme, l10n),
            const SizedBox(height: 24.0),
            if (_clientValidationError != null || widget.provider.errorMessage != null) ...[
              _buildErrorAlert(theme, l10n),
              const SizedBox(height: 16.0),
            ],
            ..._buildInputFields(theme, l10n),
            const SizedBox(height: 12.0),
            if (!_isSignUpMode) ...[
              _buildOptionsRow(theme, l10n),
              const SizedBox(height: 20.0),
            ] else
              const SizedBox(height: 12.0),
            _buildActionButtons(theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingHeader(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          width: 52.0,
          height: 52.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 28.0,
          ),
        ),
        const SizedBox(height: 14.0),
        Text(
          'Logisto',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          l10n.loginPrimarySlogan,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          l10n.loginSecondarySlogan,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.3,
          ),
        ),
      ],
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
        onSubmitted: (_) => _isSignUpMode ? _handleSignUp() : _submitLogin(),
      ),
    ];
  }

  Widget _buildOptionsRow(ThemeData theme, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Row(
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
              const SizedBox(width: 6.0),
              Flexible(
                child: GestureDetector(
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  child: Text(
                    l10n.rememberMe,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        TextButton(
          onPressed: _showForgotPasswordDialog,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
    final message = _clientValidationError ??
        (widget.provider.errorCode == 'email_password_required'
            ? l10n.authErrorEmailPasswordRequired
            : (widget.provider.errorMessage ?? l10n.invalidCredentials));

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
              message,
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
          child: FilledButton(
            onPressed: isLoading ? null : (_isSignUpMode ? _handleSignUp : _submitLogin),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 0.0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _isSignUpMode ? l10n.signUp : l10n.login,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
          ),
        ),
        const SizedBox(height: 12.0),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _isSignUpMode = !_isSignUpMode;
                _clientValidationError = null;
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
      ],
    );
  }
}
