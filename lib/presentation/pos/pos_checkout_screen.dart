import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../cash/cash_shift_provider.dart';
import '../common/app_feedback.dart';
import '../context/business_context_provider.dart';
import 'pos_checkout_provider.dart';
import 'widgets/checkout_cart_panel.dart';
import 'widgets/checkout_tender_panel.dart';
import 'widgets/thermal_receipt_modal.dart';

/// POS multi-tender checkout workstation supporting mixed payments,
/// change calculation, customer credit limits, and thermal receipt emission.
class PosCheckoutScreen extends StatefulWidget {
  const PosCheckoutScreen({super.key});

  @override
  State<PosCheckoutScreen> createState() => _PosCheckoutScreenState();
}

class _PosCheckoutScreenState extends State<PosCheckoutScreen> {
  late final PosCheckoutProvider _provider;
  late final BusinessContextProvider _contextProvider;
  late final CashShiftProvider _cashShiftProvider;
  final TextEditingController _cashCtrl = TextEditingController(text: '0.00');
  final TextEditingController _cardCtrl = TextEditingController(text: '0.00');
  final TextEditingController _creditCtrl = TextEditingController(text: '0.00');

  @override
  void initState() {
    super.initState();
    _provider = locator<PosCheckoutProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    _cashShiftProvider = locator<CashShiftProvider>();

    _cashCtrl.addListener(_onTenderChanged);
    _cardCtrl.addListener(_onTenderChanged);
    _creditCtrl.addListener(_onTenderChanged);
  }

  @override
  void dispose() {
    _cashCtrl.removeListener(_onTenderChanged);
    _cardCtrl.removeListener(_onTenderChanged);
    _creditCtrl.removeListener(_onTenderChanged);
    _cashCtrl.dispose();
    _cardCtrl.dispose();
    _creditCtrl.dispose();
    super.dispose();
  }

  void _onTenderChanged() {
    final cash = double.tryParse(_cashCtrl.text) ?? 0.0;
    final card = double.tryParse(_cardCtrl.text) ?? 0.0;
    final credit = _provider.selectedCustomer != null
        ? (double.tryParse(_creditCtrl.text) ?? 0.0)
        : 0.0;
    _provider.updateTenderAmounts(cash: cash, card: card, credit: credit);
  }

  void _showAddProductModal() async {
    final orgId =
        _contextProvider.activeOrganization?.id ?? 'org_logisto_matriz';
    final productRepo = locator<ProductRepository>();
    final products = await productRepo.getProducts(orgId);
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.quickProductCatalog,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: products.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(child: Text(l10n.noProductsAvailablePrompt)),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ListTile(
                      title: Text(
                        p.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${p.sku} • \$${p.salePrice.toStringAsFixed(2)}',
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: () {
                          _provider.addItemToCart(p);
                          _cashCtrl.text = _provider.totalAmount
                              .toStringAsFixed(2);
                          Navigator.of(ctx).pop();
                          AppFeedback.showSuccess(
                            context,
                            '${p.name} agregado a la orden',
                          );
                        },
                        child: Text(l10n.add),
                      ),
                    );
                  },
                ),
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

  void _showCustomerModal() async {
    final orgId =
        _contextProvider.activeOrganization?.id ?? 'org_logisto_matriz';
    final customerRepo = locator<CustomerRepository>();
    final customers = await customerRepo.getCustomers(orgId: orgId);
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.selectOrRegisterCustomer,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  l10n.walkInCustomer,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: FilledButton(
                  onPressed: () {
                    _creditCtrl.text = '0.00';
                    _provider.selectCustomer(null);
                    Navigator.of(ctx).pop();
                  },
                  child: Text(l10n.select),
                ),
              ),
              const Divider(height: 1),
              ...customers.where((c) => c.taxId != '000-000000-0000X').map((
                c,
              ) {
                return ListTile(
                  title: Text(
                    c.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'RUC: ${c.taxId} • ${l10n.creditLimitLabel}: \$${c.creditLimit.toStringAsFixed(2)} • ${l10n.debtLabel}: \$${c.currentDebtBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () {
                      _creditCtrl.text = '0.00';
                      _provider.selectCustomer(c);
                      Navigator.of(ctx).pop();
                    },
                    child: Text(l10n.select),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFinalize() async {
    final orgId =
        _contextProvider.activeOrganization?.id ?? 'org_logisto_matriz';
    final buId = _contextProvider.activeBusinessUnit?.id ?? 'bu_matriz_central';
    final shiftId = _cashShiftProvider.activeShift?.id ?? 'shift_active';

    final invoice = await _provider.finalizeInvoice(
      orgId: orgId,
      buId: buId,
      cashierId: 'usr_cashier',
      cashShiftId: shiftId,
    );

    if (!mounted) return;
    if (invoice != null) {
      final cashTender = double.tryParse(_cashCtrl.text) ?? 0.0;
      final cardTender = double.tryParse(_cardCtrl.text) ?? 0.0;
      final creditTender = double.tryParse(_creditCtrl.text) ?? 0.0;
      _cashShiftProvider.recordSale(
        cashAmount: cashTender > invoice.totalAmount
            ? invoice.totalAmount
            : cashTender,
        cardAmount: cardTender,
        creditAmount: creditTender,
      );

      AppFeedback.showSuccess(
        context,
        'Factura #${invoice.invoiceNumber} emitida exitosamente',
        title: 'Venta Finalizada',
      );

      final orgName =
          _contextProvider.activeOrganization?.legalName ?? 'Logisto ERP';
      final buName =
          _contextProvider.activeBusinessUnit?.name ?? 'Sucursal Central';

      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => ThermalReceiptModal(
          invoice: invoice,
          organizationName: orgName,
          branchName: buName,
          onNewSale: () {
            _provider.resetCart();
            _cashCtrl.text = '0.00';
            _cardCtrl.text = '0.00';
            _creditCtrl.text = '0.00';
          },
        ),
      );
    } else if (_provider.errorMessage != null) {
      final l10n = AppLocalizations.of(context)!;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.error),
          content: Text(_provider.errorMessage!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.close),
            ),
          ],
        ),
      );
    }
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
            builder: (context, _) => BsRow(
              children: [
                BsCol(
                  config: const BsColConfig(xs: 12, md: 7, lg: 7),
                  child: CheckoutCartPanel(
                    provider: _provider,
                    onAddProduct: _showAddProductModal,
                  ),
                ),
                BsCol(
                  config: const BsColConfig(xs: 12, md: 5, lg: 5),
                  child: CheckoutTenderPanel(
                    provider: _provider,
                    cashCtrl: _cashCtrl,
                    cardCtrl: _cardCtrl,
                    creditCtrl: _creditCtrl,
                    onSelectCustomer: _showCustomerModal,
                    onFinalize: _handleFinalize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.pos,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: FilledButton.icon(
            icon: const Icon(Icons.add_shopping_cart, size: 18),
            label: Text(l10n.addItem),
            onPressed: _showAddProductModal,
          ),
        ),
      ],
    );
  }
}
