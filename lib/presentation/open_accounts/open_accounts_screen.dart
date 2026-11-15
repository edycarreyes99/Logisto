import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import '../pos/pos_checkout_provider.dart';
import 'open_accounts_provider.dart';
import 'widgets/open_account_prebill_dialog.dart';
import 'widgets/open_accounts_desktop_view.dart';
import 'widgets/open_accounts_mobile_view.dart';
import 'widgets/open_new_tab_dialog.dart';

/// Screen managing open bar tabs and customer accounts.
/// - Desktop (>= lg): 3-column view (Open orders list, catalog, active comanda details).
/// - Mobile (< lg): Top horizontal tabs and responsive stack.
class OpenAccountsScreen extends StatefulWidget {
  const OpenAccountsScreen({super.key});

  @override
  State<OpenAccountsScreen> createState() => _OpenAccountsScreenState();
}

class _OpenAccountsScreenState extends State<OpenAccountsScreen> {
  late final OpenAccountsProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<OpenAccountsProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadAccounts(orgId: orgId, buId: buId);
      });
    }
  }

  void _refresh() {
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      _provider.loadAccounts(orgId: orgId, buId: buId);
      final l10n = AppLocalizations.of(context)!;
      AppFeedback.showInfo(context, l10n.refresh);
    }
  }

  void _showNewTabModal() {
    OpenNewTabDialog.show(context, _provider);
  }

  void _showPreBillModal() {
    final acc = _provider.selectedAccount;
    if (acc != null) {
      OpenAccountPrebillDialog.show(context, acc);
    }
  }

  void _handleCheckout() {
    final acc = _provider.selectedAccount;
    if (acc != null) {
      locator<PosCheckoutProvider>().loadFromOpenAccount(acc);
    }
    locator<NavigationProvider>().navigateTo(AppRoutes.pos);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;

    return LogistoScaffold(
      title: l10n.openAccountsAndTabs,
      actions: isDesktop
          ? [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.refresh,
                onPressed: _refresh,
              ),
              FilledButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.newTab),
                onPressed: _showNewTabModal,
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.refresh,
                onPressed: _refresh,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: l10n.newTab,
                onPressed: _showNewTabModal,
              ),
            ],
      bottom: isDesktop ? null : _buildMobileTabs(),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _buildLayout(isDesktop),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(bool isDesktop) {
    if (_provider.status == FeatureStatusEnum.loading && _provider.accounts.isEmpty) {
      return const AppSkeletonTable(rowCount: 5, columnCount: 4);
    }

    if (isDesktop) {
      return OpenAccountsDesktopView(
        provider: _provider,
        onNewTab: _showNewTabModal,
        onPreBill: _showPreBillModal,
        onCheckout: _handleCheckout,
      );
    }

    return OpenAccountsMobileView(
      provider: _provider,
      onPreBill: _showPreBillModal,
      onCheckout: _handleCheckout,
    );
  }

  PreferredSizeWidget? _buildMobileTabs() {
    if (_provider.accounts.isEmpty) return null;

    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _provider.accounts.map((acc) {
              final isSel = _provider.selectedAccount?.id == acc.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text('${acc.code} (${acc.customerDisplayName})'),
                  selected: isSel,
                  onSelected: (_) => _provider.selectAccount(acc.id),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
