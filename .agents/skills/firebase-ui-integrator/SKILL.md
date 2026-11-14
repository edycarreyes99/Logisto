---
name: firebase-ui-integrator
description: |
  Comprehensive procedural guide for integrating Firebase UI libraries (firebase_ui_firestore, firebase_ui_auth,
  flutterfire_desktop, firebase_ui_localizations) with Flutter Material Design 3 and bootstrap_ui_flutter
  responsive grids, enforcing adaptive tables for desktop vs lists for mobile, Windows/desktop OAuth loopback handling,
  and bilingual parity.
  Mandatory trigger conditions:
  - Trigger when integrating firebase_ui_firestore for paginated data catalogs or real-time query builders.
  - Trigger when implementing multiplatform authentication screens (SignInScreen, RegisterScreen, ProfileScreen) with firebase_ui_auth.
  - Trigger when configuring Windows or macOS desktop authentication via flutterfire_desktop or desktop_webview_auth.
  - Trigger when synchronizing Firebase UI localization delegates and Spanish/English label overrides.
  Do NOT trigger when:
  - Do not trigger for raw Firestore database security rules or composite indexing alone.
  - Do not trigger for offline cache persistence configuration without UI components.
license: Apache-2.0
metadata:
  version: 2.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Firebase UI Integrator

> Standard: Universal Multiplatform Presentation & Firebase UI Integration  
> Scope: lib/presentation/, lib/theme/, lib/main.dart, windows/, macos/  
> Level: Prescriptive Procedural Workflow  

---

## 1. Executive Summary & Objective

This skill prescribes the authoritative procedural workflow for integrating official Firebase UI packages (`firebase_ui_firestore`, `firebase_ui_auth`, `firebase_ui_localizations`, and `desktop_webview_auth` under `flutterfire_desktop` patterns) into multiplatform Flutter applications.

It enforces the following core architectural invariants:
1. **Adaptive Representation & Wireframes:** Consuming `FirestoreQueryBuilder` headlessly to drive high-density Material Design 3 `DataTable` layouts in cards on desktop/laptop displays (>=992px) and touch-optimized `ListTile` / `Card` layouts on mobile/tablet displays (<992px) ([RULE-UI-007](../../rules/rule-adaptive-view-representation.md)), structured with Bootstrap 12-column responsive grids (`BsContainer`, `BsRow`, `BsCol`).
2. **Material Design 3 Reconciliation:** Reconciling Firebase UI widgets with Material Design 3 by configuring `ThemeData(useMaterial3: true)` with semantic `ColorScheme` tokens, and strictly utilizing Material Design 3 controls in all customizable slots (`headerBuilder`, `sideBuilder`, `footerBuilder`, `subtitleBuilder`) ([RULE-UI-006](../../rules/rule-bootstrap-exclusive-components.md)).
3. **Multiplatform Desktop Authentication:** Enabling native Email/Password auth and interactive OAuth login flows on Windows and macOS using loopback redirection without requiring mobile webviews ([RULE-ARCH-007](../../rules/rule-multiplatform-target-configuration.md)).
4. **Bilingual Localization Parity:** Integrating `FirebaseUILocalizations.delegate` in `MaterialApp` to guarantee 100% key parity and seamless Spanish (`es`) and English (`en`) translations ([RULE-L10N-001](../../rules/rule-bilingual-localization-parity.md)).

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Constructing real-time paginated Firestore data views requiring responsive adaptation (tables on desktop, lists on mobile).
- Implementing user authentication, registration, password recovery, or profile views via `firebase_ui_auth`.
- Configuring Windows or desktop authentication flows using `desktop_webview_auth` and loopback servers.
- Synchronizing bilingual translation strings for Firebase UI auth flows and dialogs.
- Customizing responsive authentication layouts with desktop `sideBuilder` hero panels and mobile `headerBuilder` brand logos.

### 2.2. When to Avoid This Skill
- Constructing purely headless Firestore DTOs, mappers, or repository snapshot streams without presentation widgets (use [../firestore-repository-builder/SKILL.md](../firestore-repository-builder/SKILL.md)).
- Scaffolding basic CRUD features that do not consume Firebase UI pre-built widgets or queries (use [../flutter-feature-scaffold/SKILL.md](../flutter-feature-scaffold/SKILL.md)).
- Authoring non-UI backend Cloud Functions or administrative CLI scripts.

