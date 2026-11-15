import 'package:bootstrap_ui_flutter/bootstrap_ui_flutter.dart';
import 'package:flutter/material.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../locator.dart';
import '../auth/logout_dialog.dart';
import '../common/app_feedback.dart';
import '../common/logisto_scaffold.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_provider.dart';
import 'onboarding_provider.dart';
import 'widgets/onboarding_step_card.dart';

/// 4-step guided onboarding wizard configuring enterprise organization,
/// initial business unit, and infrastructure defaults.
class OnboardingWizardScreen extends StatefulWidget {
  const OnboardingWizardScreen({super.key});

  @override
  State<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends State<OnboardingWizardScreen> {
  late final OnboardingProvider _provider;
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController(
    text: '10.00',
  );

  @override
  void initState() {
    super.initState();
    _provider = locator<OnboardingProvider>();
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _branchNameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    _provider.setOrgDetails(_orgNameController.text.trim(), '');
    _provider.setBranchDetails(
      _branchNameController.text,
      _provider.businessType,
    );
    final rate = double.tryParse(_rateController.text) ?? 10.0;
    _provider.setBilliardConfig(4, rate);

    final ok = await _provider.completeOnboarding();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    if (ok) {
      AppFeedback.showSuccess(context, l10n.onboardingConfiguredSuccess);
      locator<NavigationProvider>().navigateTo(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) => LogistoScaffold(
        title: l10n.onboardingWizardTitle,
        isChild: _provider.currentStep > 1,
        onBack: _provider.previousStep,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: Theme.of(context).colorScheme.error,
            tooltip: l10n.logout,
            onPressed: () => showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
        body: BsContainer.fluid(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgressBar(l10n),
                const SizedBox(height: 24),
                OnboardingStepCard(
                  provider: _provider,
                  orgNameController: _orgNameController,
                  branchNameController: _branchNameController,
                  rateController: _rateController,
                ),
                const SizedBox(height: 24),
                _buildNavigationButtons(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(AppLocalizations l10n) {
    final value = _provider.currentStep / 4.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.stepCounter(_provider.currentStep),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(AppLocalizations l10n) {
    final isLast = _provider.currentStep == 4;
    final isLoading = _provider.status == FeatureStatusEnum.loading;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text(l10n.previousStep),
          onPressed: (_provider.currentStep == 1 || isLoading)
              ? null
              : _provider.previousStep,
        ),
        FilledButton.icon(
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(isLast ? Icons.check : Icons.arrow_forward, size: 18),
          label: Text(isLast ? l10n.launchSystem : l10n.nextStep),
          onPressed: isLoading
              ? null
              : (isLast ? _handleComplete : _provider.nextStep),
        ),
      ],
    );
  }
}
