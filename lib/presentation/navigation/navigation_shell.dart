import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../audit/audit_log_screen.dart';
import '../auth/login_provider.dart';
import '../auth/login_screen.dart';
import '../auth/widgets/pin_switch_modal.dart';
import '../billiards/billiard_floor_plan_screen.dart';
import '../business_units/business_unit_selector_screen.dart';
import '../cash/cash_shift_screen.dart';
import '../common/app_feedback.dart';
import '../context/business_context_provider.dart';
import '../customers/customer_catalog_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_warehouse_screen.dart';
import '../invoices/invoice_history_screen.dart';
import '../kitchen/kitchen_display_screen.dart';
import '../onboarding/onboarding_wizard_screen.dart';
import '../open_accounts/open_accounts_screen.dart';
import '../payables/accounts_payable_screen.dart';
import '../pos/pos_checkout_screen.dart';
import '../products/product_catalog_screen.dart';
import '../purchasing/purchase_order_screen.dart';
import '../receivables/accounts_receivable_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_provider.dart';
import '../settings/settings_screen.dart';
import '../suppliers/supplier_catalog_screen.dart';
import '../users/user_management_screen.dart';
import 'app_routes.dart';
import 'navigation_drawer.dart';
import 'navigation_provider.dart';

/// Universal multiplatform application shell hosting top navigation bar,
/// responsive Material 3 Drawer, BottomNavigationBar for mobile modules,
/// and active operational routing.
class NavigationShell extends StatefulWidget {
  final String? initialRoute;

  const NavigationShell({super.key, this.initialRoute});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final NavigationProvider _navProvider;
  late final BusinessContextProvider _contextProvider;
  late final LoginProvider _loginProvider;

  @override
  void initState() {
    super.initState();
    _navProvider = locator<NavigationProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    _loginProvider = locator<LoginProvider>();

    if (widget.initialRoute != null) {
      _navProvider.navigateTo(widget.initialRoute!);
    }
  }

