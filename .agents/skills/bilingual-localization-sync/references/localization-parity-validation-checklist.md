# Bilingual Localization Parity & ARB Bundle Validation Checklist

> Standard: Strict Bilingual Localization (English & Spanish 100% Parity)  
> Governed Rules: [../../../rules/rule-bilingual-localization-parity.md](../../../rules/rule-bilingual-localization-parity.md), [../../../rules/rule-english-dart-docs.md](../../../rules/rule-english-dart-docs.md)  
> Scope: lib/l10n/**, lib/presentation/**, l10n.yaml  

---

## 1. ARB Translation Bundle Parity
- [ ] Every user-facing key in `lib/l10n/app_en.arb` exists in `lib/l10n/app_es.arb` with identical naming.
- [ ] Automated key difference audit (`scripts/audit_l10n_parity.py`) reports 0 missing keys.
- [ ] English translation file serves as the canonical master template (`template-arb-file: app_en.arb`).
- [ ] Spanish translations convey authentic, idiomatic Latin American Spanish without raw machine artifact translations.
- [ ] Both ARB files parse as valid JSON with zero syntax errors.

## 2. Parameter & Placeholder Integrity
- [ ] All parameterized translation keys (e.g., `{stationName}`, `{count}`) have identical placeholder names in both bundles.
- [ ] Placeholder type declarations (`type: "String"`, `type: "int"`) match exactly in `@key` metadata across files.
- [ ] Pluralized and formatted strings (`{count, plural, =0{no items} =1{1 item} other{{count} items}}`) maintain valid ICU format syntax.
- [ ] Date, currency, and number formatters resolve through `intl` with locale-aware format specifications.

## 3. Presentation Layer Consumption & Zero Hardcoded Strings
- [ ] 100% of user-facing UI strings (titles, buttons, labels, hints, validation alerts, empty states) resolve via `AppLocalizations.of(context)`.
- [ ] Zero hardcoded string literals (e.g. `'Save'`, `'Submit'`, `'Error'`, `'Cancel'`) in widget trees.
- [ ] Notification snackbars and dialogs resolve localized strings via `NotificationService` or passed parameters.
- [ ] Dynamic API messages or domain error codes map to localized string keys via strongly-typed enums.

## 4. Code Generation & Tooling Gate
- [ ] `l10n.yaml` exists in the repository root and is correctly configured (`synthetic-package: false` or standard output path).
- [ ] `flutter gen-l10n` executes cleanly with zero warnings or missing translation errors.
- [ ] `LanguageEnum` in `lib/core/enums/language_enum.dart` defines `en` and `es` with ISO codes, labels, and `Locale` objects.
- [ ] Root `MaterialApp` declares `localizationsDelegates: AppLocalizations.localizationsDelegates` and `supportedLocales`.
