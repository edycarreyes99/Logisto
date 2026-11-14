import '../../domain/models/organization_model.dart';
import '../firestore/firestore_client.dart';

/// Contract for multi-tenant Organization persistence and lifecycle management.
abstract class OrganizationRepository {
  Future<OrganizationModel?> getOrganization(String orgId);

  Future<void> saveOrganization(OrganizationModel organization);

  Future<void> completeOnboarding(String orgId);
}

/// Production implementation of [OrganizationRepository] backed by [FirestoreClient].
class FirestoreOrganizationRepository implements OrganizationRepository {
  final FirestoreClient client;

  const FirestoreOrganizationRepository({required this.client});

  @override
  Future<OrganizationModel?> getOrganization(String orgId) async {
    final doc = await client.organizations.doc(orgId).get();
    if (!doc.exists || doc.data() == null) return null;
    return OrganizationModel.fromMap(doc.data()!, docId: doc.id);
  }

  @override
  Future<void> saveOrganization(OrganizationModel organization) async {
    await client.organizations.doc(organization.id).set(organization.toMap());
  }

  @override
  Future<void> completeOnboarding(String orgId) async {
    await client.organizations.doc(orgId).update({
      'hasCompletedOnboarding': true,
    });
  }
}
