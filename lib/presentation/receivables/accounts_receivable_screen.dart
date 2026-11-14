import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/payment_method_enum.dart';
import '../../domain/models/account_receivable_model.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../common/app_feedback.dart';
import '../common/app_skeleton.dart';
import '../common/logisto_scaffold.dart';
import '../context/business_context_provider.dart';
import 'accounts_receivable_provider.dart';
import 'widgets/receivable_list_mobile.dart';
import 'widgets/receivable_table_desktop.dart';

/// Screen managing customer debt ledger (CxC) and official receipt collection (ROC).
class AccountsReceivableScreen extends StatefulWidget {
  const AccountsReceivableScreen({super.key});

  @override
  State<AccountsReceivableScreen> createState() =>
      _AccountsReceivableScreenState();
}

class _AccountsReceivableScreenState extends State<AccountsReceivableScreen> {
  late final AccountsReceivableProvider _provider;
  late final BusinessContextProvider _contextProvider;

  @override
  void initState() {
    super.initState();
    _provider = locator<AccountsReceivableProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    final orgId = _contextProvider.activeOrganization?.id ?? '';
    final buId = _contextProvider.activeBusinessUnit?.id ?? '';
    if (orgId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.loadReceivables(orgId: orgId, buId: buId);
      });
    }
  }

  void _showCollectModal(AccountReceivableModel r) {
    final l10n = AppLocalizations.of(context)!;
    final amtCtrl = TextEditingController(text: '${r.balance}');
    bool isSaving = false;

    showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Text(
            l10n.collectPaymentCustomer(r.customerName),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.outstandingBalanceAmount(r.balance.toStringAsFixed(2))),
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
              label: Text(l10n.emitReceiptAndApply),
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      final val = double.tryParse(amtCtrl.text) ?? r.balance;
                      await _provider.recordPayment(
                        receivableId: r.id,
                        amount: val,
                        method: PaymentMethodEnum.cash,
                      );
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      if (mounted) {
                        AppFeedback.showSuccess(
                          context,
                          'Abono de \$${val.toStringAsFixed(2)} aplicado a ${r.customerName}',
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
      title: l10n.receivables,
      actions: [
        Chip(
          label: Text(
            '${l10n.totalDebt}: \$${_provider.totalOutstandingDebt.toStringAsFixed(2)}',
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
    final receivables = _provider.receivables;
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
        child: receivables.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    l10n.noOutstandingReceivables,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            : (isDesktop
                ? ReceivableTableDesktop(
                    receivables: receivables,
                    onCollect: _showCollectModal,
                  )
                : ReceivableListMobile(
                    receivables: receivables,
                    onCollect: _showCollectModal,
                  )),
      ),
    );
  }
}
