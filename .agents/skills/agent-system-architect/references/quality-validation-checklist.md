# Exhaustive Master Multi-Phase Quality Validation Checklist for Enterprise Flutter Subsystems

> Scope: All files located across `.agents/`, `lib/`, `test/`, `tool/`, and platform directories  
> Mandatory Standards: Zero Emojis, 100% Technical English, Strict Relative Links, 100% Test Coverage  
> Automated Asset Validator: [../scripts/validate_agent_assets.py](../scripts/validate_agent_assets.py)  
> Status Audit Tool: [../scripts/check_decomposition_status.py](../scripts/check_decomposition_status.py)  

---

## 1. Domain-Specific Specialized Checklists & Reference Matrix

In addition to this master system checklist, each specialized engineering discipline maintains an exhaustive reference checklist:

1. **Cloud Firestore Data Infrastructure:** [../../firestore-repository-builder/references/firestore-data-validation-checklist.md](../../firestore-repository-builder/references/firestore-data-validation-checklist.md)
2. **Reactive State Management & ChangeNotifier:** [../../provider-state-management/references/state-management-validation-checklist.md](../../provider-state-management/references/state-management-validation-checklist.md)
3. **Bootstrap Responsive Grid (12-Column):** [../../bootstrap-responsive-layout/references/bootstrap-grid-validation-checklist.md](../../bootstrap-responsive-layout/references/bootstrap-grid-validation-checklist.md)
4. **Adaptive Dual-Theme Tokens & Design System:** [../../design-system-theme-tokens/references/design-tokens-validation-checklist.md](../../design-system-theme-tokens/references/design-tokens-validation-checklist.md)
5. **Bilingual Localization Parity (EN/ES):** [../../bilingual-localization-sync/references/localization-parity-validation-checklist.md](../../bilingual-localization-sync/references/localization-parity-validation-checklist.md)
6. **Service Locator Wiring & Startup Warmup:** [../../locator-dependency-wiring/references/locator-bootstrap-validation-checklist.md](../../locator-dependency-wiring/references/locator-bootstrap-validation-checklist.md)
7. **Reactive Form Validation Engine:** [../../form-validation-orchestrator/references/form-validation-checklist.md](../../form-validation-orchestrator/references/form-validation-checklist.md)
8. **Feature Module Scaffolding & Decomposed Widgets:** [../../flutter-feature-scaffold/references/feature-scaffold-validation-checklist.md](../../flutter-feature-scaffold/references/feature-scaffold-validation-checklist.md)
9. **Multiplatform DevOps & Tooling Automation:** [../../multiplatform-dev-ops/references/multiplatform-devops-validation-checklist.md](../../multiplatform-dev-ops/references/multiplatform-devops-validation-checklist.md)
10. **Test Automation & 100% Coverage Gate:** [../../automated-test-suite-runner/references/test-coverage-validation-checklist.md](../../automated-test-suite-runner/references/test-coverage-validation-checklist.md)
11. **Defensive Error Scenario Matrix:** [../../automated-test-suite-runner/references/error-scenario-matrix.md](../../automated-test-suite-runner/references/error-scenario-matrix.md)
12. **Monolithic Blueprint Decomposition Matrix:** [agents-md-decomposition-matrix.md](agents-md-decomposition-matrix.md)

---

## 2. Automated Quality Gate Execution Commands

```bash
# 1. Run .agents Subsystem Automated Quality Gate
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v

# 2. Verify Full Decomposition & Inventory Status
python3 .agents/skills/agent-system-architect/scripts/check_decomposition_status.py --blueprint v3-climatica-app/AGENTS.md

# 3. Static Code Analysis Gate
flutter analyze

# 4. Strict Code Formatting Gate
dart format --output=none --set-exit-if-changed .

# 5. Full Test Coverage Gate (asserting 100% line & branch coverage)
flutter test --coverage

# 6. Verify zero skipped tests
! rg "skip:\s*true|@Skip\(" test/
```

---

## 3. Exhaustive Multi-Phase Layer-by-Layer Checklists

