import '../../core/enums/user_role_enum.dart';
import '../../domain/models/user_profile_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for multi-tenant enterprise user and role persistence.
abstract class UserRepository {
  Future<List<UserProfileModel>> getUsers(String orgId);
  Future<UserProfileModel?> getUser(String orgId, String userId);
  Future<void> saveUser(UserProfileModel user);
  Future<void> updateUserRole({
    required String orgId,
    required String userId,
    required String buId,
    required UserRoleEnum role,
  });
  Future<void> updateUser(UserProfileModel user);
  Future<void> deleteUser({required String orgId, required String userId});
}

/// Production implementation of [UserRepository] backed by [FirestoreClient].
class FirestoreUserRepository implements UserRepository {
  final FirestoreClient client;

  const FirestoreUserRepository({required this.client});

  @override
  Future<List<UserProfileModel>> getUsers(String orgId) async {
    final snapshot = await client.users(orgId).get();
    return snapshot.docs
        .map((doc) => UserProfileModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  @override
  Future<UserProfileModel?> getUser(String orgId, String userId) async {
    final doc = await client.users(orgId).doc(userId).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfileModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> saveUser(UserProfileModel user) async {
    await client.users(user.orgId).doc(user.uid).set(user.toMap());
  }

  @override
  Future<void> updateUserRole({
    required String orgId,
    required String userId,
    required String buId,
    required UserRoleEnum role,
  }) async {
    await client.users(orgId).doc(userId).update({
      'businessUnitRoles.$buId': role.storageKey,
    });
  }

  @override
  Future<void> updateUser(UserProfileModel user) async {
    await client.users(user.orgId).doc(user.uid).set(user.toMap());
  }

  @override
  Future<void> deleteUser({
    required String orgId,
    required String userId,
  }) async {
    await client.users(orgId).doc(userId).delete();
  }
}
