import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/feature_status_enum.dart';
import 'package:logisto/data/firestore/firestore_client.dart';
import 'package:logisto/data/preferences/app_preferences.dart';
import 'package:logisto/locator.dart';
import 'package:logisto/main.dart';
import 'package:logisto/presentation/auth/login_provider.dart';
import 'package:logisto/presentation/auth/login_screen.dart';
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

    testWidgets('renders clean Treinta-style login card with slogans and inputs', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('es'), home: LoginScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Logisto'), findsOneWidget);
      expect(find.text('Control total, sin complicaciones.'), findsOneWidget);
      expect(
        find.text('Gestión ágil para negocios en movimiento. Factura, controla, crece.'),
        findsOneWidget,
      );
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Recordar sesión'), findsOneWidget);
      expect(find.text('¿Olvidó su contraseña?'), findsOneWidget);
      expect(find.text('¿No tiene una cuenta? Registrarse'), findsOneWidget);

      // Verify Fast PIN and New Org Setup buttons are eliminated
      expect(find.text('PIN Rápido'), findsNothing);
      expect(find.text('Nueva Empresa'), findsNothing);
    });

    testWidgets('toggles between sign in and sign up mode', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('es'), home: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Tap to switch to registration mode
      await tester.tap(find.text('¿No tiene una cuenta? Registrarse'));
      await tester.pumpAndSettle();

      expect(find.text('Nombre Completo'), findsOneWidget);
      expect(find.text('Crear Cuenta'), findsOneWidget);
      expect(find.text('¿Ya tiene una cuenta? Iniciar Sesión'), findsOneWidget);

      // Tap back to login mode
      await tester.tap(find.text('¿Ya tiene una cuenta? Iniciar Sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Nombre Completo'), findsNothing);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
    });

    testWidgets('validates email format before submitting login', (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const LogistoApp(locale: Locale('es'), home: LoginScreen()),
      );
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextField).at(0), 'invalidemail');
      await tester.enterText(find.byType(TextField).at(1), 'Secret123!');
      await tester.tap(find.widgetWithText(FilledButton, 'Iniciar Sesión'));
      await tester.pumpAndSettle();

      expect(find.text('Por favor ingrese un correo electrónico válido.'), findsOneWidget);
    });
  });
}