### Phase 1: Automated Static Code Analysis & Linter Gate
- [ ] `flutter analyze` runs with zero errors, zero warnings, and zero linter hints.
- [ ] `dart format --output=none --set-exit-if-changed .` passes with zero formatting diffs.
- [ ] `analysis_options.yaml` enables strict mode (`strict-casts: true`, `strict-inference: true`, `strict-raw-types: true`).
- [ ] Zero `// ignore:` or `// ignore_for_file:` comments suppressing linter rules without explicit recorded architectural exemption.
- [ ] All public classes, methods, constructors, and properties include comprehensive `///` Dart Doc comments ([RULE-CODE-001](../../../rules/rule-english-dart-docs.md)).
- [ ] `dart doc --validate-links` executes with zero broken documentation links.
- [ ] Compiler warnings treated as fatal errors; zero unused imports or dead code blocks.

### Phase 2: Technology Stack & Approved Dependencies Gate
- [ ] All packages in `pubspec.yaml` match the approved Technology Stack ([RULE-ARCH-005](../../../rules/rule-technology-stack-dependencies.md)).
- [ ] Zero unapproved state management packages (`bloc`, `flutter_bloc`, `riverpod`, `get`, `mobx`).
- [ ] Zero unvetted HTTP clients (`dio`, `http`) bypassing Cloud Firestore offline persistence.
- [ ] Zero conflicting local databases (`hive`, `isar`, `sqflite`, `objectbox`).
- [ ] Dart SDK and Flutter SDK constraints satisfy `sdk: ^3.9.2`.
- [ ] `flutter pub outdated` verifies all dependencies resolve without conflicting transitive peer locks.

### Phase 3: Canonical Project Anatomy & Folder Hierarchy
- [ ] Directory layout replicates the canonical anatomy ([RULE-ARCH-006](../../../rules/rule-canonical-project-structure.md)).
- [ ] Assets are categorized: `assets/animations/`, `assets/flags/`, `assets/fonts/`, `assets/icons/`, `assets/images/`, `assets/svg/`.
- [ ] Developer automation script resides in `tool/dev_setup.dart`.
- [ ] Source code is cleanly partitioned: `lib/theme/`, `lib/core/`, `lib/data/`, `lib/domain/`, `lib/presentation/`, `lib/l10n/`.
- [ ] Zero loose files in `lib/` root other than `main.dart`, `app_initializer.dart`, `firebase_options.dart`, `locator.dart`.
- [ ] Zero ad-hoc root folders (e.g. `lib/views/`, `lib/controllers/`, `lib/utils/` at root).

### Phase 4: Clean Architecture & Unidirectional Layer Flow
- [ ] Layer flow strictly adheres to `Presentation -> Domain -> Data` ([RULE-ARCH-001](../../../rules/rule-layered-architecture-flow.md)).
- [ ] `lib/domain/` contains zero imports of `package:flutter/material.dart`, Flutter widgets, or UI packages.
- [ ] `lib/domain/` contains zero imports of `package:cloud_firestore/cloud_firestore.dart` or database DTOs.
- [ ] `lib/presentation/` contains zero imports of `package:cloud_firestore/cloud_firestore.dart`, `DocumentSnapshot`, `QuerySnapshot`, or DTOs.
- [ ] Domain entities are pure Dart classes (`lib/domain/models/`) with `final` fields, `const` constructors, and immutability.
- [ ] Domain use cases and services (`lib/domain/services/`) contain all business validation rules and coordinate data repositories.
- [ ] Presentation screens communicate solely with Domain services or presentation state providers; zero direct repository calls from UI.

### Phase 5: Service Locator & Dependency Registration (GetIt)
- [ ] All singletons, services, repositories, and providers are registered centrally in `lib/locator.dart` ([RULE-ARCH-002](../../../rules/rule-service-locator-di.md)).
- [ ] Zero manual ad-hoc instantiations (`new SomeService()`, `SomeRepository()`) inside UI widgets or screens.
- [ ] Repositories and services are registered as singletons (`registerLazySingleton` or `registerSingleton`).
- [ ] Form providers and transient feature controllers are registered as factories (`registerFactory`) to prevent stale state retention.
- [ ] All dependencies are injected via constructor parameters rather than global variable lookups inside class bodies.
- [ ] A dedicated locator reset mechanism (`locator.reset()`) is available and used in unit test `tearDown()` blocks.

