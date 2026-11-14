import 'package:flutter/material.dart';
import '../../core/enums/language_enum.dart';
import '../../core/enums/theme_mode_enum.dart';
import '../../data/preferences/app_preferences.dart';
import '../../domain/models/rbac_permission_model.dart';

/// State provider for enterprise organization settings, multi-currency parameters,
/// theme mode, bilingual localization preferences, and RBAC permission governance.
class SettingsProvider extends ChangeNotifier {
  final AppPreferences? preferences;

  late ThemeModeEnum _themeMode;
  late LanguageEnum _language;

  String _legalName = 'Inversiones Castillo Machado S.A.';
  String _commercialName = 'Castillo Machado';
  String _taxId = 'J0310000123456';
  String _baseCurrency = 'USD';
  String _secondaryCurrency = 'NIO';
  double _exchangeRate = 36.65;
  double _defaultTaxRate = 0.15;
  String _selectedSection = 'org';

  SettingsProvider({this.preferences}) {
    _themeMode = preferences?.getThemeMode() ?? ThemeModeEnum.light;
    _language = preferences?.hasLanguage() == true
        ? preferences!.getLanguage()
        : LanguageEnum.en;
  }

  ThemeModeEnum get themeMode => _themeMode;
  LanguageEnum get language => _language;

  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case ThemeModeEnum.dark:
        return ThemeMode.dark;
      case ThemeModeEnum.system:
        return ThemeMode.system;
      case ThemeModeEnum.light:
        return ThemeMode.light;
    }
  }

  Locale get flutterLocale => Locale(_language.code);

  String get legalName => _legalName;
  String get commercialName => _commercialName;
  String get taxId => _taxId;
  String get baseCurrency => _baseCurrency;
  String get secondaryCurrency => _secondaryCurrency;
  double get exchangeRate => _exchangeRate;
  double get defaultTaxRate => _defaultTaxRate;
  String get selectedSection => _selectedSection;

  Future<void> setThemeMode(ThemeModeEnum mode) async {
    _themeMode = mode;
    await preferences?.saveThemeMode(mode);
    notifyListeners();
  }

  Future<void> setLanguage(LanguageEnum lang) async {
    _language = lang;
    await preferences?.saveLanguage(lang);
    notifyListeners();
  }

  List<RbacPermissionModel> get rbacRoles => [
    RbacPermissionModel.superAdmin,
    RbacPermissionModel.cashier,
    const RbacPermissionModel(
      roleKey: 'WAITER',
      macroModules: {'open_accounts', 'billiard'},
      microPermissions: {'tabs.void_item'},
    ),
    const RbacPermissionModel(
      roleKey: 'KITCHEN_STAFF',
      macroModules: {'kds'},
      microPermissions: {},
    ),
  ];

  void setSection(String section) {
    _selectedSection = section;
    notifyListeners();
  }

  void updateOrganization({
    required String legalName,
    required String commercialName,
    required String taxId,
  }) {
    _legalName = legalName;
    _commercialName = commercialName;
    _taxId = taxId;
    notifyListeners();
  }

  void updateCurrencies({
    required String base,
    required String secondary,
    required double rate,
  }) {
    _baseCurrency = base;
    _secondaryCurrency = secondary;
    _exchangeRate = rate;
    notifyListeners();
  }

  void updateTaxRate(double rate) {
    _defaultTaxRate = rate;
    notifyListeners();
  }
}
