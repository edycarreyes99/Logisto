import 'package:flutter/material.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import '../settings/settings_provider.dart';
import 'login_provider.dart';
import 'widgets/login_form_card.dart';

/// Clean, minimal authentication screen matching Treinta design aesthetics.
/// Displays single centered login/signup card with top language & theme controls.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final LoginProvider _loginProvider;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _loginProvider = locator<LoginProvider>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final nav = locator.isRegistered<NavigationProvider>()
        ? locator<NavigationProvider>()
        : null;

    final success = await _loginProvider.signInWithEmailPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      nav?.navigateTo(AppRoutes.businessUnits);
    }

    if (!mounted) return;
    if (success) {
      AppFeedback.showSuccess(
        context,
        l10n.welcomeTitle,
        title: 'Logisto',
      );
    } else {
      AppFeedback.showError(
        context,
        _loginProvider.errorMessage ?? l10n.invalidCredentials,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12.0,
              right: 16.0,
              child: _buildTopUtilityControls(theme),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440.0),
                      child: ListenableBuilder(
                        listenable: _loginProvider,
                        builder: (context, _) => LoginFormCard(
                          provider: _loginProvider,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onLogin: _handleLogin,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUtilityControls(ThemeData theme) {
    final settings = locator.isRegistered<SettingsProvider>()
        ? locator<SettingsProvider>()
        : null;

    if (settings == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.language_rounded, size: 18.0),
          label: Text(
            settings.language == LanguageEnum.es ? 'ES' : 'EN',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          onPressed: () {
            final next = settings.language == LanguageEnum.es
                ? LanguageEnum.en
                : LanguageEnum.es;
            settings.setLanguage(next);
          },
        ),
        const SizedBox(width: 4.0),
        IconButton(
          icon: Icon(
            theme.brightness == Brightness.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            size: 20.0,
          ),
          tooltip: theme.brightness == Brightness.dark ? 'Modo Claro' : 'Modo Oscuro',
          onPressed: () {
            final next = theme.brightness == Brightness.dark
                ? ThemeModeEnum.light
                : ThemeModeEnum.dark;
            settings.setThemeMode(next);
          },
        ),
      ],
    );
  }
}
