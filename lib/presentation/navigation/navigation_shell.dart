import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
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
import '../settings/settings_screen.dart';
import '../suppliers/supplier_catalog_screen.dart';
import '../users/user_management_screen.dart';
import 'app_routes.dart';
import 'navigation_drawer.dart';
import 'navigation_provider.dart';

/// Universal multiplatform application shell hosting top navigation bar,
/// responsive sidebar/drawer, and active module routing.
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

  void _showOffcanvasDrawer() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.navOffcanvasTitle,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: AppNavigationDrawer(
                navProvider: _navProvider,
                contextProvider: _contextProvider,
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
      builder: (ctx) =>
          PinSwitchModal(provider: _loginProvider, onSuccess: () {}),
    );
  }

  Future<void> _handleSeedDatabase() async {
    final seeder = locator<DatabaseSeeder>();
    await seeder.seedProductionData();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.seedDatabase),
        content: Text(l10n.databaseSeededSuccess),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.accept),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    await _loginProvider.signOut();
    await _contextProvider.clearContext();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    return ListenableBuilder(
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    OutlinedButton.icon(
                      icon: const Icon(Icons.business, size: 16),
                      label: Text(l10n.switchBranch),
                      onPressed: () =>
                          _navProvider.navigateTo(AppRoutes.businessUnits),
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
                      icon: const Icon(Icons.logout, size: 16),
                      label: Text(l10n.logout),
                      onPressed: _handleLogout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 260,
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
      ),
    );
  }

  Widget _resolveScreen(String route) {
    switch (route) {
      case AppRoutes.login:
        return const LoginScreen();
      case AppRoutes.onboarding:
        return const OnboardingWizardScreen();
      case AppRoutes.businessUnits:
        return const BusinessUnitSelectorScreen();
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
      case AppRoutes.users:
        return const UserManagementScreen();
      case AppRoutes.settings:
        return const SettingsScreen();
      case AppRoutes.audit:
        return const AuditLogScreen();
      default:
        return const DashboardScreen();
    }
  }
}
