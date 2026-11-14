import 'package:flutter/material.dart';
import '../../../core/enums/feature_status_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../pos_checkout_provider.dart';

/// Right panel controlling multi-tender payment inputs, customer credit, and change calculation.
class CheckoutTenderPanel extends StatelessWidget {
  final PosCheckoutProvider provider;
  final TextEditingController cashCtrl;
  final TextEditingController cardCtrl;
  final TextEditingController creditCtrl;
  final VoidCallback onSelectCustomer;
  final VoidCallback onFinalize;

  const CheckoutTenderPanel({
    super.key,
    required this.provider,
    required this.cashCtrl,
    required this.cardCtrl,
    required this.creditCtrl,
    required this.onSelectCustomer,
    required this.onFinalize,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final result = provider.lastResult;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.multiTenderPayment,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildCustomerBar(l10n),
            const SizedBox(height: 16),
            _buildTenderInputs(l10n),
            const SizedBox(height: 16),
            if (provider.errorMessage != null)
              _buildErrorAlert(theme)
            else if (result != null)
              _buildResultSummary(theme, result, l10n),
            const SizedBox(height: 20),
            _buildFinalizeButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalizeButton(AppLocalizations l10n) {
    final isLoading = provider.status == FeatureStatusEnum.loading;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.check_circle_outline),
      label: Text(l10n.finalizeSale),
      onPressed: (provider.cartItems.isEmpty || isLoading) ? null : onFinalize,
    );
  }

  Widget _buildCustomerBar(AppLocalizations l10n) {
    final cust = provider.selectedCustomer;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cust != null ? cust.fullName : l10n.walkInCustomer,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (cust != null)
                Text(
                  '${l10n.creditAvailablePrefix}: \$${cust.availableCredit.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.person, size: 16),
          label: Text(cust != null ? l10n.changeCustomer : l10n.customer),
          onPressed: onSelectCustomer,
        ),
      ],
    );
  }

  Widget _buildTenderInputs(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: cashCtrl,
          decoration: InputDecoration(
            labelText: l10n.cashTendered,
            prefixText: '\$ ',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: cardCtrl,
          decoration: InputDecoration(
            labelText: l10n.cardPayment,
            prefixText: '\$ ',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        if (provider.selectedCustomer != null) ...[
          const SizedBox(height: 12),
          TextField(
            controller: creditCtrl,
            decoration: InputDecoration(
              labelText: l10n.customerCredit,
              prefixText: '\$ ',
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }

  Widget _buildErrorAlert(ThemeData theme) {
    return Card(
      color: theme.colorScheme.errorContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          provider.errorMessage!,
          style: TextStyle(color: theme.colorScheme.onErrorContainer),
        ),
      ),
    );
  }

  Widget _buildResultSummary(
    ThemeData theme,
    dynamic result,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.changeDue,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${(result.change as double).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if ((result.creditCarriedOver as double) > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.addedToCustomerDebt),
                Text(
                  '\$${(result.creditCarriedOver as double).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
