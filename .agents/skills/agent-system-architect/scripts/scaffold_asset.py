#!/usr/bin/env python3
"""
Autonomous Asset Scaffolding Tool for .agents Subsystem.
Enables AI agents and engineers to programmatically scaffold:
- Modular Skills in .agents/skills/<skill-name>/SKILL.md
- Subagents in .agents/agents/<agent-name>.md
- Architectural Rules in .agents/rules/<rule-name>.md

Zero external dependencies: runs with standard Python 3.8+.
"""

import sys
import re
import os
import pathlib
import argparse
from typing import List, Optional

KEBAB_CASE_PATTERN = re.compile(r'^[a-z0-9]+(-[a-z0-9]+)*$')
RULE_ID_PATTERN = re.compile(r'^RULE-[A-Z0-9]+-[0-9]{3}$')


def title_case_from_kebab(kebab: str) -> str:
    """Convert kebab-case string to Title Case."""
    return ' '.join(word.capitalize() for word in kebab.split('-'))


def find_agents_root(explicit_root: Optional[str] = None) -> pathlib.Path:
    """Dynamically discover the .agents root directory without hardcoded absolute paths."""
    if explicit_root:
        return pathlib.Path(explicit_root).resolve()

    cwd = pathlib.Path.cwd().resolve()
    if cwd.name == ".agents" and (cwd / "skills").exists():
        return cwd
    if (cwd / ".agents").exists():
        return (cwd / ".agents").resolve()

    script_dir = pathlib.Path(__file__).resolve().parent
    for parent in [script_dir] + list(script_dir.parents):
        if parent.name == ".agents" and (parent / "skills").exists():
            return parent
        if (parent / ".agents").exists():
            return (parent / ".agents").resolve()

    for parent in list(cwd.parents):
        if (parent / ".agents").exists():
            return (parent / ".agents").resolve()

    return (cwd / ".agents").resolve()


def scaffold_skill(agents_root: pathlib.Path, name: str, description: str, category: str, publisher: str = "Architecture Standards Team") -> int:
    if not KEBAB_CASE_PATTERN.match(name):
        print(f"ERROR: Skill name '{name}' must be lowercase kebab-case.")
        return 1

    skill_dir = agents_root / "skills" / name
    if skill_dir.exists():
        print(f"ERROR: Skill directory already exists: {skill_dir}")
        return 1

    skill_dir.mkdir(parents=True, exist_ok=True)
    (skill_dir / "scripts").mkdir(exist_ok=True)
    (skill_dir / "templates").mkdir(exist_ok=True)
    (skill_dir / "references").mkdir(exist_ok=True)
    (skill_dir / "schemas").mkdir(exist_ok=True)

    title = title_case_from_kebab(name)
    skill_file = skill_dir / "SKILL.md"

    content = f"""---
name: {name}
description: |
  {description}
  Mandatory trigger conditions:
  - Trigger when {title} is explicitly requested.
  - Trigger when implementing or refactoring components in this domain.
  Do NOT trigger when:
  - Do not trigger for unrelated layer tasks or alternative workflows.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: {category}
  publisher: {publisher}
---

# {title}

> Standard: Enterprise Production Grade  
> Scope: Target domain for {name}  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

Provide an unambiguous, technical explanation of the engineering objective governed by this skill.
Detail why this capability exists and what system invariants it upholds.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Explicit scenario 1.
- Explicit scenario 2.
- User request patterns matching this workflow.

### 2.2. When to Avoid This Skill
- Out-of-scope scenarios.
- Alternative skills to delegate to instead.

---

## 3. Pre-Flight Verification (Step 0)

Before executing modifications or generating assets, execute these deterministic checks:

```bash
# Verify environment and tooling prerequisites
echo "Checking prerequisites for {name}..."
```

---

## 4. Canonical Specification & Standards

Define the exact contracts, patterns, and interfaces required.

### 4.1. Core Types & Interfaces
Detail types, signatures, and contracts.

### 4.2. File Layout & Naming Conventions
```
src/path/to/target/
├── example_module_1.ext
└── example_module_2.ext
```

---

## 5. Step-by-Step Implementation Procedure

Follow these deterministic sequential steps:

### Step 1: Initial Preparation
Describe the phase action, inputs, and constraints.

```
// Compliant code implementation
```

### Step 2: Core Implementation
Describe the phase action, inputs, and constraints.

```
// Compliant code implementation
```

### Step 3: Integration & Registration
Describe the phase action, inputs, and constraints.

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| Missing dependency | Runtime crash or missing symbol | Assert pre-flight registration in locator |
| Concurrent mutation | Race condition or inconsistent state | Implement optimistic update with rollback |

---

## 7. Verification & Quality Gates

Run these validation commands to verify compliance:

```bash
# Verify implementation
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py
```

Checklist:
- [ ] Conforms to all dependency flow rules.
- [ ] No hardcoded string literals.
- [ ] Strongly typed enums used for state and variants.
- [ ] All public APIs have comprehensive English doc comments.
- [ ] Zero emojis in code, documentation, and metadata.
"""

    skill_file.write_text(content, encoding='utf-8')
    print(f"SUCCESS: Created skill at {skill_file}")
    return 0


