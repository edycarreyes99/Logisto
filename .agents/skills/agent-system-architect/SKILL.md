---
name: agent-system-architect
description: |
  Comprehensive meta-skill for creating, structuring, validating, and decomposing AI agent assets in .agents/.
  Mandatory trigger conditions:
  - Trigger when creating, editing, or refactoring procedural Skills, Subagents, or Rules in .agents/.
  - Trigger when autonomously detecting new repeatable workflows, architectural corrections, or specialized domains.
  - Trigger when decomposing monolithic architecture blueprints into modular skills, agents, and rules.
  Do NOT trigger when:
  - Do not trigger for writing standard application feature code that does not establish new architectural patterns.
  - Do not trigger for trivial bug fixes or one-off scripts that do not warrant persistent agent instructions.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: meta
  publisher: Architecture Standards Team
---

# Agent System Architect

> Standard: Enterprise AI Agent Infrastructure Specification  
> Scope: Universal `.agents/` directory architecture (`skills/`, `agents/`, `rules/`)  
> Governance: Zero Emojis, 100% Technical English, Strict Automated Validation  
> Automated Validator: [scripts/validate_agent_assets.py](scripts/validate_agent_assets.py)  
> Scaffolding Tool: [scripts/scaffold_asset.py](scripts/scaffold_asset.py)  
> Migration Dashboard: [scripts/check_decomposition_status.py](scripts/check_decomposition_status.py)  

---

## 1. Executive Summary & Objective

Modern autonomous coding agents require clear, modular, and deterministic instructions to operate reliably in enterprise software environments. Monolithic prompt files and sprawling architecture manuals degrade LLM context windows, induce hallucinations, and cannot be conditionally loaded or audited.

The `.agents/` subsystem establishes a structured, modular operating system for AI agents in any codebase. It divides engineering knowledge into three distinct, first-class primitives:

1. **Skills (`.agents/skills/<skill-name>/SKILL.md`):** Actionable, step-by-step procedural workflows, executable scripts, and code templates. Skills tell agents **how to do something** (e.g., scaffolding a clean architecture feature, configuring data streams, building responsive layouts).
2. **Subagents (`.agents/agents/<agent-name>.md`):** Specialized persona definitions, bounded operating contexts, and tool access matrices. Subagents define **who does the work and what tools they can touch** (e.g., Presentation Architect, Data Specialist, QA Auditor).
3. **Rules (`.agents/rules/<rule-name>.md`):** Non-negotiable architectural boundaries, invariants, and lint patterns. Rules tell agents **what must never be violated** (e.g., unidirectional layer flow, widget build length limits, bilingual localization parity).

This meta-skill acts as the authoritative engineering standard for creating, maintaining, validating, and decomposing all three primitives.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
This meta-skill activates under two distinct execution scenarios:

1. **Explicit Invocations & Intent Triggers:**
   - Whenever an AI agent or engineer specifically requests to create, edit, or refactor a skill, subagent, or rule in `.agents/`.
   - Whenever prompt requests match explicit trigger phrases in English or Spanish:
     - **Skill Scaffolding & Flow Standardization:** `"create skill"`, `"new skill"`, `"crear skill"`, `"nueva skill"`, `"standardize flow"`, `"estandarizar flujo"`, `"save this pattern"`, `"guardar este patron"`, `"guardar este patrón"`, `"automate this process"`, `"automatizar este proceso"`.
     - **Rule Creation & Policy Constraints:** `"create rule"`, `"new rule"`, `"crear regla"`, `"nueva rule"`, `"add invariant"`, `"enforce boundary"`.
     - **Subagent Scaffolding & Role Delegation:** `"create agent"`, `"new agent"`, `"scaffold agent"`, `"crear agente"`, `"nuevo agent"`.
     - **Architecture Evolution:** `"evolve architecture"`, `"evolucionar arquitectura"`, `"update agents"`.
   - Whenever decomposing a legacy monolithic architecture blueprint (such as an `AGENTS.md`) into modular assets.

2. **Proactive Detection (Continuous Autonomous Evolution - RULE-ARCH-008):**
   - **Recurring Procedural Workflow Candidate (`skills/`):** When the user requests a multi-step workflow (>=3 sequential steps across multiple layers or files) that represents a repeatable pattern across modules (e.g., scaffolding a vertical CRUD domain, integrating third-party APIs, or standardizing responsive UI blocks).
   - **Architectural Correction Candidate (`rules/`):** When the user or reviewer corrects bad practices, enforces technical prohibitions ("never import X in Y", "always enforce sub-40-line build methods"), or defines repository guardrails.
   - **Specialized Domain Candidate (`agents/`):** When the project incorporates a new technical domain or adversarial review boundary requiring unique tool permissions or isolated operating contexts.

