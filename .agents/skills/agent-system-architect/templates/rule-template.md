---
id: [RULE-CATEGORY-NUMBER, e.g., RULE-ARCH-001]
title: [Short Imperative Rule Title]
category: [architecture | presentation | data | domain | theme | l10n | lint | quality | testing]
severity: [blocking | critical | warning]
scope:
  include:
    - "src/**"
  exclude:
    - "tests/**"
---

# [Short Imperative Rule Title]

> Rule ID: [RULE-CATEGORY-NUMBER]  
> Severity: [blocking | critical | warning]  
> Target Scope: [Paths governed by this rule, e.g., src/**]  
> Category: [architecture | presentation | data | domain | theme | l10n | lint | quality | testing]  

---

## 1. Architectural Invariant

State the invariant clearly, concisely, and imperatively.
Example: "Under no circumstances shall domain models import infrastructure dependencies or external database drivers directly."

---

## 2. Rationale & Failure Impact

Explain why this rule exists:
- Architectural cleanliness and preservation of layer isolation.
- Testability and decoupling from external state and drivers.
- Failure impact: Direct coupling prevents isolated unit testing, induces fragile regressions, and breaks cross-platform portability.

---

## 3. Compliant Pattern (DO)

Provide a complete, production-ready compliant implementation example:

```
// Compliant implementation example adhering to this rule
```

---

## 4. Prohibited Pattern (DON'T)

Provide an explicit negative implementation example showing the violation:

```
// Prohibited anti-pattern that violates this rule
```

---

## 5. Automated Validation & Audit Procedure

Define the exact CLI commands, regex patterns, or static analysis configurations used to detect violations:

```bash
# Automated regex audit command to detect violations
rg --glob 'src/domain/**' 'import.*infrastructure'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
