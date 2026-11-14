import 'package:flutter/foundation.dart';
import '../../core/enums/business_type_enum.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/repositories/business_unit_repository.dart';
import '../../domain/models/business_unit_model.dart';
import '../context/business_context_provider.dart';

/// Provider for managing business unit listings, branch switching,
/// and adding new operational units.
class BusinessUnitSelectorProvider extends ChangeNotifier {
  final BusinessUnitRepository repository;
  final BusinessContextProvider contextProvider;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  List<BusinessUnitModel> _units = [];

  BusinessUnitSelectorProvider({
    required this.repository,
    required this.contextProvider,
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
    required String name,
    required BusinessTypeEnum type,
    required String address,
  }) async {
    final newUnit = BusinessUnitModel(
      id: 'bu_${DateTime.now().millisecondsSinceEpoch}',
      orgId: orgId,
      name: name,
      taxId: 'J0310000123-${_units.length + 1}',
      phone: '555-0199',
      address: address,
      businessType: type,
      isBilliardHall: type == BusinessTypeEnum.billiard,
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
