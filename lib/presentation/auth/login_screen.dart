import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import 'login_provider.dart';
import 'widgets/login_form_card.dart';
import 'widgets/pin_switch_modal.dart';

/// Corporate authentication screen with multi-tenant sign in,
/// fast PIN switch modal, and onboarding triggers.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginProvider _loginProvider;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginProvider = locator<LoginProvider>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final success = await _loginProvider.signInWithEmailPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      locator<NavigationProvider>().navigateTo(AppRoutes.dashboard);
    }
  }

  void _showPinModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PinSwitchModal(
        provider: _loginProvider,
        onSuccess: () =>
            locator<NavigationProvider>().navigateTo(AppRoutes.dashboard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildHeader(l10n, theme),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ListenableBuilder(
            listenable: _loginProvider,
            builder: (context, _) => BsRow(
              children: [
                BsCol(
                  config: const BsColConfig(xs: 12, md: 7, lg: 7),
                  child: _buildWelcomeBanner(l10n, theme),
                ),
                BsCol(
                  config: const BsColConfig(xs: 12, md: 5, lg: 5),
                  child: LoginFormCard(
                    provider: _loginProvider,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onLogin: _handleLogin,
                    onFastPin: _showPinModal,
                    onRegisterOrg: () => locator<NavigationProvider>()
                        .navigateTo(AppRoutes.onboarding),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return AppBar(
      title: Text(
        l10n.logistoEnterprise,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  Widget _buildWelcomeBanner(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.welcomeBannerTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.welcomeBannerDesc,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.primaryContainer,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.fastPinAlert,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
