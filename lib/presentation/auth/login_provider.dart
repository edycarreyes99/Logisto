import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../data/preferences/app_preferences.dart';

/// State provider for corporate authentication, OAuth triggers,
/// and terminal-level fast PIN switching.
class LoginProvider extends ChangeNotifier {
  final AppPreferences preferences;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  String? _errorCode;
  bool _isAuthenticated = false;
  bool _isPinLocked = false;
  String? _currentUserName;

  LoginProvider({required this.preferences});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String? get errorCode => _errorCode;
  bool get isAuthenticated => _isAuthenticated;
  bool get isPinLocked => _isPinLocked;
  String? get currentUserName => _currentUserName;

  /// Authenticates user credentials.
  Future<bool> signInWithEmailPassword(String email, String password) async {
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 50));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      _errorCode = 'email_password_required';
      _errorMessage = 'Email and password are required.';
      _status = FeatureStatusEnum.error;
      notifyListeners();
      return false;
    }

    _isAuthenticated = true;
    _isPinLocked = false;
    _currentUserName = email.split('@').first;
    await preferences.saveSession(
      token: 'token_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_admin',
    );
    _status = FeatureStatusEnum.loaded;
    notifyListeners();
    return true;
  }

  /// Fast PIN unlock for shared POS workstations.
  Future<bool> unlockWithPin(String pin) async {
    if (pin.length != 4) {
      _errorMessage = 'PIN must be exactly 4 digits.';
      notifyListeners();
      return false;
    }

    _isPinLocked = false;
    _currentUserName = 'Operator ($pin)';
    notifyListeners();
    return true;
  }

  /// Locks workstation requiring PIN to re-enter.
  void lockTerminal() {
    _isPinLocked = true;
    notifyListeners();
  }

  /// Signs out completely and clears session.
  Future<void> signOut() async {
    await preferences.clearSession();
    _isAuthenticated = false;
    _isPinLocked = false;
    _currentUserName = null;
    _status = FeatureStatusEnum.idle;
    notifyListeners();
  }
}
