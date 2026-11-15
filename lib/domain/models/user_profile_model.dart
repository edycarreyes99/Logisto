import '../../core/enums/user_role_enum.dart';
import '../../core/enums/user_status_enum.dart';

/// Pure domain model representing an enterprise employee or administrator user.
class UserProfileModel {
  final String uid;
  final String orgId;
  final String email;
  final String displayName;
  final String pinHash;
  final bool isSuperAdmin;
  final Map<String, UserRoleEnum> businessUnitRoles;
  final UserStatusEnum status;

  const UserProfileModel({
    required this.uid,
    required this.orgId,
    required this.email,
    required this.displayName,
    this.pinHash = '',
    this.isSuperAdmin = false,
    this.businessUnitRoles = const {},
    this.status = UserStatusEnum.active,
  });

  /// Returns the assigned role in a given [buId], defaulting to [UserRoleEnum.cashier].
  UserRoleEnum roleInBusinessUnit(String buId) {
    if (isSuperAdmin) return UserRoleEnum.superAdminOrg;
    return businessUnitRoles[buId] ?? UserRoleEnum.cashier;
  }

  UserProfileModel copyWith({
    String? uid,
    String? orgId,
    String? email,
    String? displayName,
    String? pinHash,
    bool? isSuperAdmin,
    Map<String, UserRoleEnum>? businessUnitRoles,
    UserStatusEnum? status,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      orgId: orgId ?? this.orgId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      pinHash: pinHash ?? this.pinHash,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      businessUnitRoles: businessUnitRoles ?? this.businessUnitRoles,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'orgId': orgId,
      'email': email,
      'displayName': displayName,
      'pinHash': pinHash,
      'isSuperAdmin': isSuperAdmin,
      'businessUnitRoles': businessUnitRoles.map(
        (key, value) => MapEntry(key, value.storageKey),
      ),
      'status': status.storageKey,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    final rawRoles = map['businessUnitRoles'] as Map<String, dynamic>? ?? {};
    final roles = rawRoles.map(
      (key, value) =>
          MapEntry(key, UserRoleEnum.fromStorageKey(value as String?)),
    );

    return UserProfileModel(
      uid: docId ?? (map['uid'] as String? ?? ''),
      orgId: map['orgId'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      pinHash: map['pinHash'] as String? ?? '',
      isSuperAdmin: map['isSuperAdmin'] as bool? ?? false,
      businessUnitRoles: roles,
      status: UserStatusEnum.fromStorageKey(map['status'] as String?),
    );
  }
}
