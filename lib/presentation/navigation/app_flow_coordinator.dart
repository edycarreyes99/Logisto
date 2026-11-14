import 'package:flutter/material.dart';
import '../../data/firestore/firestore_client.dart';
import '../../data/preferences/app_preferences.dart';
import '../../data/repositories/business_unit_repository.dart';
import '../../data/repositories/organization_repository.dart';
import '../../locator.dart';
import '../auth/login_provider.dart';
import '../auth/login_screen.dart';
import '../business_units/business_unit_selector_screen.dart';
import '../context/business_context_provider.dart';
import '../onboarding/onboarding_wizard_screen.dart';
import 'app_routes.dart';
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
  bool _isBootstrapping = false;

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
    if (_isBootstrapping) return;
    _isBootstrapping = true;

    try {
      var savedOrgId = _preferences.getActiveOrgId();
      final client = locator.isRegistered<FirestoreClient>()
          ? locator<FirestoreClient>()
          : null;

      // 1. If no savedOrgId, try finding an existing organization in Firestore
      if ((savedOrgId == null || savedOrgId.isEmpty) && client != null) {
        try {
          final snap = await client.organizations
              .limit(1)
              .get()
              .timeout(const Duration(seconds: 4));
          if (snap.docs.isNotEmpty) {
            savedOrgId = snap.docs.first.id;
            await _preferences.saveActiveOrgId(savedOrgId);
          }
        } catch (_) {}
      }

      // 2. If organization ID exists, fetch org and business units
      if (savedOrgId != null && savedOrgId.isNotEmpty) {
        try {
          final orgRepo = locator<OrganizationRepository>();
          final buRepo = locator<BusinessUnitRepository>();
          final org = await orgRepo
              .getOrganization(savedOrgId)
              .timeout(const Duration(seconds: 4));
          if (org != null) {
            final units = await buRepo
                .getBusinessUnits(savedOrgId)
                .timeout(const Duration(seconds: 4));
            await _contextProvider.initializeContext(
              organization: org,
              units: units,
            );
          } else {
            // Organization was removed or environment reset; trigger genuine onboarding
            await _preferences.setOnboardingCompleted(false);
            await _preferences.saveActiveOrgId('');
            await _preferences.saveActiveBuId('');
          }
        } catch (_) {
          if (_contextProvider.activeOrganization == null) {
            await _preferences.setOnboardingCompleted(false);
          }
        }
      } else if (_preferences.isOnboardingCompleted()) {
        // Onboarding was flagged true, but no organization ID exists in preferences or DB
        await _preferences.setOnboardingCompleted(false);
      }
    } finally {
      _isBootstrapping = false;
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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

        // Check if organization context needs resolution upon authentication
        if (_contextProvider.activeOrganization == null &&
            _preferences.isOnboardingCompleted()) {
          if (!_isBootstrapping) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _bootstrapFlow();
            });
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
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
        if (_navProvider.currentRoute == AppRoutes.login) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navProvider.navigateTo(AppRoutes.dashboard);
          });
        }
        return const NavigationShell();
      },
    );
  }
}