---

## 3. Pre-Flight Verification (Step 0)

Ensure the approved Firebase and UI dependencies are declared in `pubspec.yaml` ([RULE-ARCH-005](../../rules/rule-technology-stack-dependencies.md)):

```bash
# Verify required dependencies in pubspec.yaml
grep -E 'firebase_ui_firestore|firebase_ui_auth|firebase_ui_localizations|desktop_webview_auth|bootstrap_ui_flutter' pubspec.yaml
```

Verify that Flutter SDK dependencies resolve without version conflicts:

```bash
flutter pub get
```

Verify that the canonical wireframe matrix is reviewed:
- Detailed wireframe specifications: [references/firebase-ui-wireframe-matrix.md](references/firebase-ui-wireframe-matrix.md)
- Quality verification checklist: [references/firebase-ui-validation-checklist.md](references/firebase-ui-validation-checklist.md)

---

## 4. Canonical Specification & Standards

### 4.1. Architecture and Component Flow

```
+-----------------------------------------------------------------------------------+
|                              Presentation Layer (UI)                              |
|                                                                                   |
|   +------------------------------------+   +----------------------------------+   |
|   |   Adaptive Catalog / Telemetry     |   |   Adaptive Authentication        |   |
|   |   (FirestoreQueryBuilder)          |   |   (SignInScreen / ProfileScreen) |   |
|   |                                    |   |                                  |   |
|   |   >=992px: DataTable (Desktop)     |   |   >=800px: sideBuilder (Desktop) |   |
|   |   768-991: 2-Col Card (Tablet)     |   |   <800px:  headerBuilder (Mobile)|   |
|   |   <768px:  ListTile / Card (Mobile)|   |   Modal:   LoginView (in Dialog) |   |
|   +-----------------+------------------+   +-----------------+----------------+   |
|                     |                                        |                    |
+---------------------|----------------------------------------|--------------------+
|                     v                                        v                    |
|       Firebase UI Firestore                    Firebase UI Auth                   |
|       (Headless Query, List, Grid)             (Material 3 ThemeData & Tokens)   |
|                     |                                        |                    |
|                     |                                        v                    |
|                     |                          desktop_webview_auth / Windows     |
|                     |                          (Loopback HTTP OAuth Redirect)     |
|                     v                                        v                    |
|       Cloud Firestore (withConverter)          Firebase Auth Core Service         |
+-----------------------------------------------------------------------------------+
```

### 4.2. Invariant Standards

1. **Complete Firebase UI Firestore Suite Evaluation:**
   - **`FirestoreQueryBuilder<T>` (Mandatory for Adaptive Catalogs):** Primary headless engine powering responsive multi-form-factor views. Provides `docs`, `isFetching`, `hasMore`, `hasError`, and `fetchMore()`. Decouples data fetching from presentation widgets.
   - **`FirestoreListView<T>` (Allowed for Linear Compact Feeds):** Permitted for purely vertical, continuous-scroll mobile views. All customization slots (`itemBuilder`, `emptyBuilder`, `errorBuilder`, `loadingBuilder`) MUST return Flutter Material Design 3 components (`Card`, `ListTile`, `CircularProgressIndicator`).
   - **`FirestoreGridView<T>` (Allowed for Multi-Column Tablet Dashboards):** Permitted for 2D card or media grids on tablet and desktop viewports, configured via `gridDelegate: SliverGridDelegateWithFixedCrossAxisCount`. Item cards MUST be constructed using Material Design 3 `Card`.

2. **Complete Firebase UI Auth Suite & Reconciled Theming:**
   - **Screens:** `SignInScreen`, `RegisterScreen`, and `ProfileScreen` are permitted as specialized federated auth handlers. On viewports >= 800px, desktop split-screen layouts MUST utilize `sideBuilder` for brand hero content; on viewports < 800px, mobile layouts MUST utilize `headerBuilder`.
   - **Embedded Forms (`LoginView`):** For unauthenticated action gates, embed `LoginView` inside an `AlertDialog` or `Dialog` without triggering full-screen page transitions.
   - **Account Management (`ProfileScreen`):** Supports user details, multi-factor authentication (MFA) challenge management, provider linking, and localized account deletion. Custom profile cards MUST be injected via `children: [...]` using Material Design 3 `Card`.
   - **Standalone Controls:** `OAuthProviderButton`, `UserAvatar`, `SignOutButton`, and `DeleteAccountButton` may be embedded directly into Material 3 app bars and profile cards.
   - **Theme Configuration:** Ambient Flutter `ThemeData` MUST configure `useMaterial3: true`, `inputDecorationTheme`, `elevatedButtonTheme`, `filledButtonTheme`, `outlinedButtonTheme`, and `cardTheme` (`CardThemeData`) so that Firebase UI forms visually conform to Material Design 3 ([templates/firebase_ui_theme_bridge.dart](templates/firebase_ui_theme_bridge.dart)).