### 2.2. When to Avoid This Skill
- For writing standard application feature code that does not establish new architectural patterns or agent guidelines.
- For trivial bug fixes or one-off script executions that do not warrant persistent agent instructions.

---

## 3. Pre-Flight Verification (Step 0)

Before creating or refactoring any asset in `.agents/`, execute these deterministic checks:

```bash
# 1. Verify standard Python 3 runtime is available
python3 --version

# 2. Verify workspace root directory contains .agents subsystem
test -d .agents && echo "Subsystem located."

# 3. Audit current health of existing assets
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py
```

Prerequisites:
- Ensure `.agents/skills/`, `.agents/agents/`, and `.agents/rules/` directories exist.
- Ensure that the proposed asset name in lowercase kebab-case does not already exist.

---

## 4. Canonical Specification & Standards

All agent configuration assets reside inside the root `.agents/` directory:

```
<workspace_root>/
└── .agents/
    ├── skills/                                    # Modular procedural capabilities
    │   └── [skill-name]/                          # Dedicated skill folder in kebab-case
    │       ├── SKILL.md                           # Canonical skill entry point (YAML + Markdown)
    │       ├── scripts/                           # Helper automation scripts (bash, python, etc.)
    │       ├── templates/                         # Code templates, scaffolds, and snippets
    │       ├── references/                        # Supporting documentation, mappings, specifications
    │       └── schemas/                           # JSON validation schemas for inputs or frontmatter
    │
    ├── agents/                                    # Specialized AI personas and subagent definitions
    │   ├── [agent-name].md                        # Scoped persona definition with tool permissions
    │   └── .gitkeep                               # Directory structure anchor
    │
    └── rules/                                     # Non-negotiable architectural invariants
        ├── [rule-name].md                         # Invariant contract with DO/DON'T and CLI audit commands
        └── .gitkeep                               # Directory structure anchor
```

### 4.0. Architectural Triage Matrix & Evolution Principles

Before creating or refactoring any asset in `.agents/`, classify engineering knowledge using this triage matrix:

| Artifact Target | Primary Purpose | Nature | Activation Mode | Scope & Granularity |
| :--- | :--- | :--- | :--- | :--- |
| **Subagents (`.agents/agents/<name>.md`)** | Defines **WHO OPERATES** (Persona, role, cognitive model, domain vision, tool permissions). | Declarative & Cognitive (Identity). | Direct delegation or domain role routing. | 100 - 250 lines. Bounded to specific tool access matrices. |
| **Rules (`.agents/rules/<name>.md`)** | Defines **WHAT IS REQUIRED OR PROHIBITED** (Invariants, boundaries, guardrails, linter commands). | Restrictive & Conditional (Guardrails). | Always-on or path-scoped via `scope.include`. | 30 - 150 lines. Compact, atomic, non-overlapping. |
| **Skills (`.agents/skills/<name>/SKILL.md`)** | Defines **HOW TO CONSTRUCT STEP-BY-STEP** (Deterministic procedural workflows, scaffolds, templates). | Procedural & Imperative (Recipes). | On-demand matching explicit triggers or detected workflows. | 150 - 500+ lines. Comprehensive workflows with supporting assets. |

#### Architectural Evolution Invariant Principles:
1. **Enrich Existing vs Fragment New:** Before scaffolding a new file, always inspect existing assets in `.agents/`. If a rule, skill, or subagent already governs the target layer or domain (e.g. `rule-layered-architecture-flow.md` or `provider-state-management`), expand and enrich the existing asset rather than creating fragmented, overlapping micro-files.
2. **Bottom-Up Dependency Sequence:** Multi-file skills MUST order file creation from foundational internal layers to consumer layers:
   `Enums (core/) -> Models (domain/) -> DTOs & Collections (data/) -> Repositories (data/) -> Services (domain/) -> DI Registration (locator.dart) -> ARB Translations (l10n/) -> Providers & Widgets (presentation/)`.

### 4.1. The Modular Skill Specification (`.agents/skills/<skill-name>/SKILL.md`)

Every skill entry point must contain valid YAML frontmatter:

