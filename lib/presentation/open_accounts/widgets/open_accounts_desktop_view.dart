import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../open_accounts_provider.dart';
import 'account_catalog_panel.dart';
import 'account_items_panel.dart';
import 'open_accounts_list_panel.dart';

/// Desktop 3-column view:
/// - Col 1 (left, lg: 3): List of all open accounts/comandas.
/// - Col 2 (middle, lg: 5): Product catalog to add items.
/// - Col 3 (right, lg: 4): Details of the active selected comanda.
class OpenAccountsDesktopView extends StatelessWidget {
  final OpenAccountsProvider provider;
  final VoidCallback onNewTab;
  final VoidCallback onPreBill;
  final VoidCallback onCheckout;

  const OpenAccountsDesktopView({
    super.key,
    required this.provider,
    required this.onNewTab,
    required this.onPreBill,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: [
        BsCol(
          config: const BsColConfig(xs: 12, lg: 3, xl: 3),
          child: OpenAccountsListPanel(
            provider: provider,
            onNewTab: onNewTab,
          ),
        ),
        BsCol(
          config: const BsColConfig(xs: 12, md: 7, lg: 5, xl: 5),
          child: AccountCatalogPanel(
            products: provider.quickCatalog,
            onAddProduct: provider.addProductToSelected,
          ),
        ),
        BsCol(
          config: const BsColConfig(xs: 12, md: 5, lg: 4, xl: 4),
          child: AccountItemsPanel(
            account: provider.selectedAccount,
            onAdjustQuantity: provider.adjustItemQuantity,
            onPreBill: onPreBill,
            onCheckout: onCheckout,
          ),
        ),
      ],
    );
  }
}
