import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../settings_provider.dart';

/// Card managing enterprise corporate metadata, currency exchange rates, and tax policies.
class OrgSettingsCard extends StatefulWidget {
  final SettingsProvider provider;

  const OrgSettingsCard({super.key, required this.provider});

  @override
  State<OrgSettingsCard> createState() => _OrgSettingsCardState();
}

class _OrgSettingsCardState extends State<OrgSettingsCard> {
  late final TextEditingController _legalCtrl;
  late final TextEditingController _commCtrl;
  late final TextEditingController _taxIdCtrl;
  late final TextEditingController _rateCtrl;
  late final TextEditingController _taxRateCtrl;

  @override
  void initState() {
    super.initState();
    _legalCtrl = TextEditingController(text: widget.provider.legalName);
    _commCtrl = TextEditingController(text: widget.provider.commercialName);
    _taxIdCtrl = TextEditingController(text: widget.provider.taxId);
    _rateCtrl = TextEditingController(
      text: widget.provider.exchangeRate.toString(),
    );
    _taxRateCtrl = TextEditingController(
      text: (widget.provider.defaultTaxRate * 100).toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _legalCtrl.dispose();
    _commCtrl.dispose();
    _taxIdCtrl.dispose();
    _rateCtrl.dispose();
    _taxRateCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.provider.updateOrganization(
      legalName: _legalCtrl.text,
      commercialName: _commCtrl.text,
      taxId: _taxIdCtrl.text,
    );
    final rate =
        double.tryParse(_rateCtrl.text) ?? widget.provider.exchangeRate;
    widget.provider.updateCurrencies(
      base: widget.provider.baseCurrency,
      secondary: widget.provider.secondaryCurrency,
      rate: rate,
    );
    final tax = double.tryParse(_taxRateCtrl.text);
    if (tax != null) {
      widget.provider.updateTaxRate(tax / 100.0);
    }
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showSuccess(context, l10n.changesSavedSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.corporateAndTaxConfig,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildField(l10n.legalName, _legalCtrl),
            const SizedBox(height: 12),
            _buildField(l10n.commercialBrand, _commCtrl),
            const SizedBox(height: 12),
            _buildField(l10n.taxIdRucLabel, _taxIdCtrl),
            const SizedBox(height: 12),
            _buildCurrencyRow(l10n),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                icon: const Icon(Icons.check, size: 18),
                label: Text(l10n.saveChanges),
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyRow(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildField(l10n.exchangeRateLabel, _rateCtrl)),
        const SizedBox(width: 12),
        Expanded(child: _buildField(l10n.salesTaxRatePercent, _taxRateCtrl)),
      ],
    );
  }
}