  void _showOffcanvasDrawer() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(ctx).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 12.0, 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.grid_view_rounded,
                            size: 18.0,
                            color: Theme.of(ctx).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            l10n.navOffcanvasTitle,
                            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: AppNavigationDrawer(
                navProvider: _navProvider,
                contextProvider: _contextProvider,
                showHeader: false,
                onNavigate: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFastPinModal() {
    showDialog<void>(
      context: context,
      builder: (ctx) => PinSwitchModal(
        provider: _loginProvider,
        onSuccess: () {
          AppFeedback.showSuccess(context, 'Terminal desbloqueada con éxito');
        },
      ),
    );
  }

  Future<void> _handleSeedDatabase() async {
    final seeder = locator<DatabaseSeeder>();
    await seeder.seedProductionData();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showSuccess(
      context,
      l10n.databaseSeededSuccess,
      title: l10n.seedDatabase,
    );
  }

  void _showNotificationsPanel() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active_rounded, color: theme.colorScheme.primary),
                    const SizedBox(width: 10.0),
                    Text(
                      'Notificaciones y Alertas del Sistema',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const Divider(height: 20.0),
            _buildNotificationItem(
              theme,
              icon: Icons.check_circle_rounded,
              color: Colors.green,
              title: 'Sincronización Firestore en Vivo',
              subtitle: 'Todos los registros sincronizados con Cloud Firestore.',
              time: 'Hace un momento',
            ),
            const SizedBox(height: 10.0),
            _buildNotificationItem(
              theme,
              icon: Icons.info_outline_rounded,
              color: Colors.blue,
              title: 'Caja Operativa Activa',
              subtitle: 'Turno abierto en Sucursal Matriz.',
              time: 'Activo',
            ),
            const SizedBox(height: 10.0),
            _buildNotificationItem(
              theme,
              icon: Icons.verified_user_rounded,
              color: Colors.purple,
              title: 'Sesión Segura Multi-Tenant',
              subtitle: 'Permisos RBAC validados para el usuario actual.',
              time: 'En línea',
            ),
            const SizedBox(height: 16.0),
            FilledButton.tonal(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.accept),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    ThemeData theme, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
                const SizedBox(height: 2.0),
                Text(subtitle, style: TextStyle(fontSize: 12.0, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 11.0, color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 310.0,
        child: AppNavigationDrawer(
          navProvider: _navProvider,
          contextProvider: _contextProvider,
          onNavigate: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListenableBuilder(
        listenable: _contextProvider,
        builder: (context, _) => BsContainer.fluid(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNavbar(isDesktop),
              Expanded(
                child: ListenableBuilder(
                  listenable: _navProvider,
                  builder: (context, _) => Row(
                    children: [
                      if (isDesktop) _buildDesktopSidebar(),
                      Expanded(child: _resolveScreen(_navProvider.currentRoute)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNavigationBar(),
    );
  }

  Widget _buildNavbar(bool isDesktop) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rawBuName =
        _contextProvider.activeBusinessUnit?.name ?? l10n.defaultBranchName;
    final buName = rawBuName.length > 20
        ? '${rawBuName.substring(0, 18)}...'
        : rawBuName;
    final settings = locator.isRegistered<SettingsProvider>()
        ? locator<SettingsProvider>()
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            OutlinedButton.icon(
              icon: const Icon(Icons.menu, size: 18),
              label: Text(l10n.menu),
              onPressed: _showOffcanvasDrawer,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            'Logisto',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: InkWell(
              onTap: () => _navProvider.navigateTo(AppRoutes.businessUnits),
              borderRadius: BorderRadius.circular(8.0),
              child: Chip(
                label: Text(buName, overflow: TextOverflow.ellipsis),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.storage, size: 16),
                      label: Text(l10n.seedDatabase),
                      onPressed: _handleSeedDatabase,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.key, size: 16),
                      label: Text(l10n.fastPin),
                      onPressed: _showFastPinModal,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Notifications button
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 20.0),
                      tooltip: 'Notificaciones',
                      onPressed: _showNotificationsPanel,
                    ),
                    if (settings != null) ...[
                      // Language button
                      TextButton.icon(
                        icon: const Icon(Icons.language_rounded, size: 16.0),
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
                      // Theme toggle
                      IconButton(
                        icon: Icon(
                          theme.brightness == Brightness.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 20.0,
                        ),
                        tooltip: theme.brightness == Brightness.dark
                            ? 'Modo Claro'
                            : 'Modo Oscuro',
                        onPressed: () {
                          final next = theme.brightness == Brightness.dark
                              ? ThemeModeEnum.light
                              : ThemeModeEnum.dark;
                          settings.setThemeMode(next);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ] else ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 20.0),
              onPressed: _showNotificationsPanel,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 260.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: AppNavigationDrawer(
        navProvider: _navProvider,
        contextProvider: _contextProvider,
        showHeader: false,
        showFooter: false,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final l10n = AppLocalizations.of(context)!;
    final route = _navProvider.currentRoute;

    int selectedIndex = 0;
    if (route == AppRoutes.dashboard) {
      selectedIndex = 0;
    } else if (route == AppRoutes.pos) {
      selectedIndex = 1;
    } else if (route == AppRoutes.openAccounts || route == AppRoutes.billiards) {
      selectedIndex = 2;
    } else if (route == AppRoutes.cash || route == AppRoutes.inventory) {
      selectedIndex = 3;
    } else {
      selectedIndex = 4;
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            _navProvider.navigateTo(AppRoutes.dashboard);
            break;
          case 1:
            _navProvider.navigateTo(AppRoutes.pos);
            break;
          case 2:
            _navProvider.navigateTo(
              _contextProvider.isBilliardActive
                  ? AppRoutes.billiards
                  : AppRoutes.openAccounts,
            );
            break;
          case 3:
            _navProvider.navigateTo(AppRoutes.cash);
            break;
          case 4:
            _showOffcanvasDrawer();
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard_rounded),
          label: l10n.dashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.point_of_sale_outlined),
          selectedIcon: const Icon(Icons.point_of_sale_rounded),
          label: 'POS',
        ),
        NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(Icons.receipt_long_rounded),
          label: _contextProvider.isBilliardActive ? l10n.billiards : l10n.openAccounts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.payments_outlined),
          selectedIcon: const Icon(Icons.payments_rounded),
          label: l10n.cash,
        ),
        NavigationDestination(
          icon: const Icon(Icons.apps_rounded),
          selectedIcon: const Icon(Icons.grid_view_rounded),
          label: l10n.modules,
        ),
      ],
    );
  }

  Widget _resolveScreen(String route) {
    switch (route) {
      case AppRoutes.dashboard:
        return const DashboardScreen();
      case AppRoutes.billiards:
        return const BilliardFloorPlanScreen();
      case AppRoutes.openAccounts:
        return const OpenAccountsScreen();
      case AppRoutes.pos:
        return const PosCheckoutScreen();
      case AppRoutes.kitchen:
        return const KitchenDisplayScreen();
      case AppRoutes.cash:
        return const CashShiftScreen();
      case AppRoutes.products:
        return const ProductCatalogScreen();
      case AppRoutes.inventory:
        return const InventoryWarehouseScreen(initialView: 'stock');
      case AppRoutes.kardex:
        return const InventoryWarehouseScreen(initialView: 'kardex');
      case AppRoutes.customers:
        return const CustomerCatalogScreen();
      case AppRoutes.invoices:
        return const InvoiceHistoryScreen();
      case AppRoutes.suppliers:
        return const SupplierCatalogScreen();
      case AppRoutes.purchasing:
        return const PurchaseOrderScreen();
      case AppRoutes.receivables:
        return const AccountsReceivableScreen();
      case AppRoutes.payables:
        return const AccountsPayableScreen();
      case AppRoutes.reports:
        return const ReportsScreen();
      case AppRoutes.businessUnits:
        return const BusinessUnitSelectorScreen();
      case AppRoutes.users:
        return const UserManagementScreen();
      case AppRoutes.audit:
        return const AuditLogScreen();
      case AppRoutes.settings:
        return const SettingsScreen();
      case AppRoutes.onboarding:
        return const OnboardingWizardScreen();
      case AppRoutes.login:
        return const LoginScreen();
      default:
        return const DashboardScreen();
    }
  }
}
