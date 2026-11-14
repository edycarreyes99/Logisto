import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../login_provider.dart';

/// Modal dialog for rapid 4-digit PIN employee switching on shared POS terminals.
class PinSwitchModal extends StatefulWidget {
  final LoginProvider provider;
  final VoidCallback onSuccess;

  const PinSwitchModal({
    super.key,
    required this.provider,
    required this.onSuccess,
  });

  @override
  State<PinSwitchModal> createState() => _PinSwitchModalState();
}

class _PinSwitchModalState extends State<PinSwitchModal> {
  final TextEditingController _pinController = TextEditingController();
  String? _error;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final pin = _pinController.text.trim();
      final ok = await widget.provider.unlockWithPin(pin);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop();
        widget.onSuccess();
        AppFeedback.showSuccess(context, 'Usuario desbloqueado con éxito');
      } else {
        final l10n = AppLocalizations.of(context)!;
        setState(() => _error = l10n.invalidPin);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        l10n.fastPinSwitch,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: _buildFormBody(l10n),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          icon: _isSubmitting
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.lock_open, size: 16),
          onPressed: _isSubmitting ? null : _submitPin,
          label: Text(l10n.unlock),
        ),
      ],
    );
  }

  Widget _buildFormBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.enterPinPrompt),
        const SizedBox(height: 12),
        TextField(
          controller: _pinController,
          obscureText: true,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, letterSpacing: 8),
          decoration: const InputDecoration(
            hintText: '••••',
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