### Phase 6: Reactive State Management & ChangeNotifier Lifecycle
- [ ] State controllers extend `ChangeNotifier` and maintain strongly-typed status enums (e.g., `FeatureStatusEnum`) ([RULE-ARCH-003](../../../rules/rule-state-mutation-guardrails.md)).
- [ ] Internal state collections and mutable fields are private (`_items`, `_status`); public getters return unmodifiable collections (`List.unmodifiable(_items)`).
- [ ] Zero synchronous state mutations (`notifyListeners()`) during widget build phases or inside layout callbacks.
- [ ] UI widgets consume state reactively via `AnimatedBuilder`, `ListenableBuilder`, or `Consumer<T>`; zero unnecessary full-screen rebuilds.
- [ ] All asynchronous provider methods implement defensive `try / catch` blocks and emit `StatusEnum.error` on failure.
- [ ] Optimistic state updates roll back cleanly if asynchronous backend persistence fails.

### Phase 7: Cloud Firestore, Real-Time Streams & Offline Persistence
- [ ] Native multiplatform offline persistence is enabled explicitly across Mobile, Desktop, and Web (`IndexedDB`) ([RULE-DATA-001](../../../rules/rule-offline-first-firestore.md)).
- [ ] Collection paths are defined as centralized static constants in `lib/data/firestore/collections/app_collections.dart`.
- [ ] All Firestore collection references use strongly-typed converters (`withConverter<T>`) mapping to/from DTOs.
- [ ] DTOs (`lib/data/dtos/`) encapsulate Firestore serialization (`toFirestore()`, `fromFirestore()`), server timestamps, and enum conversion.
- [ ] Real-time snapshot streams (`watchAll()`) emit immediately from local disk cache before updating from remote cloud servers.
- [ ] One-shot read queries specify explicit read sources (`Source.serverAndCache`, `Source.cache`, `Source.server`).
- [ ] Multi-document mutations utilize atomic batch writes (`_firestore.batch()`) to ensure transactional integrity.
- [ ] Composite queries (filters + ordering) have corresponding index declarations in `firestore.indexes.json` ([RULE-DATA-002](../../../rules/rule-firestore-security-indexing.md)).
- [ ] Security rules (`firestore.rules`) enforce tenant isolation and prevent unauthorized read/write access.

### Phase 8: Local Key-Value Storage & SharedPreferences Wrapper
- [ ] All SharedPreferences operations are encapsulated within dedicated wrapper services in `lib/data/preferences/` ([RULE-DATA-004](../../../rules/rule-local-key-value-storage.md)).
- [ ] Zero calls to `SharedPreferences.getInstance()` in UI screens, widgets, or domain services.
- [ ] All storage keys are defined as private `static const String` constants within the wrapper class.
- [ ] Stored preferences (e.g., language choices, theme modes) are serialized/deserialized to strongly-typed Enums.
- [ ] Session credentials (auth token, user ID) are purged completely on logout via an explicit `clearSession()` method.
- [ ] Cache sizes and device storage bounds are respected ([RULE-DATA-003](../../../rules/rule-offline-cache-management.md)).

### Phase 9: Adaptive Dual-Theme Design System (Light & Dark)
- [ ] First-class, pixel-perfect support for both Light and Dark themes via `AppTheme.lightTheme()` and `AppTheme.darkTheme()` ([RULE-UI-004](../../../rules/rule-adaptive-dual-theme.md)).
- [ ] Integration with `bootstrap_ui_flutter` theme extensions (`BsThemeData.lightTheme`, `BsThemeData.darkTheme`).
- [ ] All visual tokens (colors, surfaces, borders, text colors) resolve dynamically through `AppColors` helpers (e.g., `AppColors.surfaceOf(context)`, `AppColors.textPrimaryOf(context)`).
- [ ] Zero hardcoded hex color literals (`Color(0xFF...)`) in presentation screens or widgets.
- [ ] Modular spacing scale adheres to standard 8px rhythm base defined in `lib/theme/app_spacing.dart`.
- [ ] Layout dimensions and icon sizes resolve exclusively from `lib/theme/app_dimens.dart`.
- [ ] Typography styles resolve through `AppTextStyles` hierarchy with adaptive brightness scaling.

