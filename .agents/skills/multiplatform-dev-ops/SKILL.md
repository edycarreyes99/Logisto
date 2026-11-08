---
name: multiplatform-dev-ops
description: |
  Procedural guide for developer tooling automation, environment validation, and multiplatform configuration.
  Orchestrates tool/dev_setup.dart, build targets for Android, iOS, Windows, macOS, and Web, and CI quality gates.
  Mandatory trigger conditions:
  - Trigger when setting up a new developer environment, running build scripts, or updating platform configs.
  - Trigger when configuring tool/dev_setup.dart, launcher icons, or platform-specific deployment manifests.
  Do NOT trigger when:
  - Do not trigger for purely UI widget styling or layout updates.
  - Do not trigger for pure domain model arithmetic without tooling aspects.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: devops
  publisher: Architecture Standards Team
---

# Multiplatform DevOps & Environment Automation

> Standard: Production Multiplatform Deployment & Automation  
> Scope: tool/, android/, ios/, macos/, windows/, web/, .github/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes developer environment setup, build verification, and platform-specific configurations across Android, iOS, Windows, macOS, and Web. It encapsulates the automated developer bootstrap script (`tool/dev_setup.dart`), enforces consistent platform deployment targets (e.g. `minSdkVersion 21`), orchestrates asset and icon generation, and establishes zero-warning quality gates for continuous integration.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Onboarding a developer or initializing a clean repository checkout.
- Updating platform configuration files (e.g., `build.gradle`, `Podfile`, `Info.plist`, `windows/runner/`).
- Automating continuous integration (CI) workflows for multiplatform builds.

### 2.2. When to Avoid This Skill
- Writing business logic models or domain use cases.
- Writing reactive form state controllers.
- Updating ARB localization translations.

---

## 3. Pre-Flight Verification (Step 0)

Verify Flutter CLI tools and platform dependencies:

```bash
# Verify Flutter and Dart toolchains
flutter --version
flutter doctor -v
dart --version
```

Ensure platform toolchains are installed:
- Android Studio / Android SDK (API 34+)
- Xcode and CocoaPods (for iOS and macOS on macOS hosts)
- Visual Studio C++ Build Tools (for Windows desktop on Windows hosts)
- Chrome / Edge (for Web target)

---

## 4. Canonical Specification & Standards

### 4.1. File Structure
```
tool/
└── dev_setup.dart                       # Master automation setup script

android/app/build.gradle                 # minSdkVersion 21, multiDexEnabled
ios/Podfile                              # platform :ios, '13.0'
macos/Podfile                            # platform :osx, '10.15'
web/index.html                           # Flutter Web entry point with IndexedDB
```

### 4.2. Invariant Rules
- Every multiplatform release MUST pass `flutter analyze` with 0 warnings.
- `dart doc` MUST compile with 0 broken links and full coverage of public APIs.
- Platform configurations MUST support native Firestore persistence (SQLite on mobile/desktop, IndexedDB on web).

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Implement Master Automation Script tool/dev_setup.dart
Create `tool/dev_setup.dart`:

```dart
import 'dart:io';

/// Automated setup script to clean, fetch dependencies, generate localizations, and analyze code.
void main() async {
  stdout.writeln('=== Climatica Multiplatform Environment Setup ===');

  await _runStep('1. Flutter Clean', 'flutter', ['clean']);
  await _runStep('2. Pub Get Dependencies', 'flutter', ['pub', 'get']);
  await _runStep('3. Generate Localizations', 'flutter', ['gen-l10n']);
  await _runStep('4. Analyze Static Code', 'flutter', ['analyze']);
  await _runStep('5. Validate Dart Documentation', 'dart', ['doc', '--validate-links']);

  stdout.writeln('=== All Environment Checks Passed Successfully ===');
}

Future<void> _runStep(String label, String executable, List<String> arguments) async {
  stdout.writeln('\n--> Running: $label');
  final result = await Process.run(executable, arguments, runInShell: true);
  if (result.stdout.toString().isNotEmpty) {
    stdout.write(result.stdout);
  }
  if (result.stderr.toString().isNotEmpty) {
    stderr.write(result.stderr);
  }
  if (result.exitCode != 0) {
    stderr.writeln('FAILURE in $label. Exiting with code ${result.exitCode}.');
    exit(result.exitCode);
  }
}
```

### Step 2: Configure Android Platform Targets
In `android/app/build.gradle`, enforce minimum SDK:

```groovy
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.climatica.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }
}
```

### Step 3: Configure iOS and macOS Targets
In `ios/Podfile`:
```ruby
platform :ios, '13.0'
```
In `macos/Podfile`:
```ruby
platform :osx, '10.15'
```

### Step 4: Configure Web Target
In `web/index.html`, ensure IndexedDB support and modern Flutter web bootstrap scripts are present.

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| CocoaPods out of date on macOS | iOS pod install fails with spec mismatch | Run `pod repo update && pod install` inside `ios/` and `macos/`. |
| Android Gradle build daemon OOM | Heap space exhaustion during compilation | Set `org.gradle.jvmargs=-Xmx4g` in `android/gradle.properties`. |
| FlutterFire options missing new platform | Unsupported platform crashes on boot | Run `flutterfire configure` to generate updated `firebase_options.dart`. |

---

## 7. Verification & Quality Gates

Execute full developer setup to confirm clean environment:

```bash
# Run developer setup workflow
dart run tool/dev_setup.dart
```

Checklist (see full [references/multiplatform-devops-validation-checklist.md](references/multiplatform-devops-validation-checklist.md)):
- [ ] `flutter clean` and `flutter pub get` succeed.
- [ ] `flutter gen-l10n` generates localization files.
- [ ] `flutter analyze` passes with 0 warnings.
- [ ] `dart doc --validate-links` completes cleanly.
- [ ] Platform manifests enforce minimum deployment versions.
