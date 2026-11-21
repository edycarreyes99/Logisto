import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';
import '../../core/enums/warehouse_view_mode_enum.dart';
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

/// Universal multiplatform application shell.
///
/// On mobile viewports (<lg), screens are rendered directly, each hosting
/// its own unified [LogistoScaffold] with [LogistoAppBar] and [AppNavigationDrawer],
/// eliminating top navbar status bar conflicts and bottom navigation clutter.
/// On desktop viewports (>=lg), renders a dedicated top corporate header,
/// a permanent navigation sidebar, and the active operational screen.
class NavigationShell extends StatefulWidget {
  final String? initialRoute;

  const NavigationShell({super.key, this.initialRoute});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
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

  void _showFastPinModal() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => PinSwitchModal(
        provider: _loginProvider,
        onSuccess: () {
          AppFeedback.showSuccess(context, l10n.terminalUnlockedSuccess);
        },
      ),
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
                    Icon(
                      Icons.notifications_active_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      l10n.notificationsAndAlerts,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
              title: l10n.liveFirestoreSyncTitle,
              subtitle: l10n.liveFirestoreSyncDesc,
              time: l10n.justNow,
            ),
            const SizedBox(height: 10.0),
            _buildNotificationItem(
              theme,
              icon: Icons.info_outline_rounded,
              color: Colors.blue,
              title: l10n.activeCashDrawerTitle,
              subtitle: l10n.activeCashDrawerDesc,
              time: l10n.activeStatus,
            ),
            const SizedBox(height: 10.0),
            _buildNotificationItem(
              theme,
              icon: Icons.verified_user_rounded,
              color: Colors.purple,
              title: l10n.secureMultiTenantSessionTitle,
              subtitle: l10n.secureMultiTenantSessionDesc,
              time: l10n.onlineStatus,
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
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    // Mobile: Render active module directly. Each screen hosts its own
    // LogistoScaffold with LogistoAppBar and AppNavigationDrawer.
    if (!isDesktop) {
      return ListenableBuilder(
        listenable: Listenable.merge([_contextProvider, _navProvider]),
        builder: (context, _) => _resolveScreen(_navProvider.currentRoute),
      );
    }

    // Desktop: Render top corporate header, persistent left sidebar, and active screen
    return Scaffold(
      body: ListenableBuilder(
        listenable: _contextProvider,
        builder: (context, _) => BsContainer.fluid(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDesktopNavbar(),
              Expanded(
                child: ListenableBuilder(
                  listenable: _navProvider,
                  builder: (context, _) => Row(
                    children: [
                      _buildDesktopSidebar(),
                      Expanded(
                        child: _resolveScreen(_navProvider.currentRoute),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopNavbar() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rawBuName =
        _contextProvider.activeBusinessUnit?.name ?? l10n.defaultBranchName;
    final buName = rawBuName.length > 24
        ? '${rawBuName.substring(0, 22)}...'
        : rawBuName;
    final settings = locator.isRegistered<SettingsProvider>()
        ? locator<SettingsProvider>()
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
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
          Text(
            'Logisto',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _navProvider.navigateTo(AppRoutes.businessUnits),
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    size: 14.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    buName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 20.0),
                    tooltip: l10n.notificationsAndAlerts,
                    onPressed: _showNotificationsPanel,
                  ),
                  if (settings != null) ...[
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
        showFooter: true,
      ),
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
        return const InventoryWarehouseScreen(
          initialView: WarehouseViewModeEnum.stock,
        );
      case AppRoutes.kardex:
        return const InventoryWarehouseScreen(
          initialView: WarehouseViewModeEnum.kardex,
        );
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
      case AppRoutes.login:
        return const LoginScreen();
      default:
        return const DashboardScreen();
    }
  }
}
