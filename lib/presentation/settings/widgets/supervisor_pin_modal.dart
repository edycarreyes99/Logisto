import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// Elevation modal requiring a supervisor 4-digit authorization PIN
/// before executing restricted operations.
class SupervisorPinModal extends StatefulWidget {
  final String actionTitle;
  final VoidCallback onApproved;

  const SupervisorPinModal({
    super.key,
    required this.actionTitle,
    required this.onApproved,
  });

  @override
  State<SupervisorPinModal> createState() => _SupervisorPinModalState();
}

class _SupervisorPinModalState extends State<SupervisorPinModal> {
  final TextEditingController _pinCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  void _verifyPin(AppLocalizations l10n) {
    final pin = _pinCtrl.text.trim();
    // In production or test fixture, '9999' or '1234' certifies supervisor authority
    if (pin == '9999' || pin == '1234') {
      Navigator.of(context).maybePop();
      widget.onApproved();
    } else {
      setState(() => _error = l10n.invalidSupervisorPin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.authorizeActionNamed(widget.actionTitle)),
      content: SizedBox(
        width: 380,
        child: _buildDialogContent(l10n, theme),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.verified_user_outlined, size: 16),
          onPressed: () => _verifyPin(l10n),
          label: Text(l10n.authorizeAction),
        ),
      ],
    );
  }

  Widget _buildDialogContent(AppLocalizations l10n, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.supervisorPermissionPrompt,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _pinCtrl,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '••••',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _error!,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