def scaffold_agent(agents_root: pathlib.Path, name: str, role: str, description: str, mode: str) -> int:
    if not KEBAB_CASE_PATTERN.match(name):
        print(f"ERROR: Agent name '{name}' must be lowercase kebab-case.")
        return 1

    agents_dir = agents_root / "agents"
    agents_dir.mkdir(parents=True, exist_ok=True)
    agent_file = agents_dir / f"{name}.md"

    if agent_file.exists():
        print(f"ERROR: Agent file already exists: {agent_file}")
        return 1

    title = title_case_from_kebab(name)

    content = f"""---
name: {name}
role: {role}
description: |
  {description}
mode: {mode}
allowed_tools:
  - run_command
  - view_file
  - write_to_file
  - replace_file_content
  - send_message
forbidden_tools:
  - ask_question
---

# {title} Persona Specification

> Role Mandate: {role}  
> Target Domain: Specialized bounded context for {name}  
> Parent Agent Protocol: Single final report via send_message, zero interim noise.  

---

## 1. Role Definition & Operational Boundaries

### 1.1. Core Identity
Senior specialist focused exclusively on {name}.
Operate with extreme engineering rigor, defensive design, and adversarial skepticism toward unverified assumptions.

### 1.2. Allowed Responsibilities
- Primary domain responsibility 1.
- Primary domain responsibility 2.
- Verification and testing within bounded scope.

### 1.3. Strict Exclusions (Out of Scope)
- Modifying files outside the designated domain.
- Weakening, skipping, or deleting tests.
- Emitting interim chatter or status noise.

---

## 2. Invariants & Guardrails

1. **Language Invariant:** Write 100% of code, doc comments, commits, and reports in English.
2. **Zero Emoji Policy:** Absolutely zero emojis in any generated file, commit, or communication.
3. **Immutability & Safety:** Respect existing interfaces; enforce compile-time type safety.
4. **No Weakening of Verification:** Never delete, skip, or disable existing tests or lint rules.

---

## 3. Communication Protocol with Parent Agent

1. **No Interim Noise:** Never send progress pings, status reminders, or partial chatter.
2. **Deterministic Output:** Send exactly one structured completion report via send_message upon conclusion.
3. **Escalation Rules:** If blocked by external missing dependencies, halt and report root cause immediately.

---

## 4. Execution Workflow

### Phase 1: Intake & Bounded Inspection
Review task context, target files, and existing tests within assigned domain.

### Phase 2: Surgical Implementation
Apply changes matching established architectural patterns in the codebase.

### Phase 3: Rigorous Verification
Execute tests and lint checks to confirm zero regressions.

### Phase 4: Final Structured Report
Deliver standard completion report to the parent coordinator.
"""

    agent_file.write_text(content, encoding='utf-8')
    print(f"SUCCESS: Created agent at {agent_file}")
    return 0


