import 'package:flutter/foundation.dart';
import '../../core/enums/user_role_enum.dart';
import 'app_routes.dart';

/// State provider for application route transitions, active screen management,
/// and role-based module visibility.
class NavigationProvider extends ChangeNotifier {
  String _currentRoute = AppRoutes.dashboard;
  UserRoleEnum _currentUserRole = UserRoleEnum.superAdminOrg;
  bool _isDrawerOpen = false;

  String get currentRoute => _currentRoute;
  UserRoleEnum get currentUserRole => _currentUserRole;
  bool get isDrawerOpen => _isDrawerOpen;

  /// Changes the active operational route and notifies listeners.
  void navigateTo(String route) {
    if (_currentRoute == route) return;
    _currentRoute = route;
    _isDrawerOpen = false;
    notifyListeners();
  }

  /// Sets current user role for navigation filtering.
  void setUserRole(UserRoleEnum role) {
    _currentUserRole = role;
    notifyListeners();
  }

  /// Toggles responsive offcanvas drawer state.
  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  /// Explicitly closes drawer.
  void closeDrawer() {
    if (_isDrawerOpen) {
      _isDrawerOpen = false;
      notifyListeners();
    }
  }
}
