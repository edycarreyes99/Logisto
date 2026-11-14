import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../domain/models/account_payable_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'accounts_payable_provider.dart';
import 'widgets/payable_list_mobile.dart';
import 'widgets/payable_table_desktop.dart';

/// Screen managing commercial supplier debt ledger (CxP) and payment disbursements.
class AccountsPayableScreen extends StatefulWidget {
  const AccountsPayableScreen({super.key});

  @override
  State<AccountsPayableScreen> createState() => _AccountsPayableScreenState();
}

class _AccountsPayableScreenState extends State<AccountsPayableScreen> {
  late final AccountsPayableProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<AccountsPayableProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadPayables(orgId: orgId, buId: buId);
      });
    }
  }

  void _showPaymentModal(AccountPayableModel p) {
    final l10n = AppLocalizations.of(context)!;
    final amtCtrl = TextEditingController(text: '${p.remainingBalance}');
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            l10n.paySupplierTitle(p.supplierName),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.invoiceLabel(p.invoiceNumber)),
              Text(
                l10n.remainingDebtLabel(p.remainingBalance.toStringAsFixed(2)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amtCtrl,
                decoration: InputDecoration(
                  labelText: l10n.paymentAmountDollar,
                  hintText: l10n.paymentAmountDollar,
                  border: const OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(l10n.disbursePayment),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final val =
                          double.tryParse(amtCtrl.text) ?? p.remainingBalance;
                      await _provider.recordPayment(
                        payableId: p.id,
                        amount: val,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Pago a proveedor de \$${val.toStringAsFixed(2)} emitido con éxito',
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LogistoScaffold(
      title: l10n.payables,
      actions: [
        Chip(
          label: Text(
            l10n.totalLiabilitiesAmount(
              _provider.totalLiabilities.toStringAsFixed(2),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          visualDensity: VisualDensity.compact,
        ),
      ],
      body: BsContainer.fluid(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => _buildBody(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final isDesktop = MediaQuery.sizeOf(context).width >= BsBreakpoints.lg;
    final payables = _provider.payables;
    final theme = Theme.of(context);

    if (_provider.status == FeatureStatusEnum.loading) {
      return Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? const AppSkeletonTable(rowCount: 5, columnCount: 5)
              : const AppSkeletonList(itemCount: 4),
        ),
      );
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: payables.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    l10n.noSupplierLiabilitiesRecorded,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            : (isDesktop
                ? PayableTableDesktop(
                    payables: payables,
                    onPay: _showPaymentModal,
                  )
                : PayableListMobile(
                    payables: payables,
                    onPay: _showPaymentModal,
                  )),
      ),
    );
  }
}
