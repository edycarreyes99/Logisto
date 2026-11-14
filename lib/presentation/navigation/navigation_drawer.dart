import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../context/business_context_provider.dart';
import 'app_routes.dart';
import 'navigation_provider.dart';

/// Navigation menu listing all enterprise Logisto modules grouped by capability.
class AppNavigationDrawer extends StatelessWidget {
  final NavigationProvider navProvider;
  final BusinessContextProvider contextProvider;
  final VoidCallback? onNavigate;

  const AppNavigationDrawer({
    super.key,
    required this.navProvider,
    required this.contextProvider,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildAllSections(context, l10n),
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
        _Item(l10n.onboarding, Icons.auto_awesome, AppRoutes.onboarding),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

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
  const _Item(this.title, this.icon, this.route);
}
