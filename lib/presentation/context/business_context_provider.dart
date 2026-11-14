import 'package:flutter/foundation.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/preferences/app_preferences.dart';
import '../../domain/models/business_unit_model.dart';
import '../../domain/models/organization_model.dart';

/// Application session controller managing the active Organization and Business Unit (sucursal).
/// Conforms to RULE-ARCH-001 (Layered Architecture Flow) and provider state standards.
class BusinessContextProvider extends ChangeNotifier {
  final AppPreferences preferences;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  OrganizationModel? _activeOrganization;
  BusinessUnitModel? _activeBusinessUnit;
  List<BusinessUnitModel> _availableUnits = [];
  String? _errorMessage;

  BusinessContextProvider({required this.preferences});

  FeatureStatusEnum get status => _status;
  OrganizationModel? get activeOrganization => _activeOrganization;
  BusinessUnitModel? get activeBusinessUnit => _activeBusinessUnit;
  List<BusinessUnitModel> get availableUnits =>
      List.unmodifiable(_availableUnits);
  String? get errorMessage => _errorMessage;

  /// Whether current active branch operates billiard tables.
  bool get isBilliardActive =>
      _activeBusinessUnit?.isBilliardHall ??
      (_activeBusinessUnit?.businessType == BusinessTypeEnum.billiard);

  /// Whether current active branch operates pharmacy-specific batch tracking.
  bool get isPharmacyActive =>
      _activeBusinessUnit?.businessType == BusinessTypeEnum.pharmacy;

  /// Initializes active context from local preferences.
  Future<void> initializeContext({
    required OrganizationModel organization,
    required List<BusinessUnitModel> units,
  }) async {
    _status = FeatureStatusEnum.loading;
    notifyListeners();

    try {
      _activeOrganization = organization;
      _availableUnits = units;

      final savedBuId = preferences.getActiveBuId();
      if (savedBuId != null && units.any((u) => u.id == savedBuId)) {
        _activeBusinessUnit = units.firstWhere((u) => u.id == savedBuId);
      } else if (units.length == 1) {
        _activeBusinessUnit = units.first;
        await preferences.saveActiveBuId(_activeBusinessUnit!.id);
      } else {
        _activeBusinessUnit = null;
      }

      await preferences.saveActiveOrgId(organization.id);
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  /// Switches active business unit context and persists selection locally.
  Future<void> switchBusinessUnit(BusinessUnitModel unit) async {
    _activeBusinessUnit = unit;
    await preferences.saveActiveBuId(unit.id);
    notifyListeners();
  }

  /// Clears active organization and business unit session upon logout.
  Future<void> clearContext() async {
    _activeOrganization = null;
    _activeBusinessUnit = null;
    _availableUnits = [];
    _status = FeatureStatusEnum.idle;
    _errorMessage = null;
    await preferences.clearSession();
    await preferences.clearOrganizationContext();
    notifyListeners();
  }
}
