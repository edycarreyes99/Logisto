import 'package:flutter/material.dart';
import '../../../domain/models/business_unit_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/enum_localization_extensions.dart';

/// Card displaying branch details, business segment, and selection action.
class BusinessUnitCard extends StatelessWidget {
  final BusinessUnitModel unit;
  final bool isSelected;
  final VoidCallback onSelect;

  const BusinessUnitCard({
    super.key,
    required this.unit,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(l10n, theme),
            const SizedBox(height: 12),
            Text(
              '${l10n.physicalAddress}: ${unit.address}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.phone}: ${unit.phone}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(AppLocalizations l10n, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            unit.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text(
            unit.businessType.localizedTitle(l10n),
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          backgroundColor: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActionButton(AppLocalizations l10n) {
    if (isSelected) {
      return OutlinedButton.icon(
        icon: const Icon(Icons.check_circle, size: 18),
        label: Text(l10n.activeBranchBadge),
        onPressed: onSelect,
      );
    }
    return FilledButton.icon(
      icon: const Icon(Icons.arrow_circle_right_outlined, size: 18),
      label: Text(l10n.selectBranch),
      onPressed: onSelect,
    );
  }
}
