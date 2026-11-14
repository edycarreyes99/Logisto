import 'package:flutter/material.dart';
import '../../../core/enums/business_type_enum.dart';
import '../../../l10n/app_localizations.dart';
import '../../common/enum_localization_extensions.dart';
import '../onboarding_provider.dart';

/// Renders the active step content card for the onboarding wizard.
class OnboardingStepCard extends StatelessWidget {
  final OnboardingProvider provider;
  final TextEditingController orgNameController;
  final TextEditingController branchNameController;
  final TextEditingController rateController;

  const OnboardingStepCard({
    super.key,
    required this.provider,
    required this.orgNameController,
    required this.branchNameController,
    required this.rateController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    switch (provider.currentStep) {
      case 1:
        return _buildStep1Intro(l10n, theme);
      case 2:
        return _buildStep2Branch(l10n, theme);
      case 3:
        return _buildStep3Infrastructure(l10n, theme);
      case 4:
      default:
        return _buildStep4Finalize(l10n, theme);
    }
  }

  Widget _buildStep1Intro(AppLocalizations l10n, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.step1Title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            Text(l10n.step1Desc),
            const SizedBox(height: 16),
            TextField(
              controller: orgNameController,
              decoration: InputDecoration(
                labelText: l10n.step1Placeholder,
                hintText: l10n.step1Placeholder,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2Branch(AppLocalizations l10n, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.step2Title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            TextField(
              controller: branchNameController,
              decoration: InputDecoration(
                labelText: l10n.step2Placeholder,
                hintText: l10n.step2Placeholder,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.step2Segment,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: BusinessTypeEnum.values.map((type) {
                final isSelected = provider.businessType == type;
                return ChoiceChip(
                  label: Text(type.localizedTitle(l10n)),
                  selected: isSelected,
                  onSelected: (_) => provider.setBranchDetails(
                    branchNameController.text,
                    type,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3Infrastructure(AppLocalizations l10n, ThemeData theme) {
    final isBilliard = provider.businessType == BusinessTypeEnum.billiard;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.step3Title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            if (isBilliard) ...[
              Text(l10n.billiardSetupPrompt),
              const SizedBox(height: 12),
              TextField(
                controller: rateController,
                decoration: InputDecoration(
                  labelText: l10n.step3Placeholder,
                  hintText: l10n.step3Placeholder,
                  border: const OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              Text(l10n.retailSetupPrompt),
              const SizedBox(height: 12),
              Card(
                color: theme.colorScheme.primaryContainer,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    l10n.step3Alert,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep4Finalize(AppLocalizations l10n, ThemeData theme) {
    final orgName = provider.orgName.isEmpty ? l10n.companyLegalName : provider.orgName;
    final branchName = provider.branchName.isEmpty ? l10n.defaultBranchName : provider.branchName;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.step4Title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            Text(l10n.readyToLaunch),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.business_rounded, size: 18.0, color: theme.colorScheme.primary),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          orgName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.storefront_rounded, size: 18.0, color: theme.colorScheme.secondary),
                      const SizedBox(width: 8.0),
                      Expanded(child: Text(branchName)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
