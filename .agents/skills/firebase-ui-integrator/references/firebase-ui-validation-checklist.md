# Firebase UI & Adaptive Presentation Verification Checklist

> Scope: lib/presentation/, lib/theme/, lib/main.dart, test/presentation/responsive/  
> Standards: Zero Emojis, 100% Technical English, Strict Relative Links  

---

## 1. Quality Validation Gate Overview

This checklist enforces the architectural requirements and quality standards for integrating Firebase UI packages (`firebase_ui_firestore`, `firebase_ui_auth`, `firebase_ui_localizations`, `desktop_webview_auth`) with Flutter Material Design 3 and `bootstrap_ui_flutter` responsive grids.

---

## 2. Exhaustive Multi-Phase Checklist

### Phase 1: Approved Technology Stack & Dependency Declaration
- [ ] `pubspec.yaml` declares approved version constraints for:
  - `firebase_ui_firestore` (`^1.6.0`)
  - `firebase_ui_auth` (`^1.16.0`)
  - `firebase_auth` (`^5.4.0`)
  - `firebase_ui_localizations` (`^1.14.0`)
  - `desktop_webview_auth` (`^0.0.16`)
  - `bootstrap_ui_flutter` (`^0.6.0`)
- [ ] Zero unapproved state management or external UI packages introduced.
- [ ] `flutter pub get` executes with zero dependency resolution conflicts.

### Phase 2: Material Design 3 Reconciliation & ThemeData Configuration
- [ ] `AppTheme` / `FirebaseUiThemeBridge` configures Flutter `ThemeData` with `useMaterial3: true`:
  - `ThemeData.colorScheme` provides full Material 3 semantic palette (`primary`, `surface`, `onSurface`, `error`).
  - `ThemeData.inputDecorationTheme` configures clean Material 3 outline borders and focus states.
  - `ThemeData.filledButtonTheme` and `elevatedButtonTheme` configure Material 3 button metrics.
  - `ThemeData.cardTheme` configures Material 3 card curvature and surface container tones.
- [ ] Zero instantiation of prohibited non-grid Bootstrap UI widgets (`BsButton`, `BsCard`, `BsModal`, `BsInput`, `BsNavbar`, `BsTable`, `BsListGroup`) or Cupertino widgets.

### Phase 3: Adaptive Presentation Wireframe Compliance (Desktop Tables vs Mobile Lists)
- [ ] Catalog views consume `FirestoreQueryBuilder` headlessly, decoupling data streaming from widget rendering.
- [ ] On desktop/laptop viewports (breakpoints `lg`, `xl`, `xxl` - width >= 992px), data is rendered using `DataTable` inside a `Card`.
- [ ] On mobile/tablet viewports (breakpoints `xs`, `sm`, `md` - width < 992px), data is rendered using `ListTile` or `Card` stacks.
- [ ] Responsive grid structure uses `BsContainer`, `BsRow`, and `BsCol`.
- [ ] Minimum touch target size for mobile list items is at least 48 pixels.
- [ ] Infinite scroll triggers `snapshot.fetchMore()` reliably near scroll bottom on mobile.

### Phase 4: Responsive Authentication Screen & Builder Customization
- [ ] `SignInScreen` / `RegisterScreen` configure `sideBuilder` for viewports >= 800px.
- [ ] `sideBuilder` renders a Material 3 brand hero container inside a responsive `BsContainer`.
- [ ] `headerBuilder` renders compact mobile brand identity for viewports < 800px.
- [ ] `footerBuilder` and `subtitleBuilder` render localized disclaimers and action-sensitive prompts via Material Design 3 components.
- [ ] Zero prohibited non-grid Bootstrap widgets injected into builder slots.

### Phase 5: Multiplatform Desktop Authentication (Windows & macOS)
- [ ] `FirebaseUIAuth.configureProviders(...)` registers supported providers centrally during startup.
- [ ] On Windows desktop, interactive OAuth flows configure `desktop_webview_auth` with loopback redirect handling.
- [ ] Email/Password authentication verified to work without requiring external browser redirections.
- [ ] Platform checks use `defaultTargetPlatform` or `kIsWeb` without platform crashes.

### Phase 6: Bilingual Localization Parity (EN & ES)
- [ ] `FirebaseUILocalizations.delegate` registered in `MaterialApp.localizationsDelegates` alongside `AppLocalizations.delegate`.
- [ ] Supported locales include English (`en`) and Spanish (`es`).
- [ ] Custom label overrides (if any) are applied via `FirebaseUILocalizations.withDefaultOverrides` with 100% parity across languages.
- [ ] Zero hardcoded string literals inside custom builder slots (`headerBuilder`, `sideBuilder`, `footerBuilder`).