3. **Multiplatform Desktop Authentication Standard (Windows & macOS):**
   - Interactive OAuth flows (Google, Apple, Microsoft) on Windows and macOS MUST configure `desktop_webview_auth` (`^0.0.16`), utilizing embedded browser windows and local HTTP loopback server redirects (`http://localhost:<port>`).
   - Email and password authentication functions natively on Windows C++ and macOS native runners without requiring external browser redirections.
   - Desktop platforms MUST catch loopback cancellation exceptions gracefully and present localized feedback.

4. **Adaptive Three-Tier Representation (Desktop, Tablet, Mobile):**
   - **Desktop (Width >= 992px, `BsBreakpoints.lg`):** Tabular data representation using `DataTable` inside a Material `Card`.
   - **Tablet (Width 768px - 991px, `BsBreakpoints.md`):** Two-column card grid (`BsRow` with `BsCol(config: BsColConfig(xs: 12, md: 6))` using Material 3 `Card`).
   - **Mobile (Width < 768px):** Single-column stacked lists using `ListTile` or `Card` with touch targets >= 48px.
   - Switching MUST derive from `LayoutBuilder` evaluating `BsBreakpoints.lg` and `BsBreakpoints.md` ([RULE-UI-007](../../rules/rule-adaptive-view-representation.md)).

5. **Bilingual Parity Invariant:**
   - Applications MUST register `FirebaseUILocalizations.delegate` in `MaterialApp.localizationsDelegates` alongside `AppLocalizations.delegate` ([RULE-L10N-001](../../rules/rule-bilingual-localization-parity.md)).
   - Any custom label overrides MUST be synchronized using `FirebaseUILocalizations.withDefaultOverrides` with 100% Spanish (`es`) and English (`en`) parity.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Declare Approved Dependencies
In `pubspec.yaml`, ensure the approved versions are declared:

```yaml
dependencies:
  firebase_core: ^3.10.0
  firebase_auth: ^5.4.0
  cloud_firestore: ^5.6.0
  firebase_ui_firestore: ^1.6.0
  firebase_ui_auth: ^1.16.0
  firebase_ui_localizations: ^1.14.0
  desktop_webview_auth: ^0.0.16
  bootstrap_ui_flutter: ^0.6.0
```

### Step 2: Initialize Firebase UI Auth Providers
In `lib/main.dart` or during application startup, configure authentication providers with `FirebaseUIAuth.configureProviders`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

