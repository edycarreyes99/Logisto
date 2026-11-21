import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../../core/enums/business_category_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../business_unit_selector_provider.dart';

/// Modal dialog for registering a new business unit (branch/sucursal)
/// with full category selection and localized required fields.
class AddBusinessUnitDialog extends StatefulWidget {
  final BusinessUnitSelectorProvider provider;
  final String orgId;
  final VoidCallback? onSuccess;

  const AddBusinessUnitDialog({
    super.key,
    required this.provider,
    required this.orgId,
    this.onSuccess,
  });

  @override
  State<AddBusinessUnitDialog> createState() => _AddBusinessUnitDialogState();
}

class _AddBusinessUnitDialogState extends State<AddBusinessUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();

  BusinessCategoryEnum? _selectedCategory;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _dniCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;
    final bName = _nameCtrl.text.trim();

    try {
      await widget.provider.addUnit(
        orgId: widget.orgId,
        category: _selectedCategory!,
        name: bName,
        address: _addressCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        dni: _dniCtrl.text.trim(),
      );

      if (mounted) {
        widget.onSuccess?.call();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DialogHeader(title: l10n.registerNewBranch, isSaving: _isSaving),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: _DialogFormFields(
                      l10n: l10n,
                      nameCtrl: _nameCtrl,
                      addressCtrl: _addressCtrl,
                      cityCtrl: _cityCtrl,
                      phoneCtrl: _phoneCtrl,
                      dniCtrl: _dniCtrl,
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _DialogActions(
                  isSaving: _isSaving,
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final bool isSaving;

  const _DialogHeader({
    required this.title,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.storefront_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _DialogFormFields extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController nameCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController dniCtrl;
  final BusinessCategoryEnum? selectedCategory;
  final ValueChanged<BusinessCategoryEnum?> onCategoryChanged;

  const _DialogFormFields({
    required this.l10n,
    required this.nameCtrl,
    required this.addressCtrl,
    required this.cityCtrl,
    required this.phoneCtrl,
    required this.dniCtrl,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BsContainer(
      padding: EdgeInsets.zero,
      child: BsRow(
        children: [
          BsCol(
            config: const BsColConfig(xs: 12),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _CategoryDropdown(
                l10n: l10n,
                selectedCategory: selectedCategory,
                onChanged: onCategoryChanged,
              ),
            ),
          ),
          BsCol(
            config: const BsColConfig(xs: 12, md: 6),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _FormTextField(
                controller: nameCtrl,
                label: l10n.branchName,
                prefixIcon: Icons.business,
                requiredMessage: l10n.fieldRequired,
              ),
            ),
          ),
          BsCol(
            config: const BsColConfig(xs: 12, md: 6),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _FormTextField(
                controller: dniCtrl,
                label: l10n.dniLabel,
                hint: l10n.dniHint,
                prefixIcon: Icons.badge_outlined,
                requiredMessage: l10n.fieldRequired,
              ),
            ),
          ),
          BsCol(
            config: const BsColConfig(xs: 12),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _FormTextField(
                controller: addressCtrl,
                label: l10n.physicalAddress,
                prefixIcon: Icons.location_on_outlined,
                requiredMessage: l10n.fieldRequired,
              ),
            ),
          ),
          BsCol(
            config: const BsColConfig(xs: 12, md: 6),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _FormTextField(
                controller: cityCtrl,
                label: l10n.businessCityLabel,
                hint: l10n.businessCityHint,
                prefixIcon: Icons.location_city_outlined,
                requiredMessage: l10n.fieldRequired,
              ),
            ),
          ),
          BsCol(
            config: const BsColConfig(xs: 12, md: 6),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _FormTextField(
                controller: phoneCtrl,
                label: l10n.cellPhoneLabel,
                hint: l10n.cellPhoneHint,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                requiredMessage: l10n.fieldRequired,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final AppLocalizations l10n;
  final BusinessCategoryEnum? selectedCategory;
  final ValueChanged<BusinessCategoryEnum?> onChanged;

  const _CategoryDropdown({
    required this.l10n,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BusinessCategoryEnum>(
      initialValue: selectedCategory,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.businessCategoryLabel,
        hintText: l10n.businessCategoryHint,
        prefixIcon: const Icon(Icons.category_outlined),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: BusinessCategoryEnum.values.map((cat) {
        return DropdownMenuItem<BusinessCategoryEnum>(
          value: cat,
          child: Text(
            cat.displayName,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? l10n.categoryRequired : null,
    );
  }
}

class _FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final String requiredMessage;
  final TextInputType keyboardType;

  const _FormTextField({
    required this.controller,
    required this.label,
    this.hint,
    required this.prefixIcon,
    required this.requiredMessage,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return requiredMessage;
        }
        return null;
      },
    );
  }
}

class _DialogActions extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _DialogActions({
    required this.isSaving,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isSaving ? null : onCancel,
          child: Text(l10n.cancel),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: isSaving ? null : onSubmit,
          icon: isSaving
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.check, size: 18),
          label: Text(l10n.createBranch),
        ),
      ],
    );
  }
}
