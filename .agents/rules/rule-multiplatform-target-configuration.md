---
id: RULE-ARCH-007
title: Multiplatform Target Specifications and Developer Tooling Automation
category: architecture
severity: blocking
scope:
  include:
    - "tool/**"
    - "android/**"
    - "ios/**"
    - "macos/**"
    - "windows/**"
    - "web/**"
  exclude:
    - "test/**"
---

# Multiplatform Target Specifications and Developer Tooling Automation

> Rule ID: RULE-ARCH-007  
> Severity: blocking  
> Target Scope: tool/**, android/**, ios/**, macos/**, windows/**, web/**  
> Category: architecture  

---

## 1. Architectural Invariant

The application architecture MUST compile, run, and persist state seamlessly across all 5 official Flutter target platforms: **Android, iOS, macOS, Windows, and Web**. Code that breaks any single platform target, introduces unmanaged platform-dependent crashes, or bypasses standard developer tooling automation is strictly prohibited.

Multiplatform Target Minimum Invariants:
1. **Android:** Minimum SDK version MUST be `minSdkVersion 21` or higher in `android/app/build.gradle`. Firestore persistence utilizes local SQLite storage.
2. **iOS & macOS:** Minimum deployment target MUST be iOS 15.0+ (aligned with Xcode 16 toolchain) and macOS 12.0+ (supporting Intel x86_64 and Apple Silicon arm64). Local persistence utilizes disk SQLite cache.
3. **Windows:** Supports Flutter desktop with C++ SDK Firestore implementation. Persistence uses local disk cache.
4. **Web:** Persistence is backed by IndexedDB. `Settings(persistenceEnabled: true)` enables multi-tab offline synchronization.

Developer Tooling Automation Standard:
Automated developer setup is orchestrated exclusively via `tool/dev_setup.dart`. The script MUST execute the canonical 7-step sequence:
1. `flutter clean`
2. `flutter pub get`
3. `flutter gen-l10n` (Generates localization classes with 100% parity between `app_en.arb` and `app_es.arb`)
4. `flutter analyze` (Enforces zero warnings under enterprise linter rules)
5. `dart doc` (Verifies completeness of Dart Doc comments across all public APIs)
6. `flutter pub run flutter_launcher_icons` (Updates native app icons across all 5 platforms)
7. `flutterfire configure` (Generates and updates `lib/firebase_options.dart` for all platform targets)

---

## 2. Rationale & Failure Impact

- **True Universal Multiplatform Delivery:** If a developer introduces platform-specific dependencies without fallback guards (such as invoking mobile-only biometric APIs or desktop-incompatible camera packages), non-target platforms will fail to compile or throw unhandled `MissingPluginException` crashes at runtime.
- **Reproducible Developer Onboarding:** Maintaining `tool/dev_setup.dart` as the single automated onboarding script eliminates "works on my machine" issues across differing developer operating systems.
- **Offline Parity Across Targets:** Setting explicit persistence rules ensures that both mobile users (on SQLite) and web users (on IndexedDB) receive identical offline-first caching benefits.

---

## 3. Compliant Pattern (DO)

Multiplatform platform configurations and automated setup execution:

```dart
// tool/dev_setup.dart
import 'dart:io';

Future<void> main() async {
  stdout.writeln('=== Multiplatform Developer Environment Setup ===');

  // Step 1: Clean build artifacts
  await _runCommand('flutter', ['clean']);

  // Step 2: Fetch dependencies
  await _runCommand('flutter', ['pub', 'get']);

  // Step 3: Compile ARB localization
  await _runCommand('flutter', ['gen-l10n']);

  // Step 4: Run enterprise static analysis
  await _runCommand('flutter', ['analyze']);

  // Step 5: Validate Dart documentation completeness
  await _runCommand('dart', ['doc']);

  // Step 6: Generate platform launcher icons
  await _runCommand('flutter', ['pub', 'run', 'flutter_launcher_icons']);

  stdout.writeln('Developer setup completed successfully.');
}

Future<void> _runCommand(String executable, List<String> arguments) async {
  final result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    stderr.writeln(result.stderr);
    exit(result.exitCode);
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Introducing platform-breaking code or skipping automated verification steps:

```dart
// BAD: Assuming platform without defensive capability check
void initializePlatformStorage() {
  // VIOLATION: Hardcoded mobile-only assumption breaking Windows and Web
  if (Platform.isAndroid) {
    // ...
  } else {
    throw UnsupportedError('Only Android supported!'); // PROHIBITED
  }
}

// BAD: Committing broken platform manifests
// android/app/build.gradle: minSdkVersion 16 (VIOLATION: Must be >= 21)
```

---

## 5. Automated Validation & Audit Procedure

Verify multiplatform readiness and tool setup execution:

```bash
# 1. Verify tool/dev_setup.dart exists and is executable
test -f tool/dev_setup.dart

# 2. Check Android minSdkVersion in build.gradle
grep "minSdkVersion" android/app/build.gradle 2>/dev/null || true

# 3. Dry-run developer setup automation
dart run tool/dev_setup.dart
```
