import 'package:flutter/material.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../../theme/app_colors.dart';
import '../auth/login_provider.dart';
import '../auth/logout_dialog.dart';
import '../context/business_context_provider.dart';
import '../settings/settings_provider.dart';
import 'app_routes.dart';
import 'navigation_provider.dart';

/// Navigation menu listing all enterprise Logisto modules grouped by capability.
/// Features a Material 3 Drawer header, user profile badge, active branch context,
/// and accessible high-contrast navigation targets.
class AppNavigationDrawer extends StatelessWidget {
  final NavigationProvider navProvider;
  final BusinessContextProvider contextProvider;
  final VoidCallback? onNavigate;
  final bool showHeader;
  final bool showFooter;

  const AppNavigationDrawer({
    super.key,
    required this.navProvider,
    required this.contextProvider,
    this.onNavigate,
    this.showHeader = true,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final body = SingleChildScrollView(
      key: const PageStorageKey<String>('app_navigation_drawer_scroll'),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildAllSections(context, l10n),
      ),
    );

    if (!showHeader && !showFooter) {
      return Container(
        color: isDark ? const Color(0xFF131A26) : Colors.white,
        child: body,
      );
    }

    return Container(
      color: isDark ? const Color(0xFF131A26) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) _buildDrawerHeader(context, l10n, theme, isDark),
          Expanded(child: body),
          if (showFooter) _buildDrawerFooter(context, l10n, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    bool isDark,
  ) {
    final buName = contextProvider.activeBusinessUnit?.name ?? l10n.defaultBranchName;
    final userRole = navProvider.currentUserRole.name.toUpperCase();
    final loginProvider = locator.isRegistered<LoginProvider>()
        ? locator<LoginProvider>()
        : null;
    final userName = loginProvider?.currentUserName ?? 'Administrador';
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(16.0, topPadding + 16.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHigh
            : theme.colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              navProvider.navigateTo(AppRoutes.users);
              onNavigate?.call();
            },
            borderRadius: BorderRadius.circular(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          userRole,
                          style: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          InkWell(
            onTap: () {
              navProvider.navigateTo(AppRoutes.businessUnits);
              onNavigate?.call();
            },
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    size: 16.0,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      buName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.swap_horiz_rounded,
                    size: 16.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    bool isDark,
  ) {
    final settings = locator.isRegistered<SettingsProvider>()
        ? locator<SettingsProvider>()
        : null;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0 + bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (settings != null) ...[
            IconButton(
              icon: Icon(
                settings.themeMode == ThemeModeEnum.dark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                size: 20.0,
              ),
              tooltip: settings.themeMode == ThemeModeEnum.dark ? 'Modo Claro' : 'Modo Oscuro',
              onPressed: () {
                final next = settings.themeMode == ThemeModeEnum.dark
                    ? ThemeModeEnum.light
                    : ThemeModeEnum.dark;
                settings.setThemeMode(next);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.language_rounded, size: 16.0),
              label: Text(
                settings.language == LanguageEnum.es ? 'ES' : 'EN',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
              ),
              onPressed: () {
                final next = settings.language == LanguageEnum.es
                    ? LanguageEnum.en
                    : LanguageEnum.es;
                settings.setLanguage(next);
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20.0),
            tooltip: l10n.logout,
            color: theme.colorScheme.error,
            onPressed: () => showLogoutDialog(
              context,
              onBeforeLogout: () => onNavigate?.call(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllSections(BuildContext context, AppLocalizations l10n) {
    return [
      _buildSection(context, l10n.navSectionCoreOperations, [
        _Item(l10n.dashboard, Icons.speed, AppRoutes.dashboard),
        _Item(l10n.pos, Icons.point_of_sale, AppRoutes.pos),
        _Item(l10n.openAccounts, Icons.checklist, AppRoutes.openAccounts),
        if (contextProvider.isBilliardActive)
          _Item(l10n.billiards, Icons.sports_esports, AppRoutes.billiards),
        _Item(l10n.kitchen, Icons.restaurant, AppRoutes.kitchen),
      ]),
      _buildSection(context, l10n.navSectionInventoryOperations, [
        _Item(l10n.cash, Icons.payments, AppRoutes.cash),
        _Item(l10n.warehouses, Icons.inventory_2, AppRoutes.inventory),
        _Item(l10n.kardex, Icons.menu_book, AppRoutes.kardex),
        _Item(l10n.invoices, Icons.receipt_long, AppRoutes.invoices),
      ]),
      _buildSection(context, l10n.navSectionCatalogsPartners, [
        _Item(l10n.products, Icons.shopping_bag, AppRoutes.products),
        _Item(l10n.customers, Icons.people, AppRoutes.customers),
        _Item(l10n.suppliers, Icons.local_shipping, AppRoutes.suppliers),
      ]),
      _buildSection(context, l10n.navSectionFinanceLedgers, [
        _Item(l10n.purchasing, Icons.shopping_cart_checkout, AppRoutes.purchasing),
        _Item(l10n.receivables, Icons.account_balance_wallet, AppRoutes.receivables),
        _Item(l10n.payables, Icons.credit_card, AppRoutes.payables),
        _Item(l10n.reports, Icons.bar_chart, AppRoutes.reports),
      ]),
      _buildSection(context, l10n.navSectionSystemManagement, [
        _Item(l10n.businessUnits, Icons.business, AppRoutes.businessUnits),
        _Item(l10n.users, Icons.manage_accounts, AppRoutes.users),
        _Item(l10n.audit, Icons.security, AppRoutes.audit),
        _Item(l10n.settings, Icons.settings, AppRoutes.settings),
      ]),
    ];
  }

  Widget _buildSection(BuildContext context, String title, List<_Item> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionHeaderColor = isDark
        ? AppColors.textMutedDark
        : AppColors.textMutedLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 6.0,
            ),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: sectionHeaderColor,
                letterSpacing: 0.6,
              ),
            ),
          ),
          ...items.map((item) => _buildNavItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _Item item) {
    final isActive = navProvider.currentRoute == item.route;
    return _SidebarNavItem(
      item: item,
      isActive: isActive,
      onTap: () {
        navProvider.navigateTo(item.route);
        onNavigate?.call();
      },
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  final _Item item;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
    }
  }

  @override
  void didUpdateWidget(covariant _SidebarNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
    }
  }

  void _scrollToActive() {
    if (!mounted) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0.35,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: _buildTile(colors),
        ),
      ),
    );
  }

  (Color, Color, Color) _resolveColors(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;

    if (widget.isActive) {
      return (primary, AppColors.backgroundLight, AppColors.backgroundLight);
    } else if (_isHovered) {
      final bg = isDark
          ? primary.withValues(alpha: 0.25)
          : primary.withValues(alpha: 0.12);
      final fg = isDark ? AppColors.primaryDark : primary;
      return (bg, fg, fg);
    } else {
      final fg = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
      final icon = isDark ? AppColors.borderLight : AppColors.borderDark;
      return (Colors.transparent, fg, icon);
    }
  }

  Widget _buildTile((Color, Color, Color) colors) {
    final (backgroundColor, textColor, iconColor) = colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(widget.item.icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.item.title,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight:
                    widget.isActive ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String title;
  final IconData icon;
  final String route;
  const _Item(
    this.title,
    this.icon,
    this.route,
  );
}
