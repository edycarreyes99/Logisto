import 'package:flutter/material.dart';
import '../../../core/enums/user_role_enum.dart';
import '../../../core/enums/user_status_enum.dart';
import '../../../domain/models/user_profile_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/app_feedback.dart';
import '../../common/enum_localization_extensions.dart';
import '../user_management_provider.dart';

/// Modal dialog for editing a collaborator's branch role, superadmin privilege,
/// terminal PIN, and active status.
class EditUserRoleModal extends StatefulWidget {
  final UserProfileModel user;
  final String activeBuId;
  final UserManagementProvider provider;

  const EditUserRoleModal({
    super.key,
    required this.user,
    required this.activeBuId,
    required this.provider,
  });

  @override
  State<EditUserRoleModal> createState() => _EditUserRoleModalState();
}

class _EditUserRoleModalState extends State<EditUserRoleModal> {
  late UserRoleEnum _selectedRole;
  late bool _isSuperAdmin;
  late UserStatusEnum _status;
  late final TextEditingController _pinController;
  late final TextEditingController _nameController;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _selectedRole =
        widget.user.businessUnitRoles[widget.activeBuId] ??
        UserRoleEnum.cashier;
    _isSuperAdmin = widget.user.isSuperAdmin;
    _status = widget.user.status;
    _pinController = TextEditingController(
      text: widget.user.pinHash.isNotEmpty ? widget.user.pinHash : '',
    );
    _nameController = TextEditingController(text: widget.user.displayName);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      final updated = widget.user.copyWith(
        displayName: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : widget.user.displayName,
        isSuperAdmin: _isSuperAdmin,
        pinHash: _pinController.text.trim(),
        status: _status,
      );

      await widget.provider.updateUser(updated);
      await widget.provider.updateUserRole(
        orgId: widget.user.orgId,
        userId: widget.user.uid,
        buId: widget.activeBuId,
        role: _selectedRole,
      );

      if (mounted) {
        Navigator.of(context).pop();
        final l10n = AppLocalizations.of(context)!;
        AppFeedback.showSuccess(
          context,
          '${l10n.save}: ${widget.user.displayName}',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);
    try {
      await widget.provider.deleteUser(
        orgId: widget.user.orgId,
        userId: widget.user.uid,
      );
      if (mounted) {
        Navigator.of(context).pop();
        final l10n = AppLocalizations.of(context)!;
        AppFeedback.showWarning(
          context,
          '${l10n.delete}: ${widget.user.displayName}',
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        l10n.editStaffTitle(widget.user.displayName),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(width: 480, child: _buildFormContent(l10n)),
      ),
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          icon: _isDeleting
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.delete_outline, size: 16),
          onPressed: (_isSaving || _isDeleting) ? null : _handleDelete,
          label: Text(l10n.delete),
        ),
        TextButton(
          onPressed: (_isSaving || _isDeleting)
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
        FilledButton.icon(
          icon: _isSaving
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check, size: 16),
          onPressed: (_isSaving || _isDeleting) ? null : _handleSave,
          label: Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildFormContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(label: l10n.userName, controller: _nameController),
        const SizedBox(height: 12),
        Text(
          '${l10n.userRole} (${widget.activeBuId}):',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        _buildRoleWrap(l10n),
        const SizedBox(height: 12),
        _buildPinAndStatusRow(l10n),
        const SizedBox(height: 12),
        _buildSuperAdminSwitch(l10n),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
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

  Widget _buildRoleWrap(AppLocalizations l10n) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: UserRoleEnum.values.map((role) {
        final isSelected = _selectedRole == role;
        if (isSelected) {
          return FilledButton(
            style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
            onPressed: () => setState(() => _selectedRole = role),
            child: Text(role.localizedTitle(l10n)),
          );
        }
        return OutlinedButton(
          style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
          onPressed: () => setState(() => _selectedRole = role),
          child: Text(role.localizedTitle(l10n)),
        );
      }).toList(),
    );
  }

  Widget _buildPinAndStatusRow(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.terminalPin,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _pinController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tableHeaderStatus,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () {
                  setState(() {
                    _status = _status == UserStatusEnum.active
                        ? UserStatusEnum.inactive
                        : UserStatusEnum.active;
                  });
                },
                child: Text(
                  _status == UserStatusEnum.active
                      ? l10n.statusActiveTitle
                      : l10n.statusInactiveTitle,
                ),
              ),
            ],
          ),
        ),
      ],
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
