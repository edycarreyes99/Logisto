import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/auth/login_provider.dart';
import 'package:logisto/presentation/auth/login_screen.dart';
import 'package:logisto/presentation/navigation/app_routes.dart';
import 'package:logisto/presentation/navigation/navigation_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../test_helpers.dart';

class MockFirestoreClient extends Mock implements FirestoreClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginProvider Unit Tests', () {
    late AppPreferences preferences;
    late LoginProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await AppPreferences.getInstance();
      provider = LoginProvider(preferences: preferences);
    });

    test('initial state is idle and unauthenticated', () {
      expect(provider.status, equals(FeatureStatusEnum.idle));
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isPinLocked, isFalse);
      expect(provider.currentUserName, isNull);
      expect(provider.errorMessage, isNull);
    });

    test('signInWithEmailPassword fails with empty credentials', () async {
      final success = await provider.signInWithEmailPassword('', '');
      expect(success, isFalse);
      expect(provider.status, equals(FeatureStatusEnum.error));
      expect(provider.errorMessage, contains('required'));
      expect(provider.isAuthenticated, isFalse);
    });

    test('signInWithEmailPassword succeeds with valid credentials', () async {
      final success = await provider.signInWithEmailPassword(
        'admin@logisto.io',
        'secret123',
      );
      expect(success, isTrue);
      expect(provider.status, equals(FeatureStatusEnum.loaded));
      expect(provider.isAuthenticated, isTrue);
      expect(provider.currentUserName, equals('admin'));
      expect(provider.isPinLocked, isFalse);
    });

    test('unlockWithPin fails when pin is not 4 digits', () async {
      final success = await provider.unlockWithPin('12');
      expect(success, isFalse);
      expect(provider.errorMessage, contains('4 digits'));
    });

    test('unlockWithPin succeeds when pin is exactly 4 digits', () async {
      provider.lockTerminal();
      expect(provider.isPinLocked, isTrue);

      final success = await provider.unlockWithPin('1234');
      expect(success, isTrue);
      expect(provider.isPinLocked, isFalse);
      expect(provider.currentUserName, contains('1234'));
    });

    test('signOut resets authenticated state completely', () async {
      await provider.signInWithEmailPassword('user@logisto.io', 'pass');
      expect(provider.isAuthenticated, isTrue);

      await provider.signOut();
      expect(provider.isAuthenticated, isFalse);
      expect(provider.isPinLocked, isFalse);
      expect(provider.currentUserName, isNull);
      expect(provider.status, equals(FeatureStatusEnum.idle));
    });

    test('persists session in preferences and restores it on new provider instance', () async {
      await provider.signInWithEmailPassword('cashier@logisto.com', 'pass123');
      expect(provider.isAuthenticated, isTrue);
      expect(preferences.hasActiveSession(), isTrue);
      expect(preferences.getUserName(), equals('cashier'));

      // Simulate app restart by creating a new provider instance with the same preferences
      final restartedProvider = LoginProvider(preferences: preferences);
      expect(restartedProvider.isAuthenticated, isTrue);
      expect(restartedProvider.currentUserName, equals('cashier'));
      expect(restartedProvider.status, equals(FeatureStatusEnum.loaded));

      // Sign out clears persisted session
      await restartedProvider.signOut();
      expect(restartedProvider.isAuthenticated, isFalse);
      expect(preferences.hasActiveSession(), isFalse);
    });
  });

  group('LoginScreen Widget Tests', () {
    setUp(() async {
      await setupSeededLocator();
    });

    tearDown(() async {
      await resetLocator();
    });

    testWidgets('renders corporate login card, inputs, and action buttons', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: LoginScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Logisto Enterprise'), findsOneWidget);
      expect(find.text('Corporate Portal Login'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Fast PIN'), findsOneWidget);
      expect(find.text('New Org Setup'), findsOneWidget);
    });

    testWidgets('opens PIN switch modal on Fast PIN button tap', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: LoginScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fast PIN'));
      await tester.pumpAndSettle();

      expect(find.text('Fast PIN Switch'), findsOneWidget);
      expect(find.text('Unlock'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Fast PIN Switch'), findsNothing);
    });

    testWidgets('navigates to onboarding on New Org Setup tap', (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('en'), home: LoginScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('New Org Setup'));
      await tester.pumpAndSettle();

      expect(
        locator<NavigationProvider>().currentRoute,
        equals(AppRoutes.onboarding),
      );
    });
  });
}
