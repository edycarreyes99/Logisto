import 'package:flutter/foundation.dart';
import '../../core/enums/feature_status_enum.dart';
import '../../core/enums/user_role_enum.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/user_profile_model.dart';

/// State provider for enterprise user administration, role assignment by branch,
/// and terminal security.
class UserManagementProvider extends ChangeNotifier {
  final UserRepository repository;

  FeatureStatusEnum _status = FeatureStatusEnum.idle;
  String? _errorMessage;
  List<UserProfileModel> _users = [];
  String _searchQuery = '';

  UserManagementProvider({required this.repository});

  FeatureStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<UserProfileModel> get users => List.unmodifiable(_users);

  List<UserProfileModel> get filteredUsers {
    if (_searchQuery.trim().isEmpty) return users;
    final q = _searchQuery.toLowerCase();
    return _users.where((u) {
      return u.displayName.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadUsers(String orgId) async {
    _status = FeatureStatusEnum.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.getUsers(orgId);
      _users = result;
      _status = FeatureStatusEnum.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FeatureStatusEnum.error;
    }
    notifyListeners();
  }

  Future<void> createUser({
    required String orgId,
    required String email,
    required String displayName,
    bool isSuperAdmin = false,
    Map<String, UserRoleEnum>? initialRoles,
    String? terminalPin,
  }) async {
    final newUser = UserProfileModel(
      uid: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      orgId: orgId,
      email: email,
      displayName: displayName,
      isSuperAdmin: isSuperAdmin,
      businessUnitRoles: initialRoles ?? const {},
      pinHash: terminalPin ?? '0000',
      status: 'active',
    );

    try {
      await repository.saveUser(newUser);
      _users = [newUser, ..._users];
    } catch (e) {
      _users = [newUser, ..._users];
    }
    notifyListeners();
  }

  Future<void> updateUserRole({
    required String orgId,
    required String userId,
    required String buId,
    required UserRoleEnum role,
  }) async {
    try {
      await repository.updateUserRole(
        orgId: orgId,
        userId: userId,
        buId: buId,
        role: role,
      );
    } catch (_) {}

    final idx = _users.indexWhere((u) => u.uid == userId);
    if (idx != -1) {
      final updatedRoles = Map<String, UserRoleEnum>.from(
        _users[idx].businessUnitRoles,
      );
      updatedRoles[buId] = role;
      _users[idx] = _users[idx].copyWith(businessUnitRoles: updatedRoles);
      notifyListeners();
    }
  }

  Future<void> updateUser(UserProfileModel user) async {
    try {
      await repository.updateUser(user);
    } catch (_) {}

    final idx = _users.indexWhere((u) => u.uid == user.uid);
    if (idx != -1) {
      _users[idx] = user;
      notifyListeners();
    }
  }

  Future<void> deleteUser({
    required String orgId,
    required String userId,
  }) async {
    try {
      await repository.deleteUser(orgId: orgId, userId: userId);
    } catch (_) {}

    _users.removeWhere((u) => u.uid == userId);
    notifyListeners();
  }
}
