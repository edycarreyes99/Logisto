---
id: RULE-ARCH-009
title: Local Workspace Agent Skill Scope Enforcement
category: architecture
severity: blocking
scope:
  include:
    - ".agents/**"
    - ".agent/**"
---

# Local Workspace Agent Skill Scope Enforcement

> Rule ID: RULE-ARCH-009  
> Severity: blocking  
> Target Scope: .agents/**, .agent/**  
> Category: architecture  

---

## 1. Architectural Invariant

SKILL SCOPE RULE: Autonomous agents MUST ignore and NEVER load or execute any global agent skills from `~/.gemini/config/skills/` or `~/.gemini/antigravity/skills/`.

Only discover, read, and execute workspace-local skills located inside `.agents/skills/` or `.agent/skills/` of this project.

Under no circumstances shall any AI agent, orchestrator, subagent, or automated workflow resolve, trigger, or depend upon externally installed or global user-level skill directories outside this repository's workspace root.

---

## 2. Rationale & Failure Impact

- **Hermetic Reproducibility:** Global skills residing in user home directories (`~/.gemini/...`) vary across developer machines and CI/CD runners, breaking deterministic development environments.
- **Project Boundary Integrity:** The Logisto project defines its own tailored architecture, Material 3 conventions, bilingual parity, test coverage, and Firestore infrastructure rules inside `.agents/`. External skills can contaminate or contradict these bespoke project patterns.
- **Security & Scope Containment:** Preventing arbitrary invocation of global skills guarantees that all agent operations strictly conform to the auditable and version-controlled instructions maintained directly within the repository.
- **Failure Impact:** Invoking global skills causes conflicting multiplatform instructions, inconsistent code generation, architectural divergence, and unpredictable behavior across different developer workstations.

---

## 3. Compliant Pattern (DO)

Always resolve, discover, and trigger skills exclusively from the local project repository paths:

```bash
# Correct: Discover and execute workspace-local skills
.agents/skills/bilingual-localization-sync/SKILL.md
.agents/skills/bootstrap-component-library/SKILL.md
.agents/skills/firestore-repository-builder/SKILL.md
.agents/skills/automated-test-suite-runner/SKILL.md
.agents/skills/agent-system-architect/SKILL.md
```

Agents reading instructions MUST verify that the skill path starts with the workspace root:

```markdown
<!-- Compliant Agent Delegation -->
Agent triggers:
- path: ".agents/skills/bilingual-localization-sync/SKILL.md"
- scope: workspace-local
```

---

## 4. Prohibited Pattern (DON'T)

Never inspect, load, recommend, or trigger global skills from user home directories:

```bash
# PROHIBITED: Attempting to read or execute skills from global user directories
~/.gemini/config/skills/*
~/.gemini/antigravity/skills/*
/Users/<user>/.gemini/config/skills/*
/Users/<user>/.gemini/antigravity/skills/*
```

```markdown
<!-- PROHIBITED Agent Delegation -->
Agent triggers:
- path: "~/.gemini/config/skills/firebase-auth-basics/SKILL.md" <!-- VIOLATION: Global path -->
- path: "~/.gemini/antigravity/skills/automation/SKILL.md"       <!-- VIOLATION: Global path -->
```

---

## 5. Automated Validation & Audit Procedure

Execute the following verification commands to ensure no global skill paths are referenced and that the `.agents` asset suite passes all validation checks:

```bash
# 1. Verify no global skill directories are referenced inside .agents/
! grep -rn "~/\.gemini" .agents/

# 2. Validate all .agents assets (frontmatter, required sections, zero emojis, relative links)
python3 .agents/skills/agent-system-architect/scripts/validate_agent_assets.py -v
```