### Phase 10: Universal Bootstrap Responsive Grid System
- [ ] Layouts adapt seamlessly across all form factors (mobile, tablet, laptop, desktop, ultra-wide, web) ([RULE-UI-002](../../../rules/rule-bootstrap-responsive-grid.md)).
- [ ] Grid structures utilize `bootstrap_ui_flutter` components: `BsContainer`, `BsRow`, `BsCol`, `ColSize`.
- [ ] Multi-column layouts define standard breakpoint columns: `xs` (<576px), `sm` (>=576px), `md` (>=768px), `lg` (>=992px), `xl` (>=1200px), `xxl` (>=1400px).
- [ ] Zero manual screen width calculations or ad-hoc `MediaQuery.of(context).size.width` branching for layout decisions.
- [ ] Grid containers respect safe area paddings and horizontal gutter margins across device orientations.

### Phase 11: Short & Decomposed Widget Architecture Standard
- [ ] Widget `build` methods do not exceed 40 lines of executable code ([RULE-UI-001](../../../rules/rule-short-decomposed-widgets.md)).
- [ ] Widget tree nesting depth does not exceed 3 levels within any single build method.
- [ ] Monolithic screens are decomposed into dedicated sub-widgets located in the feature's `widgets/` folder.
- [ ] Sub-widgets follow single-responsibility principles: header, search bar, card grid, card item, empty view.
- [ ] Complex child trees are extracted into private file-scoped widgets or reusable shared widgets.

### Phase 12: Project-Prefixed Reusable Component Library
- [ ] Common UI controls are implemented as modular, project-prefixed reusable components in `lib/core/widgets/` ([RULE-UI-003](../../../rules/rule-project-prefixed-components.md)):
  - `AppButton`: dynamic variants (primary, secondary, outline, text, danger), sizes (sm, md, lg), and loading states.
  - `AppSearchBar`: debounced query callback, clear action, localized hint.
  - `AppIconButton`: tooltips, badge overlays, accessibility tap targets.
  - `AppDropdown<T>`: generic type-safe selector driven by strongly-typed enums.
  - `AppTextField`: integrated with `BaseValidator`, localized error display, focus management.
  - `AppCard`: responsive container styling with theme token backgrounds.
  - `AppBadge`: status indicator chips driven by `BadgeVariantEnum`.
  - `AppModal`: standardized dialogs for confirmation and alerts.
  - `AppEmptyState`: placeholder illustrations with localized message and action button.
  - `AppLoadingIndicator`: centered progress indicator with localized message.
- [ ] Zero direct usage of bare Flutter buttons (`ElevatedButton`, `TextButton`, `OutlinedButton`) in feature screens.
- [ ] Zero raw `TextField` or `TextFormField` widgets in feature screens without `AppTextField` encapsulation.

### Phase 13: Universal Strongly-Typed Enums & String Literal Elimination
- [ ] All lifecycle states, theme modes, languages, button variants, and categories are defined as strongly-typed Enums ([RULE-TYPE-001](../../../rules/rule-strongly-typed-enums.md)):
  - `LanguageEnum`: `en`, `es` (with ISO code, display label, and Locale).
  - `ThemeModeEnum`: `light`, `dark`, `system`.
  - `ButtonVariantEnum`: `primary`, `secondary`, `outline`, `text`, `danger`.
  - `ButtonSizeEnum`: `sm`, `md`, `lg`.
  - `BadgeVariantEnum`: `primary`, `secondary`, `success`, `danger`, `warning`, `info`.
  - `ModalVariantEnum`: `standard`, `confirmation`, `danger`.
  - `ValidationErrorEnum`: `none`, `empty`, `tooShort`, `tooLong`, `invalidPattern`.
  - `ItemStatusEnum`: `active`, `inactive`, `draft`, `archived`.
