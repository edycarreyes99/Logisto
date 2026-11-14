import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
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
import 'widgets/pin_switch_modal.dart';

/// Corporate authentication screen with multi-tenant sign in,
/// fast PIN switch modal, onboarding triggers, language switcher, and responsive layout.
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
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
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
    final success = await _loginProvider.signInWithEmailPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      AppFeedback.showSuccess(
        context,
        l10n.welcomeTitle,
        title: l10n.logistoEnterprise,
      );
      locator<NavigationProvider>().navigateTo(AppRoutes.dashboard);
    } else {
      AppFeedback.showError(
        context,
        _loginProvider.errorCode == 'email_password_required'
            ? l10n.authErrorEmailPasswordRequired
            : (_loginProvider.errorMessage ?? l10n.invalidCredentials),
      );
    }
  }

  void _showPinModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PinSwitchModal(
        provider: _loginProvider,
        onSuccess: () {
          locator<NavigationProvider>().navigateTo(AppRoutes.dashboard);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildHeader(l10n, theme),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E1B4B),
                    const Color(0xFF090D16),
                  ]
                : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFEEF2FF),
                    const Color(0xFFE0E7FF),
                  ],
          ),
        ),
        child: SafeArea(
          child: BsContainer.fluid(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: ListenableBuilder(
                    listenable: _loginProvider,
                    builder: (context, _) => BsRow(
                      children: [
                        BsCol(
                          config: const BsColConfig(xs: 12, md: 6, lg: 7),
                          child: _buildWelcomeBanner(l10n, theme, isDark),
                        ),
                        BsCol(
                          config: const BsColConfig(xs: 12, md: 6, lg: 5),
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
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    final settings = locator.isRegistered<SettingsProvider>()
        ? locator<SettingsProvider>()
        : null;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            l10n.logistoEnterprise,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ],
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      actions: [
        if (settings != null) ...[
          // Language switcher button
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: TextButton.icon(
              icon: const Icon(Icons.language_rounded, size: 18.0),
              label: Text(
                settings.language == LanguageEnum.es ? 'ES' : 'EN',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                final next = settings.language == LanguageEnum.es
                    ? LanguageEnum.en
                    : LanguageEnum.es;
                settings.setLanguage(next);
              },
            ),
          ),
          // Theme switcher button
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
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
          ),
        ],
      ],
    );
  }

  Widget _buildWelcomeBanner(
    AppLocalizations l10n,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 15.0,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6.0),
                Text(
                  'Cloud Firestore Enterprise v2.5',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            l10n.welcomeBannerTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            l10n.welcomeBannerDesc,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24.0),
          // 4 Capability highlights
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: [
              _buildFeatureBadge(
                theme,
                icon: Icons.point_of_sale_rounded,
                title: l10n.pos,
                subtitle: 'Ventas en tiempo real',
              ),
              _buildFeatureBadge(
                theme,
                icon: Icons.sports_esports_rounded,
                title: l10n.billiards,
                subtitle: 'Control de mesas y tarifas',
              ),
              _buildFeatureBadge(
                theme,
                icon: Icons.restaurant_rounded,
                title: l10n.kitchen,
                subtitle: 'KDS para pedidos en cocina',
              ),
              _buildFeatureBadge(
                theme,
                icon: Icons.inventory_2_rounded,
                title: l10n.inventory,
                subtitle: 'Kardex y multialmacén',
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.primary,
                  size: 20.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    l10n.fastPinAlert,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 210.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20.0),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
