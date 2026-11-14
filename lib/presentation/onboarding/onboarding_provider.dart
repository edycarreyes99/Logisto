import 'package:flutter/foundation.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/firestore/database_seeder.dart';
import '../../data/preferences/app_preferences.dart';
import '../../data/repositories/business_unit_repository.dart';
import '../../data/repositories/organization_repository.dart';
import '../../domain/models/business_unit_model.dart';
import '../../domain/models/organization_model.dart';
import '../../locator.dart';
import '../context/business_context_provider.dart';

/// State provider orchestrating the 4-step onboarding wizard for new corporate tenants.
class OnboardingProvider extends ChangeNotifier {
  final AppPreferences preferences;
  final OrganizationRepository? orgRepository;
  final BusinessUnitRepository? buRepository;
  final DatabaseSeeder? seeder;

  int _currentStep = 1;
  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;

  // Form step state
  String _orgName = '';
  String _taxId = '';
  String _branchName = '';
  BusinessTypeEnum _businessType = BusinessTypeEnum.billiard;
  int _initialTables = 4;
  double _hourlyRate = 10.0;
  bool _seedDemoData = true;

  OnboardingProvider({
    required this.preferences,
    this.orgRepository,
    this.buRepository,
    this.seeder,
  });

  int get currentStep => _currentStep;
  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get orgName => _orgName;
  String get taxId => _taxId;
  String get branchName => _branchName;
  BusinessTypeEnum get businessType => _businessType;
  int get initialTables => _initialTables;
  double get hourlyRate => _hourlyRate;
  bool get seedDemoData => _seedDemoData;

  void setOrgDetails(String name, String tax) {
    _orgName = name;
    _taxId = tax;
    notifyListeners();
  }

  void setBranchDetails(String name, BusinessTypeEnum type) {
    _branchName = name;
    _businessType = type;
    notifyListeners();
  }

  void setBilliardConfig(int tables, double rate) {
    _initialTables = tables;
    _hourlyRate = rate;
    notifyListeners();
  }

  void setSeedDemo(bool seed) {
    _seedDemoData = seed;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 4) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Finalizes setup, registers initial records, and marks onboarding complete.
  Future<bool> completeOnboarding() async {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 50));

    final orgId = 'org_${DateTime.now().millisecondsSinceEpoch}';
    final buId = 'bu_${DateTime.now().millisecondsSinceEpoch}';

    await preferences.saveActiveOrgId(orgId);
    await preferences.saveActiveBuId(buId);
    await preferences.setOnboardingCompleted(true);

    final org = buildOrganizationModel().copyWith(id: orgId);
    final bu = buildBusinessUnitModel().copyWith(id: buId, orgId: orgId);

    if (_seedDemoData && seeder != null) {
      try {
        await seeder!.seedProductionData(orgId: DatabaseSeeder.defaultOrgId);
        await preferences.saveActiveOrgId(DatabaseSeeder.defaultOrgId);
        await preferences.saveActiveBuId(DatabaseSeeder.defaultBuCentralId);
      } catch (_) {}
    } else {
      if (orgRepository != null) {
        try {
          await orgRepository!.saveOrganization(org);
        } catch (_) {}
      }
      if (buRepository != null) {
        try {
          await buRepository!.saveBusinessUnit(orgId: orgId, businessUnit: bu);
        } catch (_) {}
      }
    }

    if (locator.isRegistered<BusinessContextProvider>()) {
      final contextProvider = locator<BusinessContextProvider>();
      if (_seedDemoData && seeder != null) {
        if (buRepository != null) {
          try {
            final units = await buRepository!.getBusinessUnits(
              DatabaseSeeder.defaultOrgId,
            );
            await contextProvider.initializeContext(
              organization: OrganizationModel(
                id: DatabaseSeeder.defaultOrgId,
                legalName: 'Inversiones Castillo Machado S.A.',
                commercialName: 'Castillo Machado',
                taxId: 'J0310000123456',
                ownerUserId: 'user_admin',
                hasCompletedOnboarding: true,
                createdAt: DateTime.now(),
              ),
              units: units,
            );
          } catch (_) {}
        }
      } else {
        await contextProvider.initializeContext(organization: org, units: [bu]);
      }
    }

    _status = FeatureStatusEnum.loaded;
    notifyListeners();
    return true;
  }

  OrganizationModel buildOrganizationModel() {
    return OrganizationModel(
      id: 'org_main',
      legalName: _orgName.isEmpty ? 'My Enterprise Corp' : _orgName,
      commercialName: _orgName.isEmpty ? 'My Enterprise' : _orgName,
      taxId: _taxId.isEmpty ? 'J00000000' : _taxId,
      ownerUserId: 'owner_user_1',
      hasCompletedOnboarding: true,
      createdAt: DateTime.now(),
    );
  }

  BusinessUnitModel buildBusinessUnitModel() {
    return BusinessUnitModel(
      id: 'bu_main',
      orgId: 'org_main',
      name: _branchName.isEmpty ? 'Central Branch' : _branchName,
      taxId: _taxId.isEmpty ? 'J00000000-1' : '$_taxId-1',
      phone: '555-0100',
      address: 'Main Commercial Center',
      businessType: _businessType,
      isBilliardHall: _businessType == BusinessTypeEnum.billiard,
      createdAt: DateTime.now(),
    );
  }
}
