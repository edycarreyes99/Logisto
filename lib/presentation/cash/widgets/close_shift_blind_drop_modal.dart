import 'package:flutter/material.dart';
import '../../../core/enums/shift_status_enum.dart';
import '../../../domain/services/cash_shift_calculator.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../../common/enum_localization_extensions.dart';
import '../cash_shift_provider.dart';

/// Modal dialog executing blind drop cash reconciliation (Corte Z).
class CloseShiftBlindDropModal extends StatefulWidget {
  final CashShiftProvider provider;

  const CloseShiftBlindDropModal({super.key, required this.provider});

  @override
  State<CloseShiftBlindDropModal> createState() =>
      _CloseShiftBlindDropModalState();
}

class _CloseShiftBlindDropModalState extends State<CloseShiftBlindDropModal> {
  final TextEditingController _countedCtrl = TextEditingController();
  ShiftReconciliationResult? _result;

  @override
  void dispose() {
    _countedCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitCount() async {
    final counted = double.tryParse(_countedCtrl.text) ?? 0.0;
    final res = await widget.provider.closeShiftBlindDrop(
      actualCounted: counted,
    );
    if (!mounted) return;
    setState(() => _result = res);
    if (res != null) {
      if (res.discrepancyStatus == ShiftDiscrepancyEnum.balanced) {
        AppFeedback.showSuccess(context, 'Cierre Z procesado con balance exacto');
      } else if (res.difference < 0) {
        AppFeedback.showWarning(
          context,
          'Cierre Z con faltante de \$${res.difference.abs().toStringAsFixed(2)}',
        );
      } else {
        AppFeedback.showWarning(
          context,
          'Cierre Z con sobrante de \$${res.difference.toStringAsFixed(2)}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        l10n.blindDropShiftClosure,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: _result == null
            ? _buildCountForm(l10n)
            : _buildReconciliationReport(l10n, theme),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_result == null ? l10n.cancel : l10n.finishPrintZCut),
        ),
        if (_result == null)
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            onPressed: _submitCount,
            child: Text(l10n.submitBlindCount),
          ),
      ],
    );
  }

  Widget _buildCountForm(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.blindDropSecurityRule),
        const SizedBox(height: 16),
        TextField(
          controller: _countedCtrl,
          decoration: InputDecoration(
            labelText: l10n.physicalCountedAmountPlaceholder,
            hintText: l10n.physicalCountedAmountPlaceholder,
            border: const OutlineInputBorder(),
            prefixText: '\$ ',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildReconciliationReport(AppLocalizations l10n, ThemeData theme) {
    final diff = _result!.difference;
    final status = _result!.discrepancyStatus;
    final isBalanced = status == ShiftDiscrepancyEnum.balanced;
    final alertColor = isBalanced
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.errorContainer;
    final onAlertColor = isBalanced
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onErrorContainer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: alertColor,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              l10n.reconciliationStatus(
                status.localizedTitle(l10n).toUpperCase(),
              ),
              style: TextStyle(
                color: onAlertColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildReportRow(
          l10n.expectedBalance,
          '\$${_result!.expectedBalance.toStringAsFixed(2)}',
        ),
        _buildReportRow(
          l10n.physicalCountedLabel,
          '\$${_result!.actualCounted.toStringAsFixed(2)}',
        ),
        const Divider(height: 16),
        _buildReportRow(
          l10n.varianceDiscrepancyLabel,
          '${diff >= 0 ? "+" : ""}\$${diff.toStringAsFixed(2)}',
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildReportRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