Future<void> initializeFirebaseUi() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    // On desktop, GoogleProvider uses desktop_webview_auth loopback redirects
    GoogleProvider(clientId: 'YOUR_WEB_OR_DESKTOP_CLIENT_ID'),
  ]);
}
```

### Step 3: Implement Material Design 3 ThemeData Configuration
Ensure `MaterialApp` is configured with Material Design 3 themes derived from `FirebaseUiThemeBridge` ([templates/firebase_ui_theme_bridge.dart](templates/firebase_ui_theme_bridge.dart)):

```dart
MaterialApp(
  theme: FirebaseUiThemeBridge.lightTheme(),
  darkTheme: FirebaseUiThemeBridge.darkTheme(),
  themeMode: themeMode,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    FirebaseUILocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('es'),
  ],
  home: const MainShellScreen(),
);
```

### Step 4: Implement Responsive Authentication Screen
Create `lib/presentation/auth/auth_screen.dart` adhering to [templates/adaptive_auth_screen.dart](templates/adaptive_auth_screen.dart):
- Set `breakpoint: 800` to automatically transition between desktop split-view and mobile vertical layout.
- In `sideBuilder`: construct a Material 3 hero container displaying corporate branding, security badges, and system telemetry metrics inside a responsive grid.
- In `headerBuilder`: display a compact app icon and title for phone viewports.
- In `subtitleBuilder` and `footerBuilder`: inject contextual text and legal terms using Material Design 3 styling.

### Step 5: Implement Adaptive Headless Firestore Data View
Create `lib/presentation/catalog/widgets/adaptive_firestore_view.dart` adhering to [templates/adaptive_firestore_view.dart](templates/adaptive_firestore_view.dart):
- Wrap data presentation in `FirestoreQueryBuilder<T>`.
- Use `LayoutBuilder` to evaluate `constraints.maxWidth`:
  - **Desktop (`width >= BsBreakpoints.lg` - 992px):** `_buildDesktopTable` rendering `DataTable` inside a Material `Card` with status chips and action buttons.
  - **Tablet (`width >= BsBreakpoints.md` - 768px):** `_buildTabletGrid` rendering a 2-column card grid via `BsRow` and `BsCol(config: BsColConfig(xs: 12, md: 6))` with Material 3 `Card`.
  - **Mobile (`width < BsBreakpoints.md`):** `_buildMobileList` rendering `ListView` with `ListTile` items (touch targets >= 48px), status chips, and continuous scroll pagination (`snapshot.fetchMore()`).

### Step 6: Configure Windows Desktop Authentication
On Windows desktop builds:
1. Ensure `desktop_webview_auth: ^0.0.16` is declared in `pubspec.yaml`.
2. Configure Windows URL redirect protocol or local loopback in `FirebaseUIAuth.configureProviders`.
3. Catch cancellation or port-binding exceptions in auth handlers and display localized feedback.
4. Verify that native email/password authentication functions offline and online without external browser dependencies.

### Step 7: Synchronize Bilingual Localizations
Verify that all custom authentication and catalog text strings are synchronized across `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`. If overriding default Firebase UI labels, use `FirebaseUILocalizations.withDefaultOverrides`:

```dart
// lib/l10n/firebase_ui_label_overrides.dart
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class SpanishLabelOverrides extends DefaultLocalizations {
  const SpanishLabelOverrides();

  @override
  String get signInText => 'Iniciar Sesión Corporativa';

  @override
  String get registerText => 'Crear Cuenta';
}

class EnglishLabelOverrides extends DefaultLocalizations {
  const EnglishLabelOverrides();

  @override
  String get signInText => 'Corporate Sign In';

  @override
  String get registerText => 'Create Account';
}
```

---

## 6. Edge Cases & Defensive Invariants

1. **Window Resizing Across Breakpoints:** When a desktop window is interactively resized below 992px, the `FirestoreQueryBuilder` MUST preserve loaded docs and cursor state while smoothly transitioning from `DataTable` to `ListTile` card lists without losing scroll position.
2. **Offline Data Presentation:** When the device disconnects from the network, `FirestoreQueryBuilder` continues to emit cached documents from local disk cache. The UI must render a `Chip` indicating offline mode rather than throwing errors.
3. **Empty Data States:** When a query returns zero documents, the view MUST render a clean empty state card (Material `Card` with informative message and action button) instead of an empty table or blank list.
4. **OAuth Redirect Cancellation on Desktop:** If a user closes the Windows loopback OAuth browser window, `AuthStateListener` must catch the cancellation exception and display non-crashing localized feedback.
5. **Mobile Landscape Orientation:** In mobile landscape mode (`sm`: 576px - 767px), `ListTile` / `Card` stacks remain the preferred presentation pattern to prevent wide table horizontal clipping.

---

## 7. Verification & Audit Procedure

Execute the following automated terminal commands to verify that Firebase UI integration satisfies all quality standards:

```bash
# 1. Audit codebase for prohibited Bootstrap non-grid visual controls
! rg --glob 'lib/presentation/**' \
  '\b(BsCard|BsButton|BsModal|showBsModal|BsInput|BsSelect|BsNavbar|BsTable|BsListGroup)\b'

# 2. Verify that FirestoreQueryBuilder is used for adaptive views
rg --glob 'lib/presentation/**' 'FirestoreQueryBuilder'

# 3. Verify that FirebaseUILocalizations delegate is registered
rg --glob 'lib/main.dart' 'FirebaseUILocalizations\.delegate'

# 4. Verify responsive test coverage across mobile and laptop viewports
flutter test test/presentation/responsive/

# 5. Run static code analysis
flutter analyze
```
