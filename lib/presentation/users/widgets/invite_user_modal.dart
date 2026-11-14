import 'package:flutter/material.dart';
import '../../../core/enums/user_role_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../../common/enum_localization_extensions.dart';
import '../user_management_provider.dart';

/// Modal dialog for registering a new team member and granting initial permissions.
class InviteUserModal extends StatefulWidget {
  final String orgId;
  final UserManagementProvider provider;

  const InviteUserModal({
    super.key,
    required this.orgId,
    required this.provider,
  });

  @override
  State<InviteUserModal> createState() => _InviteUserModalState();
}

class _InviteUserModalState extends State<InviteUserModal> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pinCtrl = TextEditingController(text: '1234');
  bool _isSuperAdmin = false;
  UserRoleEnum _selectedRole = UserRoleEnum.cashier;

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    if (name.isEmpty || email.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    await widget.provider.createUser(
      orgId: widget.orgId,
      email: email,
      displayName: name,
      isSuperAdmin: _isSuperAdmin,
      terminalPin: _pinCtrl.text.trim(),
      initialRoles: {'bu_matriz_central': _selectedRole},
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    final l10n = AppLocalizations.of(context)!;
    AppFeedback.showSuccess(context, '${l10n.inviteEmployee}: $name');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        l10n.inviteNewEmployee,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 480,
          child: _buildFormBody(l10n),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.send_rounded, size: 18),
          label: Text(l10n.save),
          onPressed: _isSubmitting ? null : _handleSubmit,
        ),
      ],
    );
  }

  Widget _buildFormBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(label: l10n.userName, controller: _nameCtrl),
        const SizedBox(height: 12),
        _buildTextField(
          label: l10n.emailLabel,
          controller: _emailCtrl,
          hint: 'colaborador@logisto.com',
        ),
        const SizedBox(height: 12),
        _buildTextField(
          label: l10n.terminalPin,
          controller: _pinCtrl,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.userRole,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        _buildRoleWrap(l10n),
        const SizedBox(height: 12),
        _buildSuperAdminSwitch(l10n),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
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

  Widget _buildRoleWrap(AppLocalizations l10n) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: UserRoleEnum.values.map((role) {
        final isSelected = _selectedRole == role;
        if (isSelected) {
          return FilledButton(
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => setState(() => _selectedRole = role),
            child: Text(role.localizedTitle(l10n)),
          );
        }
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () => setState(() => _selectedRole = role),
          child: Text(role.localizedTitle(l10n)),
        );
      }).toList(),
    );
  }

  Widget _buildSuperAdminSwitch(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
        onPressed: () => setState(() => _isSuperAdmin = !_isSuperAdmin),
        child: Text(_isSuperAdmin ? l10n.superAdminYes : l10n.superAdminNo),
      ),
    );
  }
}
