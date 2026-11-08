---
id: RULE-L10N-001
title: Strict Bilingual Localization Parity
category: l10n
severity: blocking
scope:
  include:
    - "lib/l10n/**"
    - "lib/presentation/**"
  exclude:
    - "test/**"
---

# Strict Bilingual Localization Parity

> Rule ID: RULE-L10N-001  
> Severity: blocking  
> Target Scope: lib/l10n/**, lib/presentation/**  
> Category: l10n  

---

## 1. Architectural Invariant

Every user-facing string (titles, buttons, labels, hints, validation messages, toast alerts, empty states, and dialogs) MUST be localized in both English (`lib/l10n/app_en.arb`) and Spanish (`lib/l10n/app_es.arb`) with 100% key and parameter parity.

Under no circumstances shall:
1. Feature screens or presentation widgets display hardcoded text literals (e.g. `Text('Save')` or `Text('Error')` is strictly forbidden).
2. A localization key exist in `app_en.arb` without an exact, identical translation key and placeholder signature in `app_es.arb` (and vice versa).
3. Alerts, notifications, or toasts in services emit untranslated English or Spanish string literals.

---

## 2. Rationale & Failure Impact

- **Global Audience & Parity:** Dual-language support (EN/ES) is a core system requirement. Missing keys in one language cause runtime lookup exceptions or fallback rendering glitches.
- **Maintainability:** Hardcoding text strings across hundreds of UI widgets makes internationalization retrofitting prohibitively expensive.
- **Failure Impact:** Untranslated hardcoded strings degrade user trust, fail enterprise localization audits, and cause crash bugs if translation keys are out of sync during code generation.

---

## 3. Compliant Pattern (DO)

Declare synchronized keys in both ARB files and consume via `AppLocalizations`:

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "Climatica",
  "saveButton": "Save Changes",
  "temperatureReading": "Current temperature: {temp} Celsius",
  "@temperatureReading": {
    "placeholders": {
      "temp": { "type": "String" }
    }
  }
}

// lib/l10n/app_es.arb (100% Key Parity)
{
  "@@locale": "es",
  "appTitle": "Climatica",
  "saveButton": "Guardar Cambios",
  "temperatureReading": "Temperatura actual: {temp} Celsius",
  "@temperatureReading": {
    "placeholders": {
      "temp": { "type": "String" }
    }
  }
}
```

In Presentation widget:

```dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/widgets/app_button.dart';

class LocalizedActionWidget extends StatelessWidget {
  final double temperature;

  const LocalizedActionWidget({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(l10n.temperatureReading(temperature.toStringAsFixed(1))),
        AppButton(
          text: l10n.saveButton,
          onPressed: () {},
        ),
      ],
    );
  }
}
```

---

## 4. Prohibited Pattern (DON'T)

Embedding hardcoded string literals directly in widget definitions:

```dart
// BAD: Hardcoded user-facing strings without localization
class BadTextWidget extends StatelessWidget {
  const BadTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // VIOLATION: Hardcoded English text literal!
        const Text('Welcome to Weather Dashboard!'),

        // VIOLATION: Hardcoded Spanish string literal!
        ElevatedButton(
          onPressed: () {},
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Execute script to verify 100% key parity between `app_en.arb` and `app_es.arb`:

```bash
# Verify 100% ARB key parity between EN and ES
python3 -c "
import json, sys

with open('lib/l10n/app_en.arb') as f:
    en_keys = set(json.load(f).keys())
with open('lib/l10n/app_es.arb') as f:
    es_keys = set(json.load(f).keys())

diff_en = en_keys - es_keys
diff_es = es_keys - en_keys

if diff_en or diff_es:
    print(f'FAIL: ARB parity violation. Missing in ES: {diff_en}. Missing in EN: {diff_es}')
    sys.exit(1)
print('PASS: 100% ARB key parity confirmed.')
"
```

Expected output: `PASS: 100% ARB key parity confirmed.`. Any mismatch constitutes a build failure.
