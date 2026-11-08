---
id: RULE-ARCH-008
title: Continuous Autonomous Ecosystem Evolution and Asset Codification
category: architecture
severity: blocking
scope:
  include:
    - ".agents/**"
    - "lib/**"
    - "test/**"
    - "tool/**"
---

# Continuous Autonomous Ecosystem Evolution and Asset Codification

> Rule ID: RULE-ARCH-008  
> Severity: blocking  
> Target Scope: .agents/**, lib/**, test/**, tool/**  
> Category: architecture  

---

## 1. Architectural Invariant

During every engineering request, bug remediation, architectural refactoring, or feature development task, all autonomous AI agents and engineers MUST evaluate whether newly established patterns, user corrections, or architectural constraints warrant codification into the `.agents/` subsystem.

Under no circumstances shall an AI agent resolve a recurring engineering workflow, architectural correction, or new technical capability in ad-hoc application code without persisting or updating the governing asset in `.agents/`.

Specifically, agents MUST execute continuous auto-evolution triage according to this classification matrix:

| Artifact Target | Primary Purpose | Trigger Conditions (When to Act) | Structural Standard |
| :--- | :--- | :--- | :--- |
| **`.agents/rules/<name>.md`** | Codifies **WHAT IS REQUIRED OR PROHIBITED** (Invariants, boundaries, guardrails, linter commands). | User corrects bad practice, imposes technical prohibition, restricts package usage, or sets line count / nesting limits. | 5 mandatory sections, `RULE-[CAT]-[NUM]`, uppercase ID, DO/DON'T code blocks, runnable audit command. |
| **`.agents/skills/<name>/SKILL.md`** | Codifies **HOW TO CONSTRUCT STEP-BY-STEP** (Deterministic procedural workflows, scaffolds, templates). | Multi-step workflow (>=3 sequential steps across multiple layers/files) representing a repeatable pattern across modules. | 8 mandatory sections, kebab-case directory, bottom-up dependency ordering, defensive invariants, post-audit checklist. |
| **`.agents/agents/<name>.md`** | Codifies **WHO OPERATES** (Scoped persona, cognitive model, bounded tool permissions). | New specialized domain, distinct cognitive role, or adversarial review boundary requiring isolated tool permissions. | 4 mandatory sections, kebab-case filename, allowed/forbidden tools, explicit operational boundaries. |

### Invariant Guardrails:
1. **Enrich Existing vs Fragment New:** Before scaffolding a new file, inspect existing assets in `.agents/`. If a rule, skill, or subagent already governs the target layer or domain, update and enrich the existing asset rather than creating fragmented, overlapping, or conflicting micro-files.
2. **Bottom-Up Dependency Sequence:** Multi-file skills MUST order file creation from foundational internal layers to consumer layers:
   `Enums (core/) -> Models (domain/) -> DTOs & Collections (data/) -> Repositories (data/) -> Services (domain/) -> DI Registration (locator.dart) -> ARB Translations (l10n/) -> Providers & Widgets (presentation/)`.
3. **Mandatory Quality Validation:** Any newly created or modified asset in `.agents/` MUST adhere to 100% Technical English, Zero Emojis, clean relative markdown links, and pass `python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py` with zero failures.

---

## 2. Rationale & Failure Impact

- **Persistent Knowledge Retention:** Without autonomous codification, architectural corrections, user preferences, and engineering conventions remain trapped in ephemeral chat context windows and are forgotten in future sessions.
- **Permanent Regression Prevention:** Codifying user corrections into `.agents/rules/` ensures future AI turns and automated validation gates continuously enforce the constraint across all files.
- **Workflow Determinism:** Codifying repeatable multi-step patterns into `.agents/skills/` eliminates agent improvisation, guaranteeing reliable code generation, proper dependency ordering, and zero compilation breakages.
- **Failure Impact:** Resolving user corrections only in immediate application files leads to recurrent architectural drift, repeated human corrections of identical anti-patterns, fragmented documentation, and degraded context efficiency.

---

## 3. Compliant Pattern (DO)

When the user establishes a new architectural constraint or recurring multi-file procedure, the agent updates application code AND codifies the standard into `.agents/`:

```dart
// [COMPLIANT] Step 1: Implement the requested application change cleanly
// lib/domain/models/catalog_item.dart

/// Represents an item in the domain catalog.
class CatalogItem {
  /// Unique identifier of the catalog item.
  final String id;

  /// Display title of the catalog item.
  final String title;

  /// Creates an immutable [CatalogItem] instance.
  const CatalogItem({required this.id, required this.title});
}
```

```markdown
<!-- [COMPLIANT] Step 2: Codify the invariant or update existing governing rule -->
<!-- .agents/rules/rule-layered-architecture-flow.md -->
### Compliant Pattern (DO)
Domain models must have zero external dependencies or UI imports.
```

```bash
# [COMPLIANT] Step 3: Run the automated asset validation gate
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v

# [COMPLIANT] Step 4: Disclose the new or updated asset in the final report
# Disclosed in single completion report:
# - Updated: .agents/rules/rule-layered-architecture-flow.md (Enriched with pure model invariant)
```

---

## 4. Prohibited Pattern (DON'T)

Under no circumstances shall an agent perform isolated ad-hoc fixes that ignore the `.agents/` ecosystem:

```dart
// [PROHIBITED] Fixing a user-flagged violation in a single file while leaving 
// the underlying architectural gap uncodified in .agents/rules/ or .agents/skills/
// Example: Removing a hardcoded string from a screen without ensuring 
// RULE-L10N-001 or bilingual-localization-sync covers the pattern.
```

```markdown
<!-- [PROHIBITED] Creating duplicate, conflicting, or non-standard assets -->
<!-- Creating .agents/skills/meta-ecosystem-architect/ when agent-system-architect already exists -->
<!-- Creating rules with non-standard IDs, Spanish prose, or Unicode emojis -->
```

```bash
# [PROHIBITED] Bypassing automated asset validation after modifying .agents/
# Submitting deliverables without running validate_agent_assets.py
```

---

## 5. Automated Validation & Audit Procedure

Execute these automated terminal commands to verify that `.agents/` assets are structurally valid, non-redundant, and compliant with all quality gates:

```bash
# 1. Validate all .agents assets (frontmatter, required sections, zero emojis, relative links)
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v

# 2. Audit modular architecture status and active inventory
python3 .agents/skills/agent-system-architect/scripts/check_decomposition_status.py

# 3. Assert no duplicate or redundant meta-skills exist in .agents/skills/
test ! -d .agents/skills/meta-ecosystem-architect
```

Expected output: 0 failures, exit code 0. Any failure constitutes an immediate build blocker.
