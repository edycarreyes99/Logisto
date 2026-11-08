import 'package:get_it/get_it.dart';

/// Global compile-time dependency injection container.
final locator = GetIt.instance;

/// Registers all core singletons, clients, repositories, domain services, and providers.
Future<void> setupLocator() async {
  // 1. Environment Configurations
  // await dotenv.load(fileName: ".env");

  // 2. Firebase Multiplatform Initialization
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Database Clients & Infrastructure
  // final firestoreClient = await FirestoreClient.initialize();
  // locator.registerSingleton<FirestoreClient>(firestoreClient);

  // 4. Repositories

  // 5. Domain Services

  // 6. Presentation Providers (LazySingleton for session, Factory for forms)
}
