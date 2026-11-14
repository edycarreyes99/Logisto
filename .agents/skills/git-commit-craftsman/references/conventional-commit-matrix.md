# Conventional Commit Types and Scopes Matrix

> Standard: Conventional Commits v1.0.0 Specification  
> Scope: Universal Repository Version Control Standards  
> Governance: Zero Emojis, Technical Precision, Structured Semantic Payloads  

---

## 1. Commit Types Reference

| Type | Semantic Intent | Example Use Cases |
| :--- | :--- | :--- |
| `feat` | New feature or capability for the user or system | Added POS order cart calculations, new Billiards table view |
| `fix` | Bug fix or defect resolution | Fixed NaN calculation in invoice totals, resolved token expiry loop |
| `refactor` | Code restructuring without altering external behavior | Decomposed monolithic Screen into pure sub-widgets |
| `perf` | Performance enhancement reducing CPU, memory, or I/O | Added const constructors, optimized stream subscription debouncing |
| `style` | Formatting, whitespace, or visual presentation adjustments | Corrected padding in AppTextField, adjusted color token mapping |
| `test` | Authoring, updating, or fixing unit/widget/integration tests | Added 100% coverage tests for CashRegisterBloc, mock assertions |
| `docs` | Documentation updates, architectural guides, comments | Updated SKILL.md instructions, added docstrings to BaseRepository |
| `build` | Changes to build systems, Gradle, Podfile, pubspec dependencies | Added bootstrap_ui_flutter dependency, upgraded minSdk in build.gradle |
| `ci` | Changes to CI/CD workflows, scripts, or continuous deployment | Updated GitHub Actions matrix, configured test runner step |
| `chore` | Maintenance tasks, tool scripts, git ignore updates | Updated .gitignore, refreshed devtools configuration |

---

## 2. Standard Scopes by Layer

### 2.1. System & Architectural Infrastructure
- `agents`: Changes to `.agents/` metadata, skills, rules, or subagents.
- `core`: Shared core utilities, base validators, strongly typed enums, global constants.
- `locator`: Service locator dependency wiring (`lib/locator.dart`).
- `theme`: Design tokens, light/dark themes, color palettes, typography scales.
- `l10n`: ARB localization files, bilingual synchronization, generated translation delegates.

### 2.2. Data & Domain Layers
- `domain`: Pure Dart entities, use cases, domain logic algorithms.
- `data`: Firestore repositories, DTO mappers, collection manifests, data source streams.

### 2.3. Presentation Features & Shell
- `auth`: Multiplatform login, registration, password recovery, session state.
- `navigation`: Drawer, BottomNavigationBar, AdaptiveNavigationRail, AppShell.
- `dashboard`: Telemetry cards, KPI summaries, operational logs.
- `pos`: Point-of-Sale terminal, cart management, checkout modals.
- `billiards`: Table state tracking, hourly billing timers, game logs.
- `cash`: Shift opening/closing, cash drawer balancing, discrepancy audits.
- `inventory`: Stock items, adjustments, low-stock alerts, category filters.
- `kitchen`: Kitchen Display System (KDS), ticket status queues, item preparation cards.
- `invoices`: Invoice creation, history tables, billing calculations.
- `purchasing`: Purchase orders, supplier requisitions, item lines.
- `reports`: Financial analytics, sales aggregation, export mechanisms.
- `users`: User management, RBAC assignment, staff profiles.
- `settings`: Business configuration, hardware printers, global preferences.
- `onboarding`: First-time setup wizard, business unit initialization.

---

## 3. Mandatory Message Structure

```gitcommit
<type>(<scope>): <imperative summary under 72 characters>

<Detailed explanation of motivation and context. Why was this change made?
What problem does it solve, and what architectural invariants are upheld?>

Technical Highlights:
- Bulleted list item 1 detailing concrete implementation details.
- Bulleted list item 2 highlighting state management or persistence changes.
- Bulleted list item 3 noting tests, validations, or zero-breakage assurances.
```
