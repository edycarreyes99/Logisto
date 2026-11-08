---
name: [skill-name-in-kebab-case]
description: |
  [High-level summary of what this skill provides. State clearly what problems it solves.]
  Mandatory trigger conditions:
  - Trigger when [explicit condition 1]
  - Trigger when [explicit condition 2]
  Do NOT trigger when:
  - Do not trigger when [negative condition 1]
license: Apache-2.0
metadata:
  version: 1.0.0
  category: [architecture | data | presentation | localization | theme | devops | meta]
  publisher: Architecture Standards Team
---

# [Skill Title in Title Case]

> Standard: Enterprise Production Grade  
> Scope: [Target path, domain, or package]  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

Provide an unambiguous, technical explanation of the engineering objective governed by this skill. Explain why this capability exists and what system invariants it upholds.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Activation criteria 1.
- Activation criteria 2.
- User request patterns matching this skill.

### 2.2. When to Avoid This Skill
- Inapplicable contexts or conflicting architectures.
- Alternative skills to delegate to instead.

---

## 3. Pre-Flight Verification (Step 0)

Before executing modifications or generating assets, execute these deterministic checks:

1. Environment verification:
   ```bash
   # Verify dependencies, tooling, or configurations
   command -v [tool_name]
   ```
2. State verification: Confirm required dependencies or base abstractions exist before modifying downstream code.

---

## 4. Canonical Specification & Standards

Define the exact contracts, patterns, and standards required.

### 4.1. Core Contracts & Types
Detail types, signatures, and interfaces.

### 4.2. File Layout & Naming Conventions
```
src/path/to/target/
├── [canonical_file_name_1].ext
└── [canonical_file_name_2].ext
```

### 4.3. Skill Directory Anatomy (When applicable)
```
.agents/skills/[skill-name]/
├── SKILL.md
├── scripts/      # Optional automation helper scripts
├── templates/    # Optional code or configuration templates
├── references/   # Optional deep reference documentation
└── schemas/      # Optional JSON validation schemas
```

---

## 5. Step-by-Step Implementation Procedure

Follow these deterministic sequential steps:

### Step 1: [Phase 1 Action]
Describe the operation, parameters, and rationale.

```
// Code example adhering to all engineering invariants
```

### Step 2: [Phase 2 Action]
Describe the operation, parameters, and rationale.

```
// Code example adhering to all engineering invariants
```

### Step 3: [Phase 3 Action]
Describe the operation, parameters, and rationale.

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| [Edge case 1] | [What breaks] | [Exact mitigation steps] |
| [Edge case 2] | [What breaks] | [Exact mitigation steps] |

---

## 7. Verification & Quality Gates

Run these validation commands to verify compliance:

```bash
# Automated asset validation
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py

# Project test suite and linter execution
pytest  # or npm test, cargo test, flutter test depending on project stack
```

Checklist:
- [ ] Conforms to all dependency flow rules.
- [ ] No hardcoded string literals.
- [ ] Strongly typed enums used for state and variants.
- [ ] All public APIs have comprehensive English doc comments.
- [ ] Zero emojis in code, documentation, and metadata.
