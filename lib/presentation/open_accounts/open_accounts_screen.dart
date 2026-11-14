import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../context/business_context_provider.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import '../pos/pos_checkout_provider.dart';
import 'open_accounts_provider.dart';
import 'widgets/account_catalog_panel.dart';
import 'widgets/account_items_panel.dart';

/// Live order management screen with side-by-side catalog loading
/// and active tab billing.
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
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    final buId =
        _contextProvider.activeBusinessUnit?.id ??
        DatabaseSeeder.defaultBuCentralId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadAccounts(orgId: orgId, buId: buId);
    });
  }

  void _refresh() {
    final orgId =
        _contextProvider.activeOrganization?.id ?? DatabaseSeeder.defaultOrgId;
    final buId =
        _contextProvider.activeBusinessUnit?.id ??
        DatabaseSeeder.defaultBuCentralId;
    _provider.loadAccounts(orgId: orgId, buId: buId);
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showInfo(context, l10n.refresh);
  }

  void _showNewTabModal() {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.openNewTabTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.customerTableAliasPlaceholder,
                hintText: l10n.customerTableAliasPlaceholder,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final tabName =
                  nameCtrl.text.isEmpty ? 'Cliente Barra' : nameCtrl.text;
              _provider.createNewAccount(
                name: tabName,
                originType: 'counter',
              );
              Navigator.of(ctx).pop();
              AppFeedback.showSuccess(context, '${l10n.openTabAction}: $tabName');
            },
            child: Text(l10n.openTabAction),
          ),
        ],
      ),
    );
  }

  void _showPreBillModal() {
    final l10n = AppLocalizations.of(context)!;
    final acc = _provider.selectedAccount;
    if (acc == null) return;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.preBillPreviewCode(acc.code)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.customerLabel(acc.customerDisplayName)),
            const SizedBox(height: 8),
            ...acc.items.map(
              (i) => Text(
                '${i.quantity.toInt()}x ${i.name} - \$${i.total.toStringAsFixed(2)}',
              ),
            ),
            const Divider(height: 20),
            Text(
              '${l10n.totalToCollect}: \$${acc.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _buildHeader(l10n),
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _buildAccountPanels(),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountPanels() {
    if (_provider.status == FeatureStatusEnum.loading &&
        _provider.accounts.isEmpty) {
      return const AppSkeletonTable(rowCount: 5, columnCount: 4);
    }

    return BsRow(
      children: [
        BsCol(
          config: const BsColConfig(xs: 12, md: 7, lg: 7),
          child: AccountCatalogPanel(
            products: _provider.quickCatalog,
            onAddProduct: (prod) {
              _provider.addProductToSelected(prod);
              AppFeedback.showSuccess(context, '${prod.name} +1');
            },
          ),
        ),
        BsCol(
          config: const BsColConfig(xs: 12, md: 5, lg: 5),
          child: AccountItemsPanel(
            account: _provider.selectedAccount,
            onAdjustQuantity: _provider.adjustItemQuantity,
            onPreBill: _showPreBillModal,
            onCheckout: _handleCheckout,
          ),
        ),
      ],
    );
  }

  void _handleCheckout() {
    final acc = _provider.selectedAccount;
    if (acc != null) {
      locator<PosCheckoutProvider>().loadFromOpenAccount(acc);
    }
    locator<NavigationProvider>().navigateTo(AppRoutes.pos);
  }

  PreferredSizeWidget _buildHeader(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.openAccountsAndTabs,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.refresh,
          onPressed: _refresh,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: FilledButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.newTab),
            onPressed: _showNewTabModal,
          ),
        ),
      ],
      bottom: _provider.accounts.isEmpty
          ? null
          : PreferredSize(
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
                          label: Text(
                            '${acc.code} (${acc.customerDisplayName})',
                          ),
                          selected: isSel,
                          onSelected: (_) => _provider.selectAccount(acc.id),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
