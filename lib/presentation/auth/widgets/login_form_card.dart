import 'package:flutter/material.dart';
import '../../../core/enums/feature_status_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../login_provider.dart';

/// Credentials submission card with email, password, and fast-action buttons.
class LoginFormCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.corporatePortalLogin,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (provider.errorMessage != null) ...[
              _buildErrorAlert(theme, l10n),
              const SizedBox(height: 16),
            ],
            ..._buildInputFields(l10n),
            const SizedBox(height: 20),
            _buildActionButtons(l10n),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInputFields(AppLocalizations l10n) {
    return [
      TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: l10n.companyEmailPlaceholder,
          hintText: l10n.companyEmailPlaceholder,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: l10n.passwordLabel,
          hintText: l10n.passwordLabel,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock_outline),
        ),
      ),
    ];
  }

  Widget _buildErrorAlert(ThemeData theme, AppLocalizations l10n) {
    return Card(
      color: theme.colorScheme.errorContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          provider.errorCode == 'email_password_required'
              ? l10n.authErrorEmailPasswordRequired
              : provider.errorMessage!,
          style: TextStyle(color: theme.colorScheme.onErrorContainer),
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    final isLoading = provider.status == FeatureStatusEnum.loading;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          onPressed: isLoading ? null : onLogin,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.login),
          label: Text(l10n.login),
        ),
        OutlinedButton.icon(
          onPressed: onFastPin,
          icon: const Icon(Icons.pin_outlined),
          label: Text(l10n.fastPin),
        ),
        OutlinedButton.icon(
          onPressed: onRegisterOrg,
          icon: const Icon(Icons.domain_add),
          label: Text(l10n.newOrgSetup),
        ),
      ],
    );
  }
}