```yaml
---
name: [skill-name-in-kebab-case]
description: |
  [High-level summary of what this skill provides. State clearly what problems it solves.]
  Mandatory trigger conditions:
  - Trigger when [explicit scenario 1]
  - Trigger when [explicit scenario 2]
  Do NOT trigger when:
  - Do not trigger when [negative boundary 1]
license: Apache-2.0
metadata:
  version: 1.0.0
  category: [architecture | data | presentation | localization | theme | devops | meta]
  publisher: Architecture Standards Team
---
```

Followed by 8 mandatory markdown sections:
1. **Title & Standard Header**
2. **Executive Summary & Objective**
3. **Trigger Conditions & Decision Boundary**
4. **Pre-Flight Verification (Step 0)**
5. **Canonical Specification & Standards**
6. **Step-by-Step Implementation Procedure**
7. **Edge Cases & Defensive Invariants (Table)**
8. **Verification & Quality Gates**

Canonical template: [templates/skill-template.md](templates/skill-template.md)  
JSON Schema: [schemas/skill-frontmatter-schema.json](schemas/skill-frontmatter-schema.json)

### 4.2. The Subagent Specification (`.agents/agents/<agent-name>.md`)

Every subagent file defines the exact boundaries, execution mode, and tool permissions of that specialist:

```yaml
---
name: [agent-name-in-kebab-case]
role: [Technical Role Title, e.g., Presentation Layer Architect]
description: |
  [Concise technical summary of this agent persona and bounded responsibility.]
mode: [subagent | worker | reviewer | orchestrator]
allowed_tools:
  - run_command
  - view_file
  - write_to_file
  - replace_file_content
  - send_message
forbidden_tools:
  - [prohibited_tool_name]
---
```

Followed by 4 mandatory sections:
1. **Role Definition & Operational Boundaries:** Core identity, allowed duties, and strict exclusions.
2. **Invariants & Guardrails:** Zero emojis, 100% technical English, immutability, zero test weakening.
3. **Communication Protocol:** Single structured completion report via `send_message`, zero interim chatter.
4. **Execution Workflow:** Sequential phases from intake, inspection, implementation, verification, to reporting.

Canonical template: [templates/agent-template.md](templates/agent-template.md)  
JSON Schema: [schemas/agent-frontmatter-schema.json](schemas/agent-frontmatter-schema.json)

### 4.3. The Architectural Rule Specification (`.agents/rules/<rule-name>.md`)

Rules define deterministic, invariant constraints that must be observed across the codebase:

```yaml
---
id: RULE-[CATEGORY]-[NUMBER]
title: [Short Imperative Rule Title]
category: [architecture | presentation | data | domain | theme | l10n | lint | quality]
severity: [blocking | critical | warning]
scope:
  include:
    - "src/**"
  exclude:
    - "tests/**"
---
```

