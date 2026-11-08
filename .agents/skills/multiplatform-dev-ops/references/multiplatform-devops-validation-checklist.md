# Multiplatform DevOps & Build Engineering Validation Checklist

> Standard: Multiplatform Target Compliance & Developer Tooling Automation  
> Governed Rules: [../../../rules/rule-environment-secrets-protection.md](../../../rules/rule-environment-secrets-protection.md), [../../../rules/rule-technology-stack-dependencies.md](../../../rules/rule-technology-stack-dependencies.md), [../../../rules/rule-multiplatform-target-configuration.md](../../../rules/rule-multiplatform-target-configuration.md), [../../../rules/rule-canonical-project-structure.md](../../../rules/rule-canonical-project-structure.md)  
> Scope: tool/**, android/**, ios/**, macos/**, windows/**, web/**, .env*  

---

## 1. Developer Tooling & Automation (`tool/dev_setup.dart`)
- [ ] `tool/dev_setup.dart` exists, is executable, and contains the canonical 7-step setup flow:
  1. `flutter clean`
  2. `flutter pub get`
  3. `flutter gen-l10n`
  4. `flutter analyze`
  5. `dart doc`
  6. `flutter pub run flutter_launcher_icons`
  7. `flutterfire configure`
- [ ] Script runs to completion without manual user intervention or interactive prompt blocking.
- [ ] Errors during any step immediately halt execution and emit descriptive stderr diagnostics.

## 2. Multiplatform Platform Manifests & SDK Bounds
- [ ] **Android:** `android/app/build.gradle` enforces `minSdkVersion 21` or higher and target SDK 34+.
- [ ] **iOS:** `ios/Podfile` specifies platform target iOS 13.0 or higher.
- [ ] **macOS:** `macos/Podfile` specifies platform target macOS 10.15 or higher.
- [ ] **Windows:** Flutter Windows desktop project is configured with C++ CMake targets.
- [ ] **Web:** `web/index.html` includes proper viewport meta tags, canvas/HTML renderer scripts, and service workers.
- [ ] All platform targets compile without missing platform channel errors.

## 3. Environment Secrets & Credential Protection
- [ ] Dynamic environment variables are loaded via `.env` (`RULE-SEC-001`).
- [ ] `.env` is listed in `.gitignore` and never committed to version control.
- [ ] `.env.example` is maintained with documentation for all required variables and sanitized dummy values.
- [ ] Zero cleartext API keys, service account JSON secrets, or passwords committed anywhere in the codebase.
- [ ] Firebase credentials resolve through `DefaultFirebaseOptions.currentPlatform`.

## 4. Static Analysis & Documentation Quality Gates
- [ ] `flutter analyze` completes with zero errors, zero warnings, and zero linter hints.
- [ ] `dart format --output=none --set-exit-if-changed .` passes with zero formatting diffs.
- [ ] `dart doc` verifies that all public classes, methods, fields, and constructors have comprehensive `///` comments in English.
