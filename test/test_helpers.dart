import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:logisto/data/firestore/database_seeder.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates an in-memory [FakeFirebaseFirestore] pre-populated with production seeds.
Future<FirestoreClient> createSeededFirestoreClient() async {
  final fake = FakeFirebaseFirestore();
  final client = FirestoreClient(firestore: fake);
  final seeder = DatabaseSeeder(client: client);
  await seeder.seedProductionData();
  return client;
}

/// Bootstraps [GetIt] with an in-memory seeded Firestore client and mock preferences.
Future<void> setupSeededLocator({
  Map<String, Object>? preferencesValues,
}) async {
  SharedPreferences.setMockInitialValues(preferencesValues ?? {});
  final client = await createSeededFirestoreClient();
  await setupLocator(firestoreClient: client, reset: true);
}
