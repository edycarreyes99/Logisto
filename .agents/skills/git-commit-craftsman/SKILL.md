---
name: git-commit-craftsman
description: |
  Comprehensive procedural guide for constructing high-precision, atomic, conventional git commits.
  Enforces conventional commit specifications, logical patch staging, granular isolation, and detailed technical records.
  Mandatory trigger conditions:
  - Trigger when staging, structuring, or executing git commits across the repository.
  - Trigger when decomposing large, multi-file working tree changes into atomic, logical commits.
  Do NOT trigger when:
  - Do not trigger for purely non-git tasks such as UI layout or domain entity modeling without committing.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: devops
  publisher: Architecture Standards Team
---

# Git Commit Craftsman

> Standard: Conventional Commits v1.0.0 Specification  
> Scope: Universal Repository Version Control Lifecycle  
> Level: Prescriptive Workflow  
> Reference Matrix: [references/conventional-commit-matrix.md](references/conventional-commit-matrix.md)  

---

## 1. Executive Summary & Objective

In enterprise production codebases, high-quality git history is a foundational engineering asset. Coarse, monolithic commits such as "wip" or "fix stuff" destroy traceability, degrade automated changelog generation, complicate bisecting regressions, and make peer code review hazardous.

The `git-commit-craftsman` skill provides a deterministic, rigorous methodology for grouping modifications into cohesive, atomic commits. It standardizes conventional commit syntax (`type(scope): message`), mandates detailed technical rationale in the commit body, enforces clean staging area boundaries, and validates that every commit leaves the repository in a compilable, verified state.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Staging and committing changes after completing an architectural milestone, bug fix, or feature.
- Decomposing large, uncommitted working tree diffs into clean, isolated, granular commits.
- Creating semantic release commits and structured pull request commit sequences.
- Documenting refactoring, performance improvements, or infrastructure migrations.

### 2.2. When to Avoid This Skill
- Writing application business logic without version control actions.
- Running headless analysis or test suites without recording repository snapshots.
- Modifying remote CI branch configurations outside git commit workflows.

---

## 3. Pre-Flight Verification (Step 0)

Before executing any commit operation, inspect the repository state and verify branch health:

```bash
# 1. Verify current branch and repository status
git status --short

# 2. Inspect unstaged and staged diffs
git diff --stat
git diff --staged --stat

# 3. Ensure static analyzer and test suite pass before committing
flutter analyze
flutter test
```

Do not commit code that breaks the build or introduces static analysis warnings unless explicitly creating an isolated reproduction test case.

---

## 4. Canonical Commit Standards & Architecture Contracts

Every commit MUST adhere strictly to the Conventional Commits specification:

### 4.1. Message Structure
```text
<type>(<scope>): <summary in imperative mood, no period, <= 72 characters>

<Detailed explanation of context, problem statement, and architectural rationale.
Explain why this modification was necessary and what invariants are preserved.>

Technical Highlights:
- Bulleted list detailing concrete changes, file modifications, or refactors.
- Impact on state management, dependencies, or database schemas.
- Verification record: executed tests, coverage results, and zero-warning gates.
```

### 4.2. Core Types
- `feat`: Introduces a new feature or user-facing capability.
- `fix`: Resolves a bug, defect, or broken state.
- `refactor`: Structural code re-architecting without changing external behavior.
- `perf`: Measurable performance optimization (CPU, memory, frame rendering).
- `test`: Addition or refactoring of unit, widget, or integration test suites.
- `docs`: Documentation, reference catalogs, or code comments.
- `style`: Visual styling, whitespace formatting, design token alignment.
- `build`: Build system dependencies, Gradle, CocoaPods, CMake, pubspec.
- `ci`: Continuous integration workflows, GitHub Actions, devops pipeline.
- `chore`: Maintenance tasks, tool scripts, git ignore adjustments.

### 4.3. Standard Scopes
Refer to [references/conventional-commit-matrix.md](references/conventional-commit-matrix.md) for full scope definitions: `agents`, `core`, `locator`, `theme`, `l10n`, `domain`, `data`, `auth`, `navigation`, `dashboard`, `pos`, `billiards`, `cash`, `inventory`, `kitchen`, `invoices`, `purchasing`, `reports`, `users`, `settings`, `onboarding`.

---

## 5. Step-by-Step Execution Workflow

Follow this 5-step sequence for every commit batch:

### Step 1: Triage Working Tree Modifications
Examine all modified and untracked files with `git status`. Group files into cohesive architectural layers:
1. System infrastructure and agent configurations (`.agents/`, rules, skills).
2. Project configuration, build scripts, and dependencies (`pubspec.yaml`, `ios/`, `macos/`, `windows/`).
3. Core architecture, utilities, and service locator (`lib/core/`, `lib/locator.dart`).
4. Theme tokens and styling (`lib/theme/`).
5. Localization strings and delegates (`lib/l10n/`).
6. Domain entities and data repositories (`lib/domain/`, `lib/data/`).
7. Presentation features and screens grouped by domain (`lib/presentation/<feature>/`).
8. Automated test suites (`test/<layer>/`).

### Step 2: Stage Isolated Logical Units
Stage only the files belonging to the single logical unit under commit. Avoid using blanket `git add .` unless the commit is an atomic project-wide formatting change:

```bash
# Stage specific files
git add path/to/file1.dart path/to/file2.dart
```

### Step 3: Verify Staged Content
Inspect the staged diff before writing the commit message:

```bash
git diff --staged
```

Ensure no unintended files, debug print statements, or secrets were staged.

### Step 4: Author the Structured Commit Message
Format the commit message using multi-flag syntax or a temporary commit message file:

```bash
git commit -m "feat(scope): concise imperative subject" -m "Comprehensive explanation of motivation and architecture context.

Technical Highlights:
- Modified component X to support responsive grid layouts.
- Added validation logic for edge case Y.
- Verified with unit tests in test/feature/."
```

### Step 5: Post-Commit Inspection
Verify the newly created commit:

```bash
git log -1 --stat
```

---

## 6. Edge Cases & Recovery Protocols

### 6.1. Staged Files Belong to Multiple Concerns
If files spanning multiple domains were inadvertently staged together:
```bash
git restore --staged <unrelated_file>
```
Only commit the cohesive subset.

### 6.2. Incomplete or Inaccurate Commit Message
If the commit message requires correction before pushing:
```bash
git commit --amend -m "correct(scope): updated message"
```

### 6.3. Merge Conflicts During Stash/Rebase
Resolve conflict markers deterministically, re-run static analysis (`flutter analyze`), and verify test suites (`flutter test`) before finalizing the commit.

---

## 7. Verification & Audit Quality Gates

Every commit sequence must pass these verification gates:
1. **Zero Analyzer Warnings:** `flutter analyze` returns zero issues.
2. **Zero Test Regressions:** `flutter test` completes with 100% passing tests.
3. **Commit Message Format:** Conforms to `<type>(<scope>): <summary>` format.
4. **Clean Tree State:** When all batches are committed, `git status` shows a working tree clean of unintended changes.
