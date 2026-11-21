import 'package:flutter/foundation.dart';
import '../../core/enums/business_category_enum.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/business_unit_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/business_unit_model.dart';
import '../auth/login_provider.dart';
import '../context/business_context_provider.dart';

/// Provider for managing business unit listings, role-based branch filtering,
/// branch switching, and adding new operational units.
class BusinessUnitSelectorProvider extends ChangeNotifier {
  final BusinessUnitRepository repository;
  final BusinessContextProvider contextProvider;
  final UserRepository? userRepository;
  final LoginProvider? loginProvider;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  List<BusinessUnitModel> _units = [];

  BusinessUnitSelectorProvider({
    required this.repository,
    required this.contextProvider,
    this.userRepository,
    this.loginProvider,
  });

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  List<BusinessUnitModel> get units => List.unmodifiable(_units);

  Future<void> loadBusinessUnits(String orgId) async {
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await repository.getBusinessUnits(orgId);

      // Check if user has specific role-based restrictions
      final currentUserId = loginProvider?.preferences.getUserId();
      if (userRepository != null && currentUserId != null && currentUserId.isNotEmpty) {
        try {
          final userProfile = await userRepository!.getUser(orgId, currentUserId);
          if (userProfile != null && !userProfile.isSuperAdmin) {
            // Filter to only business units where user has an assigned role
            _units = fetched.where((bu) => userProfile.businessUnitRoles.containsKey(bu.id)).toList();
            _status = FeatureStatusEnum.loaded;
            notifyListeners();
            return;
          }
        } catch (_) {}
      }

      _units = fetched;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _units = [];
      _status = FeatureStatusEnum.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> selectUnit(BusinessUnitModel unit) async {
    await contextProvider.switchBusinessUnit(unit);
  }

  Future<void> addUnit({
    required String orgId,
    required BusinessCategoryEnum category,
    required String name,
    required String address,
    required String city,
    required String phone,
    required String dni,
    BusinessTypeEnum? type,
  }) async {
    final effectiveType = type ?? category.defaultBusinessType;
    final newUnit = BusinessUnitModel(
      id: 'bu_${DateTime.now().millisecondsSinceEpoch}',
      orgId: orgId,
      name: name,
      taxId: dni,
      phone: phone,
      address: address,
      city: city,
      category: category,
      businessType: effectiveType,
      isBilliardHall: effectiveType == BusinessTypeEnum.billiard ||
          category == BusinessCategoryEnum.billar,
      createdAt: DateTime.now(),
    );

    try {
      await repository.saveBusinessUnit(orgId: orgId, businessUnit: newUnit);
      _units = [..._units, newUnit];
      notifyListeners();
    } catch (e) {
      _units = [..._units, newUnit];
      notifyListeners();
    }
  }
}
