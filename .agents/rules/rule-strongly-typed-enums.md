---
id: RULE-TYPE-001
title: Universal Strongly-Typed Enums Architecture
category: domain
severity: blocking
scope:
  include:
    - "lib/**"
  exclude:
    - "test/**"
---

# Universal Strongly-Typed Enums Architecture

> Rule ID: RULE-TYPE-001  
> Severity: blocking  
> Target Scope: lib/**  
> Category: domain  

---

## 1. Architectural Invariant

All states, variants, types, status flags, and classification values throughout domain models, UI widgets, providers, and database schemas MUST be defined as strongly-typed Dart enums.

Under no circumstances shall:
1. Business logic branches or UI conditions evaluate raw string literals for equality (e.g., `status == 'active'` or `lang == 'en'` is strictly prohibited).
2. UI controls accept untyped string flags instead of dedicated variant or size enums (e.g. `variant: 'primary'` is forbidden; use `ButtonVariantEnum.primary`).
3. Database serialization/deserialization bypass enum mapping (e.g., store enum string or name using type-safe serialization methods like `name` or `fromName`).

---

## 2. Rationale & Failure Impact

- **Compile-Time Safety & Exhaustiveness:** Strongly-typed enums guarantee exhaustive switch statements, eliminating silent runtime errors caused by missing branches when new states are introduced.
- **Refactoring & Autocomplete:** Enums provide IDE autocomplete and immediate compile errors if an identifier is misspelled or renamed.
- **Failure Impact:** Magic strings result in subtle typos (e.g. `'Active'` vs `'active'`), uncaught runtime nulls, broken conditional branches, and fragile enterprise business logic.

---

## 3. Compliant Pattern (DO)

Define explicit enums with helper getters and serialize/deserialize safely:

```dart
// lib/core/enums/item_status_enum.dart
/// Strongly-typed lifecycle status discriminator for domain items.
enum ItemStatusEnum {
  /// Actively accessible item.
  active(storageKey: 'active'),

  /// Inactive / disabled item.
  inactive(storageKey: 'inactive'),

  /// Draft item pending submission.
  draft(storageKey: 'draft'),

  /// Archived item hidden from active catalog.
  archived(storageKey: 'archived');

  /// String key stored in Firestore document fields.
  final String storageKey;

  const ItemStatusEnum({required this.storageKey});

  /// Resolves [ItemStatusEnum] from storage key safely.
  static ItemStatusEnum fromStorageKey(String? key) {
    return ItemStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ItemStatusEnum.active,
    );
  }
}

// In Domain model:
class StationModel {
  final String id;
  final ItemStatusEnum status;

  const StationModel({required this.id, required this.status});
}

// In Presentation widget:
Widget buildStatusBadge(ItemStatusEnum status) {
  // Exhaustive compile-time checked switch expression
  return switch (status) {
    ItemStatusEnum.active => AppBadge(label: status.storageKey.toUpperCase(), variant: BadgeVariantEnum.success),
    ItemStatusEnum.inactive => AppBadge(label: status.storageKey.toUpperCase(), variant: BadgeVariantEnum.secondary),
    ItemStatusEnum.draft => AppBadge(label: status.storageKey.toUpperCase(), variant: BadgeVariantEnum.warning),
    ItemStatusEnum.archived => AppBadge(label: status.storageKey.toUpperCase(), variant: BadgeVariantEnum.danger),
  };
}
```

---

## 4. Prohibited Pattern (DON'T)

Evaluating raw string literals in conditional branching:

```dart
// BAD: Magic string equality comparisons in UI and business logic
class BadStatusWidget extends StatelessWidget {
  final String status;

  const BadStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // VIOLATION: String literal comparisons! Typo-prone and brittle!
    if (status == 'Active' || status == 'ACTIVE' || status == 'active') {
      return const Text('Online');
    } else if (status == 'inactive') {
      return const Text('Offline');
    }
    return const SizedBox.shrink();
  }
}
```

---

## 5. Automated Validation & Audit Procedure

Scan codebase for common raw string status comparisons:

```bash
# Verify no string comparisons against common state literals
rg --glob 'lib/**' 'status == ["'\''"][a-zA-Z]+["'\'']|type == ["'\''"][a-zA-Z]+["'\'']'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
