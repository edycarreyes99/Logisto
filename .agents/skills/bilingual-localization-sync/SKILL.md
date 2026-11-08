---
name: bilingual-localization-sync
description: |
  Procedural guide for synchronizing and maintaining bilingual English and Spanish localization bundles.
  Enforces 100% key parity between ARB files, parameter validation, string extraction, and code generation.
  Mandatory trigger conditions:
  - Trigger when adding, updating, or removing localized user-facing strings in Flutter.
  - Trigger when verifying translation parity between app_en.arb and app_es.arb.
  Do NOT trigger when:
  - Do not trigger for purely non-textual UI layout tasks.
  - Do not trigger for domain model business algorithms without user-facing text.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: localization
  publisher: Architecture Standards Team
---

# Bilingual Localization Sync Workflow

> Standard: Strict Bilingual Localization Parity (EN/ES)  
> Scope: lib/l10n/, lib/presentation/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes the internationalization subsystem in Flutter multiplatform apps. It enforces 100% key and parameter parity between English (`app_en.arb`) and Spanish (`app_es.arb`), eliminates hardcoded string literals across presentation widgets, automates localization code generation via `flutter gen-l10n`, and integrates type-safe message resolution into reusable UI components.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Introducing new user-facing labels, buttons, dialog titles, validation messages, or error toasts.
- Auditing the repository to detect hardcoded text literals in UI widgets.
- Synchronizing missing Spanish translations when new English strings are added.

### 2.2. When to Avoid This Skill
- Configuring low-level database schemas or Firestore collections.
- Refactoring service locator registrations in `locator.dart`.
- Styling themes and color palettes in `app_colors.dart`.

---

## 3. Pre-Flight Verification (Step 0)

Verify `flutter_localizations` and `intl` are present in `pubspec.yaml`:

```bash
# Verify flutter_localizations and intl dependencies
grep -E 'flutter_localizations|intl' pubspec.yaml
grep 'generate:\s*true' pubspec.yaml
```

Check that `l10n.yaml` exists in the project root:

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated.json
```

---

## 4. Canonical Specification & Standards

### 4.1. File Layout
```
lib/l10n/
├── app_en.arb               # Master English translation bundle
├── app_es.arb               # Spanish translation bundle (100% key parity)
└── app_localizations.dart   # Auto-generated localization classes
```

### 4.2. Invariant Rules
- Every key defined in `app_en.arb` MUST exist in `app_es.arb` with identical placeholders and types.
- Key names MUST follow `camelCase` format (e.g., `saveChanges`, `stationNameHint`, `temperatureReading`).
- User-facing text in widgets MUST ONLY be accessed through `AppLocalizations.of(context)!.keyName`.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Add New Master Key to app_en.arb
Add the key and its parameter metadata to `lib/l10n/app_en.arb`:

```json
{
  "@@locale": "en",
  "appTitle": "Climatica",
  "searchPlaceholder": "Search weather stations...",
  "saveStation": "Save Station",
  "stationSavedSuccess": "Weather station {name} saved successfully.",
  "@stationSavedSuccess": {
    "description": "Toast message displayed when a station is saved.",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Central Park Sensor"
      }
    }
  }
}
```

### Step 2: Add Matching Translation to app_es.arb
Add the exact matching key and placeholder signature to `lib/l10n/app_es.arb`:

```json
{
  "@@locale": "es",
  "appTitle": "Climatica",
  "searchPlaceholder": "Buscar estaciones climáticas...",
  "saveStation": "Guardar Estación",
  "stationSavedSuccess": "Estación climática {name} guardada exitosamente.",
  "@stationSavedSuccess": {
    "description": "Toast message displayed when a station is saved.",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Sensor Parque Central"
      }
    }
  }
}
```

### Step 3: Run Flutter Localization Generation
Execute code generation to produce updated Dart localization classes:

```bash
flutter gen-l10n
```

### Step 4: Consume in Presentation Widgets
Access the generated strings cleanly in widgets:

```dart
// lib/presentation/stations/widgets/stations_header.dart
import 'package:flutter/material.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_search_bar.dart';
import '../../../l10n/app_localizations.dart';

class StationsHeader extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  const StationsHeader({super.key, required this.onSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: l10n.searchPlaceholder,
            onChanged: onSearch,
          ),
        ),
        const SizedBox(width: 16),
        AppButton(
          text: l10n.saveStation,
          onPressed: onAdd,
        ),
      ],
    );
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Missing key in `app_es.arb` | Compiler error or fallback to English | Enforce automated parity gate in CI script before allowing build. |
| Pluralization mismatch | Grammatical errors in Spanish plural forms | Utilize ARB plural blocks (`{count, plural, =1{...} other{...}}`) in both bundles. |
| Context not mounted during toast | Exception: `Looking up a deactivated widget ancestor` | Pass `l10n` string into service before asynchronous call, or resolve via navigator context. |

---

## 7. Verification & Quality Gates

Run the parity script to verify 100% key match:

```bash
# Automated ARB key parity check
python3 -c "
import json, sys

with open('lib/l10n/app_en.arb') as f:
    en = set(k for k in json.load(f).keys() if not k.startswith('@'))
with open('lib/l10n/app_es.arb') as f:
    es = set(k for k in json.load(f).keys() if not k.startswith('@'))

missing_es = en - es
missing_en = es - en

if missing_es or missing_en:
    print(f'PARITY FAILURE: Missing in ES: {missing_es}, Missing in EN: {missing_en}')
    sys.exit(1)
print('PASS: 100% ARB key parity confirmed.')
"
```

Checklist (see full [references/localization-parity-validation-checklist.md](references/localization-parity-validation-checklist.md)):
- [ ] Every user-facing string has entries in both `app_en.arb` and `app_es.arb`.
- [ ] Placeholders match exactly in name and type.
- [ ] `flutter gen-l10n` completes with zero errors.
- [ ] No hardcoded user-facing strings in UI screens.
- [ ] Zero lint warnings with `flutter analyze`.
