# Test Suite Engineering & 100% Coverage Validation Checklist

> Standard: Strict 100% Line & Branch Coverage with Exhaustive Defensive Error Testing  
> Governed Rules: [../../../rules/rule-test-coverage-enforcement.md](../../../rules/rule-test-coverage-enforcement.md), [../../../rules/rule-english-dart-docs.md](../../../rules/rule-english-dart-docs.md)  
> Scope: test/**, lib/**  

---

## 1. Coverage Threshold & Immutability Invariant
- [ ] 100% line coverage maintained across all testable layers (Domain, Core, Data, Presentation providers).
- [ ] 100% branch coverage maintained across conditional branches (`if/else`, `switch/case`, ternary operators).
- [ ] Zero skipped tests (`skip: true` or `@Skip()` is strictly prohibited) (`RULE-QUAL-001`).
- [ ] Zero existing tests deleted, commented out, or weakened to mask code defects.
- [ ] Filtered coverage calculation ignores only generated code (`lib/l10n/*`, `lib/firebase_options.dart`).

## 2. Unit Testing Rigor (Domain, Core & Data)
- [ ] Every Domain model constructor, copyWith, toJson, and fromJson method has explicit assertions.
- [ ] Every Domain service method tests both happy paths AND defensive error paths (ArgumentError on empty/invalid parameters).
- [ ] Every Core validator (`BaseValidator`, `TextFieldValidator`) tests empty, tooShort, tooLong, and regexPattern errors.
- [ ] DTO mappers test null DocumentSnapshot fields, timestamp conversion, and enum serialization fallbacks.
- [ ] Mocks are declared using `mocktail` with explicit `when()` and `verify()` assertions.
- [ ] Unit tests maintain zero Flutter widget imports and zero real network connections.

## 3. Widget Testing Rigor (Presentation & Reusable Controls)
- [ ] Widget tests mount widgets inside standard harness with `AppTheme.lightTheme()` and `AppLocalizations` delegates.
- [ ] Tests verify loading indicator states (`isLoading: true`), populated states, and empty states.
- [ ] Interactive taps verify callback execution on project-prefixed controls (`AppButton`, `AppIconButton`).
- [ ] Form widgets verify reactive error message display on invalid input entry.
- [ ] Widget build methods are asserted as maintaining <= 40 lines and <= 3 nesting levels.

## 4. Integration Testing Rigor (Fake Firestore & End-to-End Flows)
- [ ] Integration tests exercise complete CRUD workflows against `FakeFirebaseFirestore`.
- [ ] Tests assert local optimistic writes followed by query retrieval.
- [ ] Reactive stream emissions (`watchAll()`) are verified from initial snapshot through updates and deletions.
- [ ] Cache preloading and session invalidation are tested with mock SharedPreferences.

## 5. Defensive Error Injection Matrix
- [ ] Empty and whitespace-only string inputs tested across all public methods.
- [ ] Extreme boundary values (negative numbers, zero, maximum integers) tested.
- [ ] Network timeout exceptions (`TimeoutException`) tested and verified to degrade gracefully.
- [ ] Firestore snapshot stream error emissions tested to confirm provider transitions to error state.
- [ ] Rapid repeated user interactions tested to verify button debounce guards.