- [ ] Zero string literal comparisons in business logic (e.g., `status == 'active'` or `lang == 'EN'` is strictly banned).
- [ ] Enums provide conversion factories with safe fallback defaults (`fromStorageKey`, `fromCode`).

### Phase 14: Strict Bilingual Localization Parity (EN & ES)
- [ ] Every user-facing string is localized in both English (`lib/l10n/app_en.arb`) and Spanish (`lib/l10n/app_es.arb`) ([RULE-L10N-001](../../../rules/rule-bilingual-localization-parity.md)).
- [ ] 100% key parity between `app_en.arb` and `app_es.arb` verified via automated key difference check.
- [ ] All parameterized keys have matching variable names and types across both ARB files.
- [ ] Strings are resolved exclusively through `AppLocalizations.of(context)` or `notificationService.l10n`.
- [ ] Zero hardcoded user-facing strings or raw literals in presentation widgets, dialogs, toasts, or error messages.
- [ ] `flutter gen-l10n` executes cleanly without warnings.

### Phase 15: App Startup, Session Lifecycle & Warmup Bootstrapper
- [ ] Startup sequence executes deterministically in `lib/main.dart` ([RULE-ARCH-004](../../../rules/rule-app-startup-bootstrap-lifecycle.md)):
  1. `WidgetsFlutterBinding.ensureInitialized()` executes first.
  2. `dotenv.load(fileName: '.env')` loads environment configuration.
  3. `Firebase.initializeApp()` configures multiplatform Firebase options.
  4. `setupLocator()` registers all dependencies in GetIt.
  5. `AppInitializer.initializeAppSettings()` executes synchronous runtime setup.
  6. `runApp(const MyApp())` mounts the widget tree.
  7. `locator<AppBootstrapper>().init()` preloads cache data concurrently post-paint.
- [ ] First Contentful Paint (FCP) is immediate; zero synchronous blocking database queries before `runApp()`.
- [ ] `AppBootstrapper` executes defensive `try / catch` blocks so background warm-up errors never crash the app.

### Phase 16: Multiplatform Target Compliance & Developer Tooling
- [ ] Multiplatform OS configurations satisfy minimum platform baselines ([RULE-ARCH-007](../../../rules/rule-multiplatform-target-configuration.md)):
  - Android: `minSdkVersion 21+` in `android/app/build.gradle`.
  - iOS & macOS: iOS 13.0+, macOS 10.15+.
  - Windows: CMake desktop configuration with Firestore C++ SDK.
  - Web: IndexedDB persistence with `Settings(persistenceEnabled: true)`.
- [ ] `tool/dev_setup.dart` executes the 7 canonical developer setup steps to completion.
- [ ] Zero platform-conditional branching that crashes or breaks non-tested target platforms.

### Phase 17: Decoupled UI Notifications & Overlay Services
- [ ] UI alerts, modal loading overlays, error dialogs, and snackbars are dispatched via `NotificationService` ([RULE-UI-005](../../../rules/rule-decoupled-ui-notifications.md)).
- [ ] `NotificationService` uses `GlobalKey<NavigatorState>` registered on the root `MaterialApp`.
- [ ] Zero passing of `BuildContext` into Domain services, use cases, or Data repositories.
- [ ] Snackbars use floating behavior with standardized theme border radius and colors.
- [ ] Modal loading dialogs are non-dismissible (`PopScope(canPop: false)`) and clean up via `hideLoading()`.

### Phase 18: Environment Secrets & Credential Protection
- [ ] Environment variables are loaded dynamically from `.env` via `flutter_dotenv` ([RULE-SEC-001](../../../rules/rule-environment-secrets-protection.md)).
- [ ] `.env` is listed in `.gitignore` and never committed to version control.
- [ ] A sanitized `.env.example` file is maintained with all required configuration keys.
- [ ] Zero hardcoded API keys, database secrets, or private tokens in source code files.
- [ ] Firebase credentials resolve through `DefaultFirebaseOptions.currentPlatform`.

