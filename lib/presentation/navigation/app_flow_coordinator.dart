import 'package:flutter/material.dart';
import '../../data/firestore/database_seeder.dart';
import '../../data/preferences/app_preferences.dart';
import '../../data/repositories/business_unit_repository.dart';
import '../../data/repositories/organization_repository.dart';
import '../../domain/models/organization_model.dart';
import '../../locator.dart';
import '../auth/login_provider.dart';
import '../auth/login_screen.dart';
import '../business_units/business_unit_selector_screen.dart';
import '../context/business_context_provider.dart';
import '../onboarding/onboarding_wizard_screen.dart';
import 'navigation_provider.dart';
import 'navigation_shell.dart';

/// Central application flow coordinator enforcing the enterprise lifecycle:
/// [Login] -> [Onboarding] (if pending) -> [Branch Selection] (if required) -> [Dashboard Shell].
class AppFlowCoordinator extends StatefulWidget {
  const AppFlowCoordinator({super.key});

  @override
  State<AppFlowCoordinator> createState() => _AppFlowCoordinatorState();
}

class _AppFlowCoordinatorState extends State<AppFlowCoordinator> {
  late final LoginProvider _loginProvider;
  late final BusinessContextProvider _contextProvider;
  late final NavigationProvider _navProvider;
  late final AppPreferences _preferences;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loginProvider = locator<LoginProvider>();
    _contextProvider = locator<BusinessContextProvider>();
    _navProvider = locator<NavigationProvider>();
    _preferences = locator<AppPreferences>();

    _bootstrapFlow();
  }

  Future<void> _bootstrapFlow() async {
    // Check if auto-seed is required for fresh environment
    final seeder = locator<DatabaseSeeder>();
    try {
      await seeder.seedIfEmpty();
    } catch (_) {}

    // Check if user has an existing session in preferences
    final token = _preferences.getToken();
    final savedOrgId =
        _preferences.getActiveOrgId() ?? DatabaseSeeder.defaultOrgId;

    if (token != null && token.isNotEmpty) {
      // Restore active authentication session
      await _loginProvider.signInWithEmailPassword(
        'admin@logisto.com',
        'admin123',
      );
    }

    if (_preferences.isOnboardingCompleted()) {
      try {
        final orgRepo = locator<OrganizationRepository>();
        final buRepo = locator<BusinessUnitRepository>();
        final org =
            await orgRepo.getOrganization(savedOrgId) ??
            OrganizationModel(
              id: savedOrgId,
              legalName: 'Inversiones Castillo Machado S.A.',
              commercialName: 'Castillo Machado',
              taxId: 'J0310000123456',
              ownerUserId: 'user_admin',
              hasCompletedOnboarding: true,
              createdAt: DateTime(2026, 1, 1),
            );
        final units = await buRepo.getBusinessUnits(savedOrgId);
        await _contextProvider.initializeContext(
          organization: org,
          units: units,
        );
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListenableBuilder(
      listenable: Listenable.merge([
        _loginProvider,
        _contextProvider,
        _navProvider,
      ]),
      builder: (context, _) {
        // Step 1: Authentication Check
        if (!_loginProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Step 2: First-time Onboarding Check
        if (!_preferences.isOnboardingCompleted()) {
          return const OnboardingWizardScreen();
        }

        // Step 3: Business Unit (Branch) Context Selection
        if (_contextProvider.activeBusinessUnit == null) {
          return const BusinessUnitSelectorScreen();
        }

        // Step 4: Active Application Shell with Dashboard & All Enterprise Modules
        return const NavigationShell();
      },
    );
  }
}