Followed by 5 mandatory sections:
1. **Architectural Invariant:** Unambiguous imperative rule statement.
2. **Rationale & Failure Impact:** Technical justification and consequences of violation.
3. **Compliant Pattern (DO):** Complete, positive code example.
4. **Prohibited Pattern (DON'T):** Complete negative code example showing anti-pattern.
5. **Automated Validation & Audit Procedure:** Executable terminal command (e.g., `rg` or `grep`) verifying zero violations.

Canonical template: [templates/rule-template.md](templates/rule-template.md)  
JSON Schema: [schemas/rule-frontmatter-schema.json](schemas/rule-frontmatter-schema.json)

---

## 5. Step-by-Step Implementation Procedure

### 5.1. Autonomous AI Self-Creation Protocol (RULE-ARCH-008)

When an AI agent is working on user requests, it must evaluate whether new engineering patterns should be codified into `.agents/`.

#### Decision Heuristics:
1. **Create or Enrich a Rule** if:
   - A non-negotiable architectural invariant or boundary constraint is established or corrected.
   - A pattern must be systematically audited across multiple files via static analysis, linter rules, or regex.
2. **Create or Enrich a Skill** if:
   - A multi-step procedure (>=3 steps) is executed that will be reused across multiple features or turns.
   - The capability requires reusable templates, schemas, or helper automation scripts.
3. **Create an Agent** if:
   - A distinct domain requires isolated tool permissions (e.g., a reviewer persona that cannot write code).
   - An adversarial verification role is needed to audit code independently before merging.

#### Execution Steps:

```bash
# Step 1: Inspect existing assets to decide between enriching or scaffolding
ls -la .agents/rules .agents/skills .agents/agents

# Step 2: Scaffold asset using the automated CLI tool (if new)
python3 .agents/skills/agent-system-architect/scripts/scaffold_asset.py \
  --type [skill | agent | rule] \
  --name [kebab-case-name] \
  [--category category] [--id RULE-ID] [--title "Title"] [--role "Role"]

# Step 3: Implement complete, production-grade content adhering to templates
# Follow bottom-up dependency ordering for multi-file skills.
# Ensure zero placeholder comments (// TODO, // implement here).

# Step 4: Run the automated quality validation gate
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v

# Step 5: Disclose new or updated assets in the final single send_message report
```

#### Post-Codification Audit Checklist:
- [ ] Conforms to 100% Technical English for all code, comments, and markdown.
- [ ] Zero Unicode emojis anywhere in content or metadata.
- [ ] Strict relative links only; zero machine-specific absolute paths.
- [ ] All mandatory sections present and structurally sound.
- [ ] `validate_agent_assets.py -v` passes with 0 failures.

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| **Missing Third-Party Parsers** | System without PyYAML or Node.js fails frontmatter validation | Use built-in zero-dependency parser in `scripts/validate_agent_assets.py`. |
| **Accidental Emoji Injection** | Unicode pictographs slip into comments, commit messages, or code | Run automated regex scan covering all Unicode emoji blocks; reject PR on failure. |
| **Broken File Links** | Referenced companion files or templates move, causing broken documentation | Run automated relative link audit in `scripts/validate_agent_assets.py` verifying all link targets and prohibiting absolute paths. |
| **Interim Subagent Noise** | Subagents emit chat pings or progress updates, polluting coordinator context | Enforce single final completion report rule via subagent persona contracts. |
| **Incomplete Stub Examples** | Skills or rules contain `// implement here` placeholders | Enforce full code block validation during QA audit. |
| **Redundant Asset Creation** | AI creates duplicate meta-skills (e.g. meta-ecosystem-architect alongside agent-system-architect) | Enforce single meta-skill governance in `agent-system-architect` and validate active inventory with `check_decomposition_status.py`. |

### Non-Negotiable Invariants:
1. **Zero Emoji Policy:** Absolutely ZERO emojis in any `.agents/` file, commit message, code snippet, or documentation.
2. **English-Only Language Mandate:** 100% of code, comments, rules, skills, and agent definitions MUST be written in technical English.
3. **Strict Immutability & Impartiality:** Never weaken, skip, or delete tests to make checks pass.
4. **Single Structured Final Report:** Subagents must call `send_message` exactly once upon completion.
5. **Strict Relative Paths:** All documentation links and script references must use clean relative paths without machine-specific absolute directories.

---

## 7. Verification & Quality Gates

Run these validation commands to verify compliance across the `.agents` ecosystem:

```bash
# 1. Run the comprehensive automated validation gate
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v

# 2. Check modular architecture decomposition and migration status
python3 .agents/skills/agent-system-architect/scripts/check_decomposition_status.py
```

Expected output:
- `ALL QUALITY GATES PASSED (Zero emojis, valid frontmatter, strict sections).`
- Exit code 0.

---

## 8. Monolithic Blueprint Decomposition Protocol (Blueprint -> .agents/)

When migrating from a legacy monolithic architectural blueprint (e.g., an `AGENTS.md`) to a modular `.agents/` architecture, this protocol enables systematic decomposition into discrete, independently maintainable rules, skills, and agents. Once all units are extracted into `.agents/`, the legacy monolithic blueprint can be safely decommissioned.

Consult the comprehensive line-by-line mapping playbook at [references/agents-md-decomposition-matrix.md](references/agents-md-decomposition-matrix.md).

### 8.1. Target Distribution Summary

1. **Architectural Rules (`.agents/rules/`):**
   - Invariant constraints, dependency boundaries, and static analysis audit commands extracted from blueprint rule sections.

2. **Actionable Skills (`.agents/skills/`):**
   - End-to-end procedural workflows, scaffolds, and templates extracted from blueprint implementation guides.

3. **Specialized Subagents (`.agents/agents/`):**
   - Scoped personas, tool permissions, and operational boundaries extracted from blueprint role definitions.

### 8.2. Next Extraction Step
Run `python3 .agents/skills/agent-system-architect/scripts/check_decomposition_status.py` (or pass `--source-blueprint <path>`) to inspect target modules and track migration status.