### Phase 19: Memory Leak Prevention & Resource Disposal
- [ ] Every `TextEditingController` is disposed cleanly in its parent validator's or widget's `dispose()` method ([RULE-PERF-001](../../../rules/rule-subscription-controller-lifecycle.md)).
- [ ] Every `AnimationController` and `PageController` is disposed in `State.dispose()`.
- [ ] All Firestore `StreamSubscription` instances are cancelled on provider disposal or widget unmount.
- [ ] All `FocusNode` instances are disposed.
- [ ] Subscriptions in `ChangeNotifier` providers are cleared inside overridden `dispose()` methods.

### Phase 20: Defensive Validation, Error Resiliency & Graceful Degradation
- [ ] All public service methods validate arguments and throw explicit `ArgumentError` on invalid inputs.
- [ ] Asynchronous operations handle network timeouts (`TimeoutException`) gracefully.
- [ ] Firestore snapshot streams handle permission drops and disconnection errors without unhandled exceptions.
- [ ] Form validators catch empty, out-of-range, and malformed regex inputs before submission.
- [ ] UI presents user-friendly localized error dialogs and retry buttons when backend queries fail.

### Phase 21: Comprehensive Test Engineering Suite (100% Coverage)
- [ ] 100% line and branch test coverage maintained across Domain, Core, Data, and Presentation providers ([RULE-QUAL-001](../../../rules/rule-test-coverage-enforcement.md)).
- [ ] Zero skipped tests (`skip: true` or `@Skip()` is strictly prohibited).
- [ ] Positive happy-path tests verify expected functionality for every method.
- [ ] Negative error-path tests verify exceptions on null, empty, boundary, and malformed inputs.
- [ ] Stream listeners and subscriptions are tested for error emission and proper cancellation.
- [ ] Mocks are implemented with `mocktail`; zero real network requests in unit test suites.
- [ ] Widget tests verify loading, error, empty, and populated states with `AppTheme` and localization wrappers.
- [ ] Integration tests exercise end-to-end CRUD flows against `FakeFirebaseFirestore`.

### Phase 22: Zero Emoji, Documentation & Relative Link Invariants
- [ ] Strictly ZERO Unicode emojis or pictographs anywhere in `.agents/`, `lib/`, `test/`, or `tool/`.
- [ ] 100% Technical English used for all file names, code identifiers, comments, and documentation ([RULE-CODE-001](../../../rules/rule-english-dart-docs.md)).
- [ ] All markdown links use clean relative paths pointing to existing files on disk; zero absolute paths or machine-specific file URIs.
- [ ] Asset validation gate (`python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v`) reports zero failures.

### Phase 23: Continuous Autonomous Ecosystem Evolution & Asset Codification
- [ ] Evaluated whether newly introduced multi-step patterns or architectural constraints warrant codification ([RULE-ARCH-008](../../../rules/rule-ecosystem-evolution.md)).
- [ ] If user or reviewer corrected bad practices or set constraints, ensured the governing rule in `.agents/rules/` was updated or created.
- [ ] If multi-step procedural workflows (>=3 steps) were created, codified or updated into `.agents/skills/` using bottom-up dependency ordering.
- [ ] Checked existing assets before scaffolding new files to prevent fragmented micro-files or duplicate meta-skills.
- [ ] All newly created or modified assets in `.agents/` conform to 100% Technical English, zero emojis, and validate cleanly with `validate_agent_assets.py`.

---

## 4. Pre-Completion Sign-Off Protocol for AI Agents

Before submitting any deliverable or concluding an engineering session:

1. [ ] Ran `python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v` (0 failures).
2. [ ] Ran `python3 .agents/skills/agent-system-architect/scripts/check_decomposition_status.py` (all active assets accounted for).
3. [ ] Evaluated autonomous ecosystem evolution triage (`RULE-ARCH-008`) and codified newly established invariants or repeatable workflows.
4. [ ] Verified that all newly created or modified Dart files have 100% test coverage.
5. [ ] Confirmed zero Unicode emojis in any file touched.
6. [ ] Confirmed clean relative markdown links across all `.md` files.
7. [ ] Verified that widget `build` methods do not exceed 40 lines.
8. [ ] Consulted the relevant domain-specific reference checklist(s) for the touched layers.
9. [ ] Dispatched single final completion report via `send_message` with zero interim noise.
