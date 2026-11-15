import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../open_accounts_provider.dart';
import 'account_catalog_panel.dart';
import 'account_items_panel.dart';

/// Mobile/tablet responsive view:
/// Stacks the product catalog and selected comanda items vertically across 12 columns.
class OpenAccountsMobileView extends StatelessWidget {
  final OpenAccountsProvider provider;
  final VoidCallback onPreBill;
  final VoidCallback onCheckout;

  const OpenAccountsMobileView({
    super.key,
    required this.provider,
    required this.onPreBill,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: [
        BsCol(
          config: const BsColConfig(xs: 12),
          child: AccountCatalogPanel(
            products: provider.quickCatalog,
            onAddProduct: provider.addProductToSelected,
          ),
        ),
        BsCol(
          config: const BsColConfig(xs: 12),
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