def scaffold_rule(agents_root: pathlib.Path, name: str, rule_id: str, title: str, category: str, severity: str) -> int:
    if not KEBAB_CASE_PATTERN.match(name):
        print(f"ERROR: Rule name '{name}' must be lowercase kebab-case.")
        return 1

    if not RULE_ID_PATTERN.match(rule_id):
        print(f"ERROR: Rule ID '{rule_id}' must match RULE-[A-Z]+-[0-9]{{3}}.")
        return 1

    rules_dir = agents_root / "rules"
    rules_dir.mkdir(parents=True, exist_ok=True)
    rule_file = rules_dir / f"{name}.md"

    if rule_file.exists():
        print(f"ERROR: Rule file already exists: {rule_file}")
        return 1

    content = f"""---
id: {rule_id}
title: {title}
category: {category}
severity: {severity}
scope:
  include:
    - "src/**"
  exclude:
    - "tests/**"
---

# {title}

> Rule ID: {rule_id}  
> Severity: {severity}  
> Target Scope: src/**  
> Category: {category}  

---

## 1. Architectural Invariant

State the invariant clearly, concisely, and imperatively:
Classes governed by this rule MUST strictly adhere to this constraint without exception.

---

## 2. Rationale & Failure Impact

Explain the architectural justification:
- Preservation of clean separation of concerns.
- Testability and decoupling from external state.
- Failure Impact: Violations introduce technical debt, test fragility, and tight coupling.

---

## 3. Compliant Pattern (DO)

Demonstrate the approved implementation:

```
// Compliant implementation adhering to {rule_id}
```

---

## 4. Prohibited Pattern (DON'T)

Demonstrate the anti-pattern that violates this rule:

```
// Anti-pattern prohibited by {rule_id}
```

---

## 5. Automated Validation & Audit Procedure

Runnable terminal command to verify zero violations:

```bash
# Automated audit command
rg --glob 'src/**' 'prohibited_pattern_regex'
```

Expected output: 0 matches. Any match constitutes an immediate build failure.
"""

    rule_file.write_text(content, encoding='utf-8')
    print(f"SUCCESS: Created rule at {rule_file}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Scaffold .agents assets programmatically.")
    parser.add_argument("--root", default=None,
                        help="Path to .agents root directory (dynamically resolved if omitted).")
    parser.add_argument("--type", required=True, choices=["skill", "agent", "rule"],
                        help="Asset type to scaffold.")
    parser.add_argument("--name", required=True, help="Asset name in kebab-case.")
    parser.add_argument("--description", default="", help="Description for skill or agent.")
    parser.add_argument("--category", default="architecture", help="Category for skill or rule.")
    parser.add_argument("--publisher", default="Architecture Standards Team", help="Publisher name for skill metadata.")
    parser.add_argument("--id", default="", help="Rule ID (e.g., RULE-ARCH-001).")
    parser.add_argument("--title", default="", help="Title for rule.")
    parser.add_argument("--severity", default="blocking", choices=["blocking", "critical", "warning"],
                        help="Severity for rule.")
    parser.add_argument("--role", default="", help="Role title for agent.")
    parser.add_argument("--mode", default="subagent", choices=["subagent", "worker", "reviewer", "orchestrator"],
                        help="Execution mode for agent.")

    args = parser.parse_args()
    agents_root = find_agents_root(args.root)

    if not agents_root.exists():
        print(f"ERROR: .agents directory '{agents_root}' does not exist.")
        return 1

    if args.type == "skill":
        desc = args.description or f"Modular procedural skill for {args.name}."
        return scaffold_skill(agents_root, args.name, desc, args.category, args.publisher)
    elif args.type == "agent":
        desc = args.description or f"Specialized subagent persona for {args.name}."
        role = args.role or f"{title_case_from_kebab(args.name)} Specialist"
        return scaffold_agent(agents_root, args.name, role, desc, args.mode)
    elif args.type == "rule":
        rule_id = args.id or "RULE-ARCH-001"
        title = args.title or f"Enforce {title_case_from_kebab(args.name)}"
        return scaffold_rule(agents_root, args.name, rule_id, title, args.category, args.severity)

    return 1


if __name__ == "__main__":
    sys.exit(main())
